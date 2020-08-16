#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# This script is designed to be run in the org3cli container as the
# first step of the EYFN tutorial.  It creates and submits a
# configuration transaction to add org3 to the test network
#

CHANNEL_NAME="mychannel"
DELAY="3"
TIMEOUT="10"
VERBOSE="false"
# : ${CHANNEL_NAME:="mychannel"}
# : ${DELAY:="3"}
# : ${TIMEOUT:="10"}
# : ${VERBOSE:="false"}
COUNTER=1
MAX_RETRY=5
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/tlscacerts/tlsca.jwclab.com-cert.pem
PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/ca.crt
PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/ca.crt
PEER0_ORG3_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org3.jwclab.com/peers/peer0.org3.jwclab.com/tls/ca.crt
setOrdererGlobals() {
  CORE_PEER_LOCALMSPID="OrdererMSP"
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/tlscacerts/tlsca.jwclab.com-cert.pem
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/jwclab.com/users/Admin@jwclab.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  ORG=$1
  if [ $ORG -eq 1 ]; then
    CORE_PEER_LOCALMSPID="Org1MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.jwclab.com/users/Admin@org1.jwclab.com/msp
    CORE_PEER_ADDRESS=peer0.org1.jwclab.com:7051
  elif [ $ORG -eq 2 ]; then
    CORE_PEER_LOCALMSPID="Org2MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org2.jwclab.com/users/Admin@org2.jwclab.com/msp
    CORE_PEER_ADDRESS=peer0.org2.jwclab.com:9051
  elif [ $ORG -eq 3 ]; then
    CORE_PEER_LOCALMSPID="Org3MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org3.jwclab.com/users/Admin@org3.jwclab.com/msp
    CORE_PEER_ADDRESS=peer0.org3.jwclab.com:11051
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}

# import environment variables
# ./envVarCLI.sh


# fetchChannelConfig <channel_id> <output_json>
# Writes the current channel config for a given channel to a JSON file
fetchChannelConfig() {
  ORG=$1
  CHANNEL=$2
  OUTPUT=$3

  setOrdererGlobals

  setGlobals $ORG

  echo "Fetching the most recent configuration block for the channel"
  set -x
  peer channel fetch config config_block.pb -o orderer.jwclab.com:7050 --ordererTLSHostnameOverride orderer.jwclab.com -c $CHANNEL --tls --cafile $ORDERER_CA
  set +x

  echo "Decoding config block to JSON and isolating config to ${OUTPUT}"
  set -x
  configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config >"${OUTPUT}"
  set +x
}

# createConfigUpdate <channel_id> <original_config.json> <modified_config.json> <output.pb>
# Takes an original and modified config, and produces the config update tx
# which transitions between the two
createConfigUpdate() {
  CHANNEL=$1
  ORIGINAL=$2
  MODIFIED=$3
  OUTPUT=$4

  set -x
  configtxlator proto_encode --input "${ORIGINAL}" --type common.Config >original_config.pb
  configtxlator proto_encode --input "${MODIFIED}" --type common.Config >modified_config.pb
  configtxlator compute_update --channel_id "${CHANNEL}" --original original_config.pb --updated modified_config.pb >config_update.pb
  configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate >config_update.json
  echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
  configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope >"${OUTPUT}"
  set +x
}

# signConfigtxAsPeerOrg <org> <configtx.pb>
# Set the peerOrg admin of an org and signing the config update
signConfigtxAsPeerOrg() {
  PEERORG=$1
  TX=$2
  setGlobals $PEERORG
  set -x
  peer channel signconfigtx -f "${TX}"
  set +x
}

echo
echo "========= Creating config transaction to remove org3 =========== "
echo

# Fetch the config for the channel, writing it to config.json
fetchChannelConfig 1 ${CHANNEL_NAME} config.json
cat config.json
# Modify the configuration to append the new org
set -x
jq 'del(.channel_group.groups.Application.groups.Org3MSP)' config.json > modified_config.json
set +x
cat modified_config.json
# Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to org3_update_in_envelope.pb
createConfigUpdate ${CHANNEL_NAME} config.json modified_config.json org3_update_in_envelope.pb

echo
echo "========= Config transaction to remove org3 to network created ===== "
echo

echo "Signing config transaction"
echo
signConfigtxAsPeerOrg 1 org3_update_in_envelope.pb

echo
echo "========= Submitting transaction from a different peer (peer0.org2) which also signs it ========= "
echo
setGlobals 2
set -x
peer channel update -f org3_update_in_envelope.pb -c ${CHANNEL_NAME} -o orderer.jwclab.com:7050 --ordererTLSHostnameOverride orderer.jwclab.com --tls --cafile ${ORDERER_CA}
set +x

echo
echo "========= Config transaction to remove org3 to network submitted! =========== "
echo


echo "====fetch channel====="
echo "====from org1==="
setGlobals 1
peer channel getinfo -c mychannel
echo "====from org2==="
setGlobals 2
peer channel getinfo -c mychannel
echo "====from org3==="
setGlobals 3
peer channel getinfo -c mychannel
exit 0
