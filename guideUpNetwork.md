cd test-network 

./network down

./network up createChannel -ca

./network deployCC

#upgradeChaincode

--console 1

./upgradeChaincode 1 

--console 2

./approveChaincode 2 true

(tham số 1,2 để set biến môi trường của org đó).
