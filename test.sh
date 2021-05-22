echo " ========== stop network ========== "
dfx stop
echo " ========== finished ========== "
echo " ========== prepare for the dfx.json ========== "
mv ./dfx.json ./dfx_main.json
mv ./dfx_test.json ./dfx.json
echo " ========== prepare for the dfx.json finished ========== "
echo " ========== start the network ========== "
dfx start --background
echo "network started"
echo "deploy the canisters into network"
dfx deploy
echo " ========== deployment finished ========== "
echo " ========== test article database ========== "
echo " ========== test upload article ========== "
dfx canister call ICPLabsWebsite test_uploadArticle
echo " ========== test upload article finished ========== "
echo " ========== articles in database now : ( test writer Get All Articles function )  ========== "
dfx canister call ICPLabsWebsite test_writerGetAllArticles
echo " ========== test writer Get All Articles finished ========== "
echo " ========== test writer Get Specific Article, default is \" test file 2 \"  ========== "
dfx canister call ICPLabsWebsite test_writerGetSpecificArticle
echo " ========== test writer Get Specific Article finished ========== "
echo " ========== test update Article, default is \"test file 2 \" ========== "
dfx canister call ICPLabsWebsite test_updateArticle
echo " ========== test update Article finished ========== "
echo " ========== articles in article database : ========== "
dfx canister call ICPLabsWebsite test_writerGetAllArticles
echo " ========== test delete article, default is test file 1 ========== "
dfx canister call ICPLabsWebsite test_deleteArticle
echo " ========== test delete article finished ========== "
echo " ========== articles in article database : ========== "
dfx canister call ICPLabsWebsite test_writerGetAllArticles
echo " ========== test article database finished ========== "
echo " ========== stop local network ========== "
dfx stop
echo " ========== stop local network finished ========== "
echo "recover local files"
mv ./dfx.json ./dfx_test.json
mv ./dfx_main.json ./dfx.json
echo " ========== recover finished, thank you ========== "
