# import utils
. scripts/envVar.sh
org=$1
setGlobals $org
echo $CORE_PEER_MSPCONFIGPATH
echo $CORE_PEER_ADDRESS