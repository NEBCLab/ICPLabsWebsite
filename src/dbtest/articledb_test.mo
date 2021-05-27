import ArticleDB "./articledb";
import Types "./types";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import Array "mo:base/Array";
import Error "mo:base/Error";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob"; 
import Prim "mo:prim";
import Hash "mo:base/Hash";

actor articledb_test{

    type Article = Types.Article;

    private var articleDB : ArticleDB.ArticleDB = ArticleDB.ArticleDB();

    private var testArticle : Article = {
        writer = Principal.fromText("ftri5-7aziy-4upmh-vm4h3-iustk-hhoht-awx5u-enn7y-u4slb-75dar-nae");
        title = "test file 1";
        body = "article body";
        time = "2021-05-18";
    };

    public shared(msg) func test_uploadArticle() : async Bool {
        var tempArticle1 : Article = {
        writer = msg.caller;
        title = "test file 1";
        body = "article body";
        time = "2021-05-18";
        };
        //articleDB.uploadArticle(tempArticle1);
    
        var tempArticle2 : Article = {
        writer = msg.caller;
        title = "test file 2";
        body = "In this course,students will learn the fundamentals of distributed systems programming by building on top of the open auction platform we previously created in the Web Development section. Module 1 serves as an intro to this unit, providing a primer for Distributed Systems by reviewing distribution transparency and distributed time. Module 2 introduces students to the idea of \"locking\", borrowed from database management systems, which ensures that users cannot simultaneously bid on the same auction. In Module 3, students implement a feature that ensures bids are processed in the correct order. Finally, in Module 4 students explore how they can maintain bid \"secrecy\" in a distributed system through the use of hashing.";
        time = "2021-05-21";
        };
        //articleDB.uploadArticle(tempArticle2);
        switch (articleDB.uploadArticle(tempArticle1), articleDB.uploadArticle(tempArticle2)){
            case (true, true) { true };
            case (_){ false };
        }
    };

    public shared(msg) func test_writerGetAllArticles() : async List.List<Article>{
        switch (articleDB.writerGetAllArticles(msg.caller)) {
            case null {null};
            case (?articles) {articles};
        }
    };

    public shared(msg) func test_writerGetSpecificArticle() : async Article{
        switch(articleDB.writerGetSpecificArticle(msg.caller, "test file 2")){
            case null {throw Error.reject("no such article")};
            case (?article) {article};
        }
    };

    public shared(msg) func test_updateArticle() : async Bool{
        var tempArticle3 : Article = {
        writer = msg.caller;
        title = "test file 3";
        body = "article body 3";
        time = "2021-05-22";
        };
        articleDB.updateArticle("test file 2", msg.caller, tempArticle3)
    };

    public shared(msg) func test_deleteArticle() : async Bool{
        articleDB.deleteArticle("test file 1", msg.caller)
    };

    public shared(msg) func test_nameCollision() : async Bool{
        var tempArticle3 : Article = {
        writer = msg.caller;
        title = "test file 1";
        body = "name Collision test file 1 body";
        time = "2021-05-25";
        };
        articleDB.updateArticle("test file 1", msg.caller, tempArticle3)
    };

    public shared(msg) func getArticle() : async List.List<Article>{
        switch (articleDB.getArticle("test file 1")) {
            case null {null};
            case (?list) {list};
        }
    };

};