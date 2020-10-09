
import 'localUser.dart';
import 'package:WorkListing/services/geoHash.dart';

class RealtimeLocation {
  String name;
  final String phoneNo;
  String profilePic;
  double lat;
  double long;
  dynamic geoHash;
  RealtimeLocation({this.phoneNo, this.lat, this.long});

  Map toMap(LocalUserData localUserData) {
    return {
      'name': localUserData.name,
      'phoneNo': localUserData.phoneNo,
      'profilePic': localUserData.profilePicUrl,
      'geoHash':Geohash.encode(lat, long),
      'lat': lat,
      'long': long,
    };
  }
}
