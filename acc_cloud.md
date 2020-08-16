ssh root@128.199.151.251
JWCLab@2020#Identity

ssh root@188.166.218.149
Blk@2020#Intern

ssh root@188.166.218.144
Blk@2020#Intern

#master
ssh root@188.166.191.60
Blk@2020#Intern

#org1

docker pull jwclabacr/org1-test

docker run --name org1-test -ti jwclabacr/org1-test

docker exec -ti org1-test sh

#org2

docker pull jwclabacr/org2-test

docker run --name org2-test -ti jwclabacr/org2-test

docker exec -ti org2-test sh


