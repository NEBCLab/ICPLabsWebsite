echo " ========== stop network ========== "
dfx stop
echo " ========== finished ========== "
echo " ========== prepare for the dfx.json ========== "
mv ./dfx.json ./dfx_main.json
mv ./dfx_test.json ./dfx.json
echo " ========== prepare for the dfx.json finished ========== "
echo ""
echo " ========== start the network ========== "
dfx start --background
echo "network started"
echo ""
echo "deploy the canisters into network"
dfx deploy
echo " ========== deployment finished ========== "
echo "----------------------------------------------------------------------------------------------------------"
echo " ========== test account datatabse ========== "
echo ""
echo " ========== test create account ========== "
dfx canister call accountDBTest testCreateAccount
echo " ========== test create account finished ========== "
echo ""
echo " ========== test update account account ========== "
dfx canister call accountDBTest testUpdateAccount
echo " ========== test update account account finished ========== "
echo ""
echo " ========== test get account profile ========== "
dfx canister call accountDBTest testGetProfile
echo " ========== test get account profile finished ========== "
echo ""
echo " ========== test add friend account ========== "
dfx canister call accountDBTest testAddFriend
echo " ========== test add friend account finished ========== "
echo ""
echo " ========== test get friend profile  ========== "
dfx canister call accountDBTest testGetFriendProfile
echo " ========== test get friend profile finished  ========== "
echo ""
echo " ========== test delete friend account ========== "
dfx canister call accountDBTest testDeleteFriend
echo " ========== test delete friend account finished ========== "
echo ""
echo " ========== test account database finished ========== "
echo "----------------------------------------------------------------------------------------------------------"
echo " ========== test article database ========== "
echo " ========== test upload article ========== "
dfx canister call articleDBTest test_uploadArticle
echo " ========== test upload article finished ========== "
echo ""
echo " ========== articles in database now : ( test writer Get All Articles function )  ========== "
dfx canister call articleDBTest test_writerGetAllArticles
echo " ========== test writer Get All Articles finished ========== "
echo ""
echo " ========== test writer Get Specific Article, default is \" test file 2 \"  ========== "
dfx canister call articleDBTest test_writerGetSpecificArticle
echo " ========== test writer Get Specific Article finished ========== "
echo ""
echo " ========== test update Article, default is \"test file 2 \" ========== "
dfx canister call articleDBTest test_updateArticle
echo " ========== update Article finished ========== "
echo ""
echo " ========== articles in article database : ========== "
dfx canister call articleDBTest test_writerGetAllArticles
echo " ========== test update Article finished ========== "
echo ""
echo " ========== test upload name collision article test name : \" test file 1 \" ========== "
dfx canister call articleDBTest test_nameCollision
echo " ========== upload name collision Article finished ========== "
echo ""
echo " ========== articles in article database : ========== "
dfx canister call articleDBTest test_writerGetAllArticles
echo " ========== upload name collision Article finished ========== "
echo " ========== get article in article database : article name : \" test file 1 \" : ========== "
dfx canister call articleDBTest getArticle
echo " ========== get article in article database finished : ========== "
echo " ========== test upload name collision Article finished ========== "
echo ""
echo " ========== test delete article, default is test file 1 ========== "
dfx canister call articleDBTest test_deleteArticle
echo " ========== delete article finished ========== "
echo " ========== articles in article database : ========== "
dfx canister call articleDBTest test_writerGetAllArticles
echo " ========== delete article finished ========== "
echo " ========== test article database finished ========== "
echo "----------------------------------------------------------------------------------------------------------"
echo " ========== stop local network ========== "
dfx stop
echo " ========== stop local network finished ========== "
echo "recover local files"
mv ./dfx.json ./dfx_test.json
mv ./dfx_main.json ./dfx.json
echo " ========== recover finished, thank you ========== "
