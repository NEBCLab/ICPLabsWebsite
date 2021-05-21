import Principal "mo:base/Principal";

module {
  
  public type UserId = Principal;
  
  public type Article ={
    writer : Principal;
    title : Text;
    body : Text;
    time : Text;
  };

  public type Profile = {
    id: UserId;
    name: Text;
    email: Text;
  };
  
  public type NewProfile = {
    name: Text;
    email: Text;
  }
};