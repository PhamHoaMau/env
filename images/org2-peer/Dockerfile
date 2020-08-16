#Docker file for setting up the acme peer
FROM hyperledger/fabric-peer:2.1

LABEL  maintainer="JWCLab"

#1. Create a folder
RUN mkdir -p /var/hyperledger/config

#2. Copy the crypto for peer crypto
COPY ./test-network/organizations/peerOrganizations/org2.jwclab.com/peers/peer0.org2.jwclab.com /var/hyperledger/peer0.org2.jwclab.com

#3. Copy the crypto for admin crypto
COPY ./test-network/organizations/peerOrganizations/org2.jwclab.com/users /var/hyperledger/users

#4. Copy the anchor peer update tx
COPY ./test-network/channel-artifacts/Org2MSPanchors.tx /var/hyperledger/config/Org2MSPanchors.tx

#5. Copy the channel create tx file
COPY ./test-network/channel-artifacts/mychannel.tx /var/hyperledger/config/mychannel.tx

#6. Copy the core YAML
COPY ./config/core.yaml /var/hyperledger/config/core.yaml

#7. Copy the bins
COPY ./bins /var/hyperledger/bins

#8. Copy the test chaincode
COPY ./chaincode  /var/hyperledger/chaincode

#9. Set the working dir
ENV  ENV="/etc/profile"
RUN  echo "cd /var/hyperledger/bins" >> /etc/profile

#10. Install the jq package - used in scripts
RUN apk update \
 && apk add --no-cache git make musl-dev go jq vim\
 && rm -rf /var/cache/apk/* 

ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

#11. Launch the peer
CMD peer node start
