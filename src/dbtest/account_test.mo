import AccountDB "./accountdb";
import Types "./types";

actor account_test{
    type UserId = Types.UserId;
    type Profile = Types.Profile;
    type NewProfile = Types.NewProfile;

    private var testAccountDB = AccountDB.AccountHashMap();

    public shared(msg) func testCreateAccount() : async Bool {
        var testUserProfile : Profile = {
            id = msg.caller;
            name = "test name";
            email = "@email";
        };
        testAccountDB.createAccount(msg.caller, testUserProfile);
        true
    };

    public shared(msg) func testUpdateAccount() : async Bool{
        var testUserProfile : Profile = {
            id = msg.caller;
            name = "test update name";
            email = "test update @email";
        };

        testAccountDB.updateAccount(msg.caller, testUserProfile);
        true
    };

    public shared(msg) func testGetProfile() : async ?Profile{
        testAccountDB.getProfile(msg.caller)
    };


    public shared(msg) func testAddFriend() : async Bool{
        testAccountDB.addFriend(msg.caller, msg.caller)
    };
    
    public shared(msg) func testDeleteFriend() : async Bool{
        testAccountDB.deleteFriend(msg.caller, msg.caller)
    };

    public shared(msg) func testGetFriendProfile() : async ?Profile{
        testAccountDB.getFriendProfile(msg.caller, msg.caller)
    };

};