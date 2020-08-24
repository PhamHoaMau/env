echo "=====Stop container======="
docker stop orderer.jwclab.com peer0.org1.jwclab.com peer0.org2.jwclab.com 

echo "=====Remove container======="
docker rm orderer.jwclab.com peer0.org1.jwclab.com peer0.org2.jwclab.com 

echo "Creating peer0.org1.jwclab.com"
docker run --env-file /home/mau/fabric-samples/test-network/env1.txt -v /var/run/:/host/var/run/ -v /home/mau/fabric-samples/test-network/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/msp:/etc/hyperledger/fabric/msp -v /home/mau/fabric-samples/test-network/organizations/peerOrganizations/org1.jwclab.com/peers/peer0.org1.jwclab.com/tls:/etc/hyperledger/fabric/tls -v /home/mau/fabric-samples/test-network/channel-artifacts/:/etc/hyperledger/fabric/channel-artifacts -v /home/mau/fabric-samples/test-network/organizations/peerOrganizations/org1.jwclab.com/users/:/etc/hyperledger/fabric/users/ -v /home/mau/fabric-samples/chaincode:/etc/hyperledger/fabric/chaincode -v /home/mau/fabric-samples/test-network/bins/:/etc/hyperledger/fabric/bins --name peer0.org1.jwclab.com --network jwcnetwork -w /etc/hyperledger/fabric/ -itd hyperledger/fabric-peer:2.2.0

echo "Creating peer0.org2.jwclab.com"
docker run --env-file /home/mau/fabric-samples/test-network/env2.txt -v /var/run/:/host/var/run/ -v /home/mau/fabric-samples/test-network/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/msp:/etc/hyperledger/fabric/msp -v /home/mau/fabric-samples/test-network/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com/tls:/etc/hyperledger/fabric/tls -v /home/mau/fabric-samples/test-network/channel-artifacts/:/etc/hyperledger/fabric/channel-artifacts -v /home/mau/fabric-samples/test-network/organizations/peerOrganizations/org2.jwclab.com/users/:/etc/hyperledger/fabric/users/ -v /home/mau/fabric-samples/chaincode:/etc/hyperledger/fabric/chaincode -v /home/mau/fabric-samples/test-network/bins/:/etc/hyperledger/fabric/bins --name peer0.org2.jwclab.com --network jwcnetwork -w /etc/hyperledger/fabric/ -itd hyperledger/fabric-peer:2.2.0 

echo "Creating orderer.jwclab.com"
docker run --env-file /home/mau/fabric-samples/test-network/env.txt -v /home/mau/fabric-samples/test-network/system-genesis-block/genesis.block:/var/hyperledger/orderer/orderer.genesis.block -v /home/mau/fabric-samples/test-network/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/msp:/var/hyperledger/orderer/msp -v /home/mau/fabric-samples/test-network/organizations/ordererOrganizations/jwclab.com/orderers/orderer.jwclab.com/tls/:/var/hyperledger/orderer/tls -v /home/mau/fabric-samples/test-network/channel-artifacts/:/var/hyperledger/orderer/channel-artifacts --name orderer.jwclab.com --network jwcnetwork -itd hyperledger/fabric-orderer:2.2.0

docker network inspect jwcnetwork 
docker exec -ti peer0.org1.jwclab.com sh

