

class LocalUser{
  final String displayName;
  final String uid;
  final String phoneNo;
  final String photoUrl;

  LocalUser({this.displayName,this.phoneNo,this.photoUrl,this.uid});


  
}

class LocalUserData{
  String uid;
  String name;
  String phoneNo;
  String aadharNo;
  String age;
  String address;
  String profilePicUrl;
  String experience;
  String gender;
  String skill;
  String role;

  LocalUserData({this.uid,this.name,this.phoneNo,this.address,this.age,this.aadharNo,this.experience,this.profilePicUrl,this.gender,this.skill,this.role});



}