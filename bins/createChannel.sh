#!/bin/sh
export ORG_CONTEXT=$1

export FABRIC_LOGGING_SPEC=INFO

export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@org$ORG_CONTEXT.jwclab.com/msp

export ORDERER_ADDRESS=orderer-clusterip:7050

peer channel create -c mychannel -f ../config/mychannel.tx --outputBlock ../config/mychannel.block -o $ORDERER_ADDRESS

peer channel join -b ../config/mychannel.block -o $ORDERER_ADDRESS

peer channel update -f ../config/Org${ORG_CONTEXT}MSPanchors.tx -c mychannel -o $ORDERER_ADDRESS

