function createOrderer {

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/jwclab.com

echo
echo "Register and enroll for orderer"
echo
mkdir -p organizations/ordererOrganizations/jwclab.com

echo 'NodeOUs:
Enable: true
ClientOUIdentifier:
    Certificate: cacerts/ca.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: client
PeerOUIdentifier:
    Certificate: cacerts/ca.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: peer
AdminOUIdentifier:
    Certificate: cacerts/ca.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: admin
OrdererOUIdentifier:
    Certificate: cacerts/ca.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/crypto-config/ordererOrganizations/jwclab.com/msp/config.yaml



#crypto material for orderer
fabric-ca-client enroll -u http://admin:adminpw@178.128.60.176:32769

fabric-ca-client register -u http://admin:adminpw@178.128.60.176:32769 --id.name peer0 --id.secret peer0pw --id.type peer

fabric-ca-client register -u http://admin:adminpw@178.128.60.176:32769 --id.name org1admin --id.secret org1adminpw --id.type admin

fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp --csr.hosts peer0.org1.jwclab.com

fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls --enrollment.profile tls --csr.hosts peer0.org1.jwclab.com --csr.hosts 178.128.60.176

fabric-ca-client enroll -u http://org1admin:org1adminpw@178.128.60.176:32769 -M ${PWD}/crypto-config/ordererOrganizations/jwclab.com/users/Admin@org1.jwclab.com/msp

mkdir -p ${PWD}/crypto-config/ordererOrganizations/jwclab.com/msp/cacerts/
mkdir -p ${PWD}/crypto-config/ordererOrganizations/jwclab.com/msp/admincerts/
mkdir -p ${PWD}/crypto-config/ordererOrganizations/jwclab.com/msp/tlscacerts/
mkdir -p ${PWD}/crypto-config/ordererOrganizations/jwclab.com/ca/
mkdir -p ${PWD}/crypto-config/ordererOrganizations/jwclab.com/tlsca/


cp ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/cacerts/* ${PWD}/crypto-config/ordererOrganizations/jwclab.com/msp/cacerts/ca.jwclab.com-cert.pem
cp ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/cacerts/* ${PWD}/crypto-config/ordererOrganizations/jwclab.com/ca/ca.jwclab.com-cert.pem
cp ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/keystore/* ${PWD}/crypto-config/ordererOrganizations/jwclab.com/ca/pri_sk
cp ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/jwclab.com/msp/tlscacerts/tlsca.jwclab.com-cert.pem
cp ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/jwclab.com/tlsca/tlsca.jwclab.com-cert.pem
cp ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/keystore/* ${PWD}/crypto-config/ordererOrganizations/jwclab.com/tlsca/pri_sk
cp ${PWD}/crypto-config/ordererOrganizations/jwclab.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/jwclab.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/jwclab.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@178.128.60.176:32769 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/178-128-60-176-32769.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/178-128-60-176-32769.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/178-128-60-176-32769.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/178-128-60-176-32769.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/jwclab.com/orderers
  mkdir -p organizations/ordererOrganizations/jwclab.com/orderers/jwclab.com

  mkdir -p organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@178.128.60.176:32769 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp --csr.hosts orderer.jwclab.com --csr.hosts 178.128.60.176 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@178.128.60.176:32769 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls --enrollment.profile tls --csr.hosts orderer.jwclab.com --csr.hosts 178.128.60.176 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/tlscacerts/tlsca.jwclab.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/tlscacerts/tlsca.jwclab.com-cert.pem

  mkdir -p organizations/ordererOrganizations/jwclab.com/users
  mkdir -p organizations/ordererOrganizations/jwclab.com/users/Admin@jwclab.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@178.128.60.176:32769 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/jwclab.com/users/Admin@jwclab.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/jwclab.com/users/Admin@jwclab.com/msp/config.yaml

}



function createOrg1 {

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.jwclab.com/

echo
echo "Register and enroll for org1"
echo
mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/msp/

echo 'NodeOUs:
Enable: true
ClientOUIdentifier:
    Certificate: cacerts/ca.org1.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: client
PeerOUIdentifier:
    Certificate: cacerts/ca.org1.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: peer
AdminOUIdentifier:
    Certificate: cacerts/ca.org1.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: admin
OrdererOUIdentifier:
    Certificate: cacerts/ca.org1.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/msp/config.yaml

#crypto material for org1
fabric-ca-client enroll -u http://admin:adminpw@178.128.60.176:32769

fabric-ca-client register -u http://admin:adminpw@178.128.60.176:32769 --id.name peer0 --id.secret peer0pw --id.type peer

fabric-ca-client register -u http://admin:adminpw@178.128.60.176:32769 --id.name org1admin --id.secret org1adminpw --id.type admin

fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp --csr.hosts peer0.org1.jwclab.com

fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls --enrollment.profile tls --csr.hosts peer0.org1.jwclab.com --csr.hosts 178.128.60.176

fabric-ca-client enroll -u http://org1admin:org1adminpw@178.128.60.176:32769 -M ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/users/Admin@org1.jwclab.com/msp


mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/msp/cacerts/
mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/msp/admincerts/
mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/msp/tlscacerts/
mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/ca/
mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/tlsca/


cp ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/msp/cacerts/ca.org1.jwclab.com-cert.pem
cp ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/ca/ca.org1.jwclab.com-cert.pem
cp ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/ca/pri_sk
cp ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/msp/tlscacerts/tlsca.org1.jwclab.com-cert.pem
cp ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/tlsca/tlsca.org1.jwclab.com-cert.pem
cp ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/tlsca/pri_sk
cp ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/config.yaml

}

function createOrg2 {

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.jwclab.com/

echo
echo "Register and enroll for org2"
echo

mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/msp/

echo 'NodeOUs:
Enable: true
ClientOUIdentifier:
    Certificate: cacerts/ca.org2.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: client
PeerOUIdentifier:
    Certificate: cacerts/ca.org2.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: peer
AdminOUIdentifier:
    Certificate: cacerts/ca.org2.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: admin
OrdererOUIdentifier:
    Certificate: cacerts/ca.org2.jwclab.com-cert.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/msp/config.yaml



#crypto material for org1
fabric-ca-client enroll -u http://admin:adminpw@178.128.60.176:32769

fabric-ca-client register -u http://admin:adminpw@178.128.60.176:32769 --id.name peer0 --id.secret peer0pw --id.type peer

fabric-ca-client register -u http://admin:adminpw@178.128.60.176:32769 --id.name org1admin --id.secret org1adminpw --id.type admin

fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp --csr.hosts peer0.org2.jwclab.com

fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls --enrollment.profile tls --csr.hosts peer0.org2.jwclab.com --csr.hosts 178.128.60.176

fabric-ca-client enroll -u http://org1admin:org1adminpw@178.128.60.176:32769 -M ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/users/Admin@org2.jwclab.com/msp

mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/msp/cacerts/
mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/msp/admincerts/
mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/msp/tlscacerts/
mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/ca/
mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/tlsca/


cp ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/msp/cacerts/ca.org2.jwclab.com-cert.pem
cp ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/ca/ca.org2.jwclab.com-cert.pem
cp ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/ca/pri_sk
cp ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/msp/tlscacerts/tlsca.org2.jwclab.com-cert.pem
cp ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/tlsca/tlsca.org2.jwclab.com-cert.pem
cp ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/tlsca/pri_sk
cp ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/config.yaml

}