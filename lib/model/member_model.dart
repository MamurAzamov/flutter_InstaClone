
class Member{
  String uid = "";
  String fullname = "";
  String email = "";

  Member(this.fullname, this.email);

  Member.fromjson(Map<String, dynamic> json)
  : uid = json['uid'],
    fullname = json['fullname'],
    email = json['email'];

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'fullname' : fullname,
    'email' : email,
  };
}