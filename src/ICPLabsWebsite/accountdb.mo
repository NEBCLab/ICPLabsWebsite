import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import types "./types"


module{

    type Profile = types.Profile;
    type NewProfile = types.NewProfile;
    type UserId = types.UserId;

    public class AccountHashMap(){
        private var hashMap = HashMap.HashMap<UserId, Profile>(1,Principal.equal,Principal.hash);

        public func createAccount(uid: UserId, profile : NewProfile) {
            var tmp = makeProfile(uid, profile);
            hashMap.put(uid, tmp);
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
    }
}
       
