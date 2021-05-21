import types "./types";
import accountdb "./accountdb";
import articledb "./articledb";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import List "mo:base/List";


actor ICPlabswebsite {
    type UserId = types.UserId;
    type Profile = types.Profile;
    type NewProfile = types.NewProfile;
    type Article = types.Article;
    private var accountDB = accountdb.AccountHashMap();
    private var articleDB = articledb.ArticleDB();

    public shared(msg) func checkExist() : async Bool {
        ignore(accountDB.existAccount(msg.caller));
        true;
    };

    public shared(msg) func createAccount(userProfile: NewProfile) : async Bool{
       if(accountDB.existAccount(msg.caller)){
           return false;
       };
       accountDB.createAccount(msg.caller, userProfile);
       true;
    };

    public shared(msg) func updateAccount(userProfile: NewProfile) : async Bool{
        accountDB.createAccount(msg.caller, userProfile);
        true;
    };

    public shared(msg) func deleteAccount() : async Bool{
        accountDB.deleteAccount(msg.caller);
        true;
    };

    public shared (msg) func getOwnId() : async UserId{
        msg.caller;
    };

    public shared (msg) func getProfile() : async ?Profile{
        accountDB.getProfile(msg.caller);
    };

    /**
        get article from article database
        @param title article title
        @return article ?list
    */
    public query func getArticle(title : Text) : async ?List.List<Article>{
        articleDB.getArticle(title)
    }; 

    public query func getArticleFromTime(time : Text) : async ?List.List<Article>{
        articleDB.getArticleFromTime(time)
    };

    /**
    * upload article
    * @param article : writer upload article
    * @return Bool : wheather successful or fail to upload the article
    */
    public shared(msg) func uploadArticle(article : Article) : async Bool {
        //articleDB.uploadArticle(tempArticle2);
        switch (articleDB.uploadArticle(article)){
            case (true, true) { true };
            case (_){ false };
        }
    };

    public shared(msg) func writerGetAllArticles() : async List.List<Article>{
        switch (articleDB.writerGetAllArticles(msg.caller)) {
            case null {null};
            case (?articles) {articles};
        }
    };


    public shared(msg) func writerGetSpecificArticle(title : Text) : async Article{
        switch(articleDB.writerGetSpecificArticle(msg.caller, title)){
            case null {throw Error.reject("no such article")};
            case (?article) {article};
        }
    };


}
