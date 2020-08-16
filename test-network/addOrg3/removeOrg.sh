#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This script extends the Hyperledger Fabric test network by adding
# adding a third organization to the network
#

# prepending $PWD/../bin to PATH to ensure we are picking up the correct binaries
# this may be commented out to resolve installed version of tools if desired

echo
echo "###############################################################"
echo "####### Generate and submit config tx to add Org3 #############"
echo "###############################################################"
docker exec Org3cli ./scripts/org3-scripts/removeOrg3.sh
if [ $? -ne 0 ]; then
  echo "ERROR !!!! Unable to create config tx"
  exit 1
fi

  


