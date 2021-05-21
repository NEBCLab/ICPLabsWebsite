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

    // writer should be Principal type
    /**
        @param article 
    */
    public shared(msg) func uploadArticle(article : Article) : async Bool{
        if(articleDB.uploadArticle(article)){
            true
        }else{
            false
        }
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

    //public shared(msg) 

}
