block_number=$1

docker exec peer0.org1.example.com peer channel fetch $block_number -c mychannel
docker cp peer0.org1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/mychannel_$block_number.block ./block
configtxgen -inspectBlock ./block/mychannel_$block_number.block > ./block/block$block_number.json