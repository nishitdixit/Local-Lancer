import 'localUser.dart';

class RealtimeLocation {
  String name;
  final String phoneNo;
  String profilePic;
  double lat;
  double long;
  RealtimeLocation({this.phoneNo, this.lat, this.long});

  Map toMap(LocalUserData localUserData) {
    return {
      'name': localUserData.name,
      'phoneNo': localUserData.phoneNo,
      'profilePic': localUserData.profilePicUrl,
      'lat': lat,
      'long': long,
    };
  }
}
