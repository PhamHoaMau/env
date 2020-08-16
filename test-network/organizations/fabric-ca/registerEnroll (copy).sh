

function createOrg1 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org1.jwclab.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.jwclab.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u http://admin:adminpw@178.128.60.176:32769 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x


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
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  # echo
  # echo "Register user"
  # echo
  # set -x
  # fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org1.jwclab.com/peers
  mkdir -p organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp --csr.hosts peer0.org1.jwclab.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls --enrollment.profile tls --csr.hosts peer0.org1.jwclab.com --csr.hosts 178.128.60.176 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org1.jwclab.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.jwclab.com/tlsca/tlsca.org1.jwclab.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org1.jwclab.com/ca
  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.jwclab.com/ca/ca.org1.jwclab.com-cert.pem

  # mkdir -p organizations/peerOrganizations/org1.jwclab.com/users
  # mkdir -p organizations/peerOrganizations/org1.jwclab.com/users/User1@org1.jwclab.com

  # echo
  # echo "## Generate the user msp"
  # echo
  # set -x
	# fabric-ca-client enroll -u http://user1:user1pw@178.128.60.176:32769 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.jwclab.com/users/User1@org1.jwclab.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # set +x

  mkdir -p organizations/peerOrganizations/org1.jwclab.com/users/Admin@org1.jwclab.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u http://org1admin:org1adminpw@178.128.60.176:32769 -M ${PWD}/organizations/peerOrganizations/org1.jwclab.com/users/Admin@org1.jwclab.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.jwclab.com/users/Admin@org1.jwclab.com/msp/config.yaml
  
  mv ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/cacerts/178-128-60-176-32769.pem ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/cacerts/ca.org1.jwclab.com-cert.pem
  mv ${PWD}/organizations/peerOrganizations/org1.jwclab.com/users/Admin@org1.jwclab.com/msp/cacerts/178-128-60-176-32769.pem ${PWD}/organizations/peerOrganizations/org1.jwclab.com/users/Admin@org1.jwclab.com/msp/cacerts/ca.org1.jwclab.com-cert.pem

  mv ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/keystore/pri_sk 
  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/keystore/pri_sk ${PWD}/organizations/peerOrganizations/org1.jwclab.com/ca/pri_sk
  cp ${PWD}/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp/keystore/pri_sk ${PWD}/organizations/peerOrganizations/org1.jwclab.com/tlsca/pri_sk
  mv ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org1.jwclab.com/msp/keystore/pri_sk

}



function createOrg2 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org2.jwclab.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.jwclab.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u http://admin:adminpw@178.128.60.176:32769 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

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
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  # echo
  # echo "Register user"
  # echo
  # set -x
  # fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org2.jwclab.com/peers
  mkdir -p organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp --csr.hosts peer0.org2.jwclab.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u http://peer0:peer0pw@178.128.60.176:32769 -M ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls --enrollment.profile tls --csr.hosts peer0.org2.jwclab.com --csr.hosts 178.128.60.176 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org2.jwclab.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.jwclab.com/tlsca/tlsca.org2.jwclab.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org2.jwclab.com/ca
  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.jwclab.com/ca/ca.org2.jwclab.com-cert.pem

  # mkdir -p organizations/peerOrganizations/org2.jwclab.com/users
  # mkdir -p organizations/peerOrganizations/org2.jwclab.com/users/User1@org2.jwclab.com

  # echo
  # echo "## Generate the user msp"
  
  # echo
  # set -x
	# fabric-ca-client enroll -u http://user1:user1pw@178.128.60.176:32769 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.jwclab.com/users/User1@org2.jwclab.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # set +x

  mkdir -p organizations/peerOrganizations/org2.jwclab.com/users/Admin@org2.jwclab.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u http://org2admin:org2adminpw@178.128.60.176:32769 -M ${PWD}/organizations/peerOrganizations/org2.jwclab.com/users/Admin@org2.jwclab.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.jwclab.com/users/Admin@org2.jwclab.com/msp/config.yaml

  mv ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/cacerts/178-128-60-176-32769.pem ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/cacerts/ca.org2.jwclab.com-cert.pem
  mv ${PWD}/organizations/peerOrganizations/org2.jwclab.com/users/Admin@org2.jwclab.com/msp/cacerts/178-128-60-176-32769.pem ${PWD}/organizations/peerOrganizations/org2.jwclab.com/users/Admin@org2.jwclab.com/msp/cacerts/ca.org2.jwclab.com-cert.pem

  mv ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/keystore/pri_sk 
  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/keystore/pri_sk ${PWD}/organizations/peerOrganizations/org2.jwclab.com/ca/pri_sk

  cp ${PWD}/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp/keystore/pri_sk ${PWD}/organizations/peerOrganizations/org1.jwclab.com/tlsca/pri_sk

  mv ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org2.jwclab.com/msp/keystore/pri_sk

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
  fabric-ca-client enroll -u http://admin:adminpw@178.128.60.176:32769 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

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
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/jwclab.com/orderers
  mkdir -p organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u http://orderer:ordererpw@178.128.60.176:32769 -M ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp --csr.hosts orderer.jwclab.com --csr.hosts 178.128.60.176 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u http://orderer:ordererpw@178.128.60.176:32769 -M ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls --enrollment.profile tls --csr.hosts orderer.jwclab.com --csr.hosts 178.128.60.176 --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/tlscacerts/tlsca.jwclab.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/admincerts

  mkdir ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/tlscacerts/tlsca.jwclab.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/jwclab.com/tlsca
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/tlsca/tlsca.jwclab.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/jwclab.com/ca
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/cacerts/* ${PWD}/organizations/ordererOrganizations/jwclab.com/ca/ca.jwclab.com-cert.pem


  mkdir -p organizations/ordererOrganizations/jwclab.com/users
  mkdir -p organizations/ordererOrganizations/jwclab.com/users/Admin@jwclab.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u http://ordererAdmin:ordererAdminpw@178.128.60.176:32769 -M ${PWD}/organizations/ordererOrganizations/jwclab.com/users/Admin@jwclab.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  mv ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/cacerts/178-128-60-176-32769.pem ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/cacerts/ca.jwclab.com-cert.pem
  mv ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/keystore/* ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/keystore/pri_sk
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/jwclab.com/users/Admin@jwclab.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/keystore/pri_sk ${PWD}/organizations/ordererOrganizations/jwclab.com/ca/pri_sk 
  cp ${PWD}/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp/keystore/pri_sk ${PWD}/organizations/ordererOrganizations/jwclab.com/tlsca/pri_sk
  mv ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/keystore/* ${PWD}/organizations/ordererOrganizations/jwclab.com/msp/keystore/pri_sk
}
