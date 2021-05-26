import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import types "./types";
import Error "mo:base/Error";

module{

    type Profile = types.Profile;
    type NewProfile = types.NewProfile;
    type UserId = types.UserId;

    public class AccountHashMap(){
        private var hashMap = HashMap.HashMap<UserId, Profile>(1,Principal.equal,Principal.hash);
        private var friendMap = HashMap.HashMap<UserId, HashMap.HashMap<UserId, Profile>>(1, Principal.equal, Principal.hash);

        public func createAccount(uid: UserId, profile : NewProfile) {
            var tmp = makeProfile(uid, profile);
            hashMap.put(uid, tmp);
            friendMap.put(uid, HashMap.HashMap<UserId, Profile>(1, Principal.equal, Principal.hash));
        };

        public func deleteAccount(uid: UserId) {
            hashMap.delete(uid);
        };

        public func updateAccount(uid : UserId, profile : NewProfile) {
            let existing = hashMap.get(uid);
            var tmp = makeProfile(uid, profile);
            hashMap.put(uid, tmp); 
        };
        
        public func existAccount(uid: UserId): Bool{
            let existing = hashMap.get(uid);
            switch(existing) {
                case (?existing) {true};
                case (null) {false};
            }
        };
        
        public func getProfile(uid: UserId): ?Profile{
            hashMap.get(uid);
        };
        
        public func makeProfile(uid: UserId, profile: NewProfile) :Profile{
            {
                id = uid;
                name = profile.name;
                email = profile.email;
            };
        };
        
        /**
        * @param user_uid user's UserId(Principal)
        * @param friend_uid add friend's UserId(Principal)
        * @return true : add successfully, false : add failed 
        */
        public func addFriend(user_uid : UserId, friend_uid : UserId) : Bool{
            switch (friendMap.get(user_uid)){
                case null {
                    return false;
                };
                case (?friends){
                    friends.put(friend_uid, switch(getProfile(friend_uid)){
                        case null { return false;};
                        case (?profile) { profile };
                    });
                    friendMap.put(user_uid, friends);
                };
            };
            true
        };


        /**
        * @param user_uid user's UserId(Principal)
        * @param friend_uid delete friend's UserId(Principal)
        * @return true : delete successfully, false : delete failed 
        */
        public func deleteFriend(user_uid : UserId, friend_uid : UserId) : Bool{
            switch(friendMap.get(user_uid)){
                case (?friends) {
                    friends.delete(friend_uid);
                    friendMap.put(user_uid, friends);
                    true
                };
                case _ { false };
            }
        };

        /**
        * @param user_uid user's UserId(Principal)
        * @param friend_uid friend's UserId(Principal)
        * @return ?Profile : search successfully -> ?Profile, search failed -> null
        */
        public func getFriendProfile(user_uid : UserId, friend_uid : UserId) : ?Profile{
            switch(friendMap.get(user_uid)){
                case null { null };
                case (?friends){
                    switch (friends.get(friend_uid)){
                        case null { null };
                        case (?profile){ ?profile };
                    };
                };
            }
        };

    }
}
       
