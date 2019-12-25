pkill nodeos
cd ./code/contract

eosiocpp -g paybank.abi paybank.cpp
eosiocpp -o paybank.wasm paybank.cpp

eosiocpp -g fastidentity.abi fastidentity.cpp
eosiocpp -o fastidentity.wasm fastidentity.cpp

eosiocpp -g payaccount.abi payaccount.cpp
eosiocpp -o payaccount.wasm payaccount.cpp

eosiocpp -g order.abi order.cpp
eosiocpp -o order.wasm order.cpp

eosiocpp -g pay.abi pay.cpp
eosiocpp -o pay.wasm pay.cpp

sleep 2
cd ../../../eosio/eos
nodeos --delete-all-blocks --verbose-http-errors > nodeos.log &
sleep 3

cleos wallet unlock -n paynetwork --password PW5JPEsoNpUtPanhVj1v7gDeyNs4NXSx6b69T1aBvksNRpYXV64Hj
cleos create account eosio pay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio order EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio fastidentity EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio paybank EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio payaccount EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio test1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio test2 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio test3 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio test4 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio middear12345 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

sleep 2
cleos set contract eosio.token build/contracts/eosio.token/ eosio.token.wasm eosio.token.abi
cleos set contract fastidentity ../../contract/code/contract fastidentity.wasm fastidentity.abi
cleos set contract payaccount ../../contract/code/contract payaccount.wasm payaccount.abi
cleos set contract order ../../contract/code/contract order.wasm order.abi
cleos set contract pay ../../contract/code/contract pay.wasm pay.abi
cleos set contract paybank ../../contract/code/contract paybank.wasm paybank.abi


sleep 2
cleos push action eosio.token create '["eosio.token","1000000000000.0000 EOS"]' -p eosio.token
cleos push action eosio.token issue '["test1","100000.0000 EOS",""]' -p eosio.token
cleos push action eosio.token issue '["test2","100000.0000 EOS",""]' -p eosio.token
cleos push action eosio.token issue '["test3","100000.0000 EOS",""]' -p eosio.token
cleos push action eosio.token issue '["test4","100000.0000 EOS",""]' -p eosio.token

cleos set account permission fastidentity account '{"threshold": 1,"keys": [{"key":"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "weight":1}],"accounts": []}' -p fastidentity@active
cleos set action permission fastidentity fastidentity signup account  -p fastidentity@active
cleos set action permission fastidentity fastidentity signin account  -p fastidentity@active

cleos set account permission payaccount account '{"threshold": 1,"keys": [{"key":"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "weight":1}],"accounts": []}' -p payaccount@active
cleos set action permission payaccount payaccount regupacc account  -p payaccount@active
cleos set action permission payaccount payaccount addrecch account  -p payaccount@active
cleos set action permission payaccount payaccount setdefrecch account  -p payaccount@active
cleos set action permission payaccount payaccount addpaych account  -p payaccount@active
cleos set action permission payaccount payaccount setdefpaych account  -p payaccount@active

cleos set account permission paybank admin '{"threshold": 1,"keys": [{"key":"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "weight":1}],"accounts": []}' active -p paybank
cleos set action permission paybank paybank lock admin
cleos set action permission paybank paybank unlock admin
cleos set action permission paybank paybank shiftlocked admin

cleos set account permission order admin '{"threshold": 1,"keys": [{"key":"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "weight":1}],"accounts": []}' active -p order
cleos set action permission order order createorder admin
cleos set action permission order order takeorder admin
cleos set action permission order order finishorder admin
cleos set action permission order order cancelorder admin

cleos set account permission pay admin '{"threshold": 1,"keys": [{"key":"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "weight":1}],"accounts": []}' active -p pay
cleos set action permission pay pay create1 admin
cleos set action permission pay pay confirm4 admin
cleos set action permission pay pay take2 admin
cleos set action permission pay pay recieved2 admin
cleos set action permission pay pay take3 admin
cleos set action permission pay pay recieved4 admin
cleos set action permission pay pay cancel admin
cleos set action permission pay pay approve admin

cleos set account permission pay control '{"threshold": 1,"keys": [{"key":"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "weight":1}],"accounts": [{"permission":{"actor":"pay","permission":"eosio.code"},"weight":1}]}' active -p pay
cleos set action permission pay order createorder control
cleos set action permission pay order takeorder control
cleos set action permission pay order finishorder control
cleos set action permission pay order cancelorder control

cleos set action permission pay paybank lock control
cleos set action permission pay paybank unlock control
cleos set action permission pay paybank shiftlocked control

sleep 2
cleos push action fastidentity init '[""]' -p fastidentity@active

cleos push action fastidentity signup '["100001","test1"]' -p fastidentity@account
cleos push action fastidentity signup '["100002","test2"]' -p fastidentity@account
cleos push action fastidentity signup '["100003","test3"]' -p fastidentity@account
cleos push action fastidentity signup '["100004","test4"]' -p fastidentity@account
cleos push action fastidentity signup '["10019","winless"]' -p fastidentity@account
cleos push action fastidentity signup '["100170","hello"]' -p fastidentity@account
cleos push action fastidentity signup '["10048","daxigua"]' -p fastidentity@account
cleos push action fastidentity signup '["10054","puccahuan"]' -p fastidentity@account
cleos push action fastidentity signup '["100076","888888888888"]' -p fastidentity@account
cleos push action fastidentity signup '["100083","gnufoognufoo"]' -p fastidentity@account
cleos push action fastidentity signup '["100374","sskk"]' -p fastidentity@account

cleos push action eosio.token transfer '["test1","paybank","1000.0000 EOS","010048"]' -p test1
cleos push action eosio.token transfer '["test1","paybank","1000.0000 EOS","010019"]' -p test1
cleos push action eosio.token transfer '["test1","paybank","1000.0000 EOS","100076"]' -p test1
cleos push action eosio.token transfer '["test1","paybank","1000.0000 EOS","100170"]' -p test1
cleos push action eosio.token transfer '["test1","paybank","1000.0000 EOS","100083"]' -p test1
cleos push action eosio.token transfer '["test1","paybank","1000.0000 EOS","010054"]' -p test1
