import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import types "./types";
import Array "mo:base/Array";
import Error "mo:base/Error";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob"; 
import Prim "mo:prim";
import Hash "mo:base/Hash";

module{
    type Article = types.Article;
 
    public class ArticleDB(){
        // article ID Text -> article body Blob
        private let articleMap = HashMap.HashMap<Nat, Blob>(1, Nat.equal, Hash.hash);
        
        // article title -> article ID
        private var title_id = HashMap.HashMap<Text, List.List<Nat>>(1, Text.equal, Text.hash);
        
        // id - title
        private var id_title = HashMap.HashMap<Nat, Text>(1, Nat.equal, Hash.hash);

        // article ID Text -> article writer
        private var id_writer = HashMap.HashMap<Nat, Principal>(1, Nat.equal, Hash.hash);

        // writer Principal -> id
        private var writer_id = HashMap.HashMap<Principal, List.List<Nat>>(1, Principal.equal, Principal.hash);

        // article time -> article ID
        private var time_id = HashMap.HashMap<Text, List.List<Nat>>(1, Text.equal, Text.hash);

        // article ID -> article time
        private var id_time = HashMap.HashMap<Nat, Text>(1, Nat.equal, Hash.hash);

        // present article ID
        private var _ID : Nat = 1;

        //private search function 
        /**
        *  search article id form article tile and article writer
        */
        private func getArticleId(title : Text, writer : Principal) : ?Nat{
            switch(writer_id.get(writer), title_id.get(title)){
                case(?wid_, ?tid){
                    // for all element in title id ,search writer id
                    //should use binary search
                    var articleId_ : Nat = 0;
                    var widArray = List.toArray<Nat>(tid).vals();
                    // find writer article ID
                    for (id in widArray){
                        switch(List.find<Nat>(wid_, func(ele_ : Nat) : Bool{
                            if (ele_ == id){
                                true
                            }else{
                                false
                            }
                        })){
                            case null {()};
                            case (?number) {articleId_ := number};
                        };
                    };
                    ?articleId_
                };
                case(_){
                    null
                };            
            }
        };

        //make an article from articleId_
        /**
        * @param articleId_ : article's id
        */
        private func makeArticle(articleId_ : Nat) : ?Article{
            switch (articleMap.get(articleId_)){
                case null {null};
                case (?articleBody){
                    ?{
                        //get writer
                        writer = switch(id_writer.get(articleId_)){
                            case(?writ_){
                                writ_
                            };
                            case(_){
                                return null;
                            };
                        };

                        //get title
                        title = switch(id_title.get(articleId_)){
                            case(?tit_){
                                tit_
                            };
                            case(_){
                                ""
                            };
                        };

                        //get time
                        time = switch(id_time.get(articleId_)){
                            case(?tim_){
                                tim_
                            };
                            case(_){
                                ""
                            };
                        };

                        //get body
                        body = switch(Text.decodeUtf8(articleBody)){
                            case(?text){
                                text
                            };
                            case(_){""};
                        };     
                    }
                };
            }
        };

        //writer function
        // writer upload article
        public func uploadArticle(article : Article) : Bool{
            //this article ID
            var articleId_ : Nat = _ID;
            _ID += 1;
            
            //put the article ID , article body into map
            articleMap.put(articleId_, Text.encodeUtf8(article.body));
            
            //put the id - title into map
            id_title.put(articleId_, article.title);

            //put the title ID and title into map
            switch(title_id.get(article.title)){
                case(?list){
                    var tempList = List.append(list, List.make<Nat>(articleId_));
                    title_id.put(article.title, tempList);
                };
                case(_){
                    title_id.put(article.title, List.make<Nat>(articleId_));   
                };
            };
            
            //put the id - time into map
            id_time.put(articleId_, article.time);

            //put the time ID and time into map
            switch(time_id.get(article.time)){
                case(?list){
                    var tempList = List.append(list, List.make<Nat>(articleId_));
                    time_id.put(article.time, tempList);
                };
                case(_){
                    time_id.put(article.time, List.make<Nat>(articleId_));
                };
            };

            //put id_writer into id_writer map 
            id_writer.put(articleId_, article.writer);
            
            //put writer and article id into writer_id
            switch(writer_id.get(article.writer)){
                case(?list){
                    var tempList = List.append(list, List.make<Nat>(articleId_));
                    writer_id.put(article.writer, tempList);
                }; 
                case(_){
                    writer_id.put(article.writer, List.make<Nat>(articleId_));
                };
            };
            true
        };
        
        //writer get specific title article
        public func writerGetSpecificArticle(writer : Principal, title : Text) : ?Article{
            switch(getArticleId(title, writer)){
                case null {null};
                case (?articleId_) {
                    // return article
                    makeArticle(articleId_)
                };
            }
        };

        /**
        * get all article of one writer
        * @param writer : Principal : writer's Principal
        * @return 
        **/
        public func writerGetAllArticles(writer :  Principal) : ?List.List<Article>{
            // articles
            var articles : List.List<Article> = List.nil<Article>();
            switch(writer_id.get(writer)){
                case(?idList){
                    // this code paragraph is redundancy should be improved 
                    let append_ = func _append (id : Nat){
                        var temp = List.make<Article>(
                            switch(makeArticle(id)){
                                    case null {return;};
                                    case (?article) {article};
                            }
                        );
                        //put the article to the list
                        articles := List.append<Article>(articles, temp);
                    };
                    List.iterate<Nat>(idList, append_);
                    ?articles
                };
                case(_){
                    //should throw Error
                    null
                };
            };
        };
        
        
        //writer delete article
        public func deleteArticle(title : Text, writer : Principal) : Bool{
            switch(writer_id.get(writer), title_id.get(title)){
                case(?wid_, ?tid){
                    // for all element in title id ,search writer id
                    //should use binary search
                    var articleId_ : Nat = 0;
                    var widArray = List.toArray<Nat>(tid).vals();
                    // find writer article ID
                    for (id in widArray){
                        switch(List.find<Nat>(wid_, func(ele_ : Nat) : Bool{
                            if (ele_ == id){
                                true
                            }else{
                                false
                            }
                        })){
                            case null {()};
                            case (?number) {articleId_ := number};
                        };
                    };

                    //get artilce time
                    var time : Text = switch(id_time.get(articleId_)){
                        case null {""};
                        case (?time){time}; 
                    };
                    articleMap.delete(articleId_);
                    id_time.delete(articleId_);
                    id_title.delete(articleId_);
                    id_writer.delete(articleId_);
                    //title id delete 
                    //time id delete
                    //writer id delete

                    true
                };
                case(_){
                    false
                };            
            }    
        };
        

        /**
        * update the article : 
        * description
        *    writer can only update his article if the article exists
        *    when use this databse function, main function should inspect:
        *    getArticle()
        * 
        * @param title  the title of the article
        * @param writer the writer of the article
        * @param newArticle new article
        */

        public func updateArticle(title : Text, writer : Principal, newArticle : Article) : Bool{
            var articleId_ : Nat = switch(getArticleId(title, writer)){
                case null {0};
                case (?id) {id};
            };
            ignore articleMap.replace(articleId_, Text.encodeUtf8(newArticle.body));
            ignore id_time.replace(articleId_, newArticle.time);
            ignore id_title.replace(articleId_, newArticle.title);
            true
        };


        //reader function
        //get article from title
        public func getArticle(title : Text) : ?List.List<Article>{
            var articles : List.List<Article> = List.nil<Article>();
            let append_ = func _append (id : Nat){
                var temp = List.make<Article>(
                    switch(makeArticle(id)){
                        case null {return};
                        case (?article){article};
                    }
                );
                //put the article to the list
                articles := List.append<Article>(articles, temp);
            };

            // return List -> articles            
            switch(title_id.get(title)){
                //get article id list
                case(?idList){
                    //find the article's id, title, time, body
                    List.iterate<Nat>(idList, append_);
                    //return articles list
                    ?articles
                };
                //no such title : article
                case(_){
                    ?List.nil<Article>()
                };

            };
        };


        //get article from time <<< search : a range of time 
        public func getArticleFromTime(time : Text) : ?List.List<Article>{
            var articles : List.List<Article> = List.nil<Article>();
            let append_ = func _append (id : Nat){
                var temp = List.make<Article>(
                    switch(makeArticle(id)){
                        case null {return};
                        case (?article){article};
                    }
                );
                //put the article to the list
                articles := List.append<Article>(articles, temp);
            };

            //return List -> articles
            switch(time_id.get(time)){
                //get article id list
                case(?idList){
                    //find the article's id, title, time, body
                    List.iterate<Nat>(idList, append_);
                    //return articles list
                    ?articles
                };
                //no such time : article
                case(_){
                    ?List.nil<Article>()
                };
            };
        };

        

        

        // //delete the article
        // public func deleteArticle(title : Text, writer : Principal) : Bool{
        //     true
        // };


        //database "like" search
        //public func likeSearch(title : Text) : List.LIst<Article>{};

        //database topic search

    }


};

