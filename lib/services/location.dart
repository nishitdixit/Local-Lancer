import 'dart:async';
import 'dart:math';

import 'package:WorkListing/models/userLocation.dart';
import 'package:location/location.dart';

class LocationService {
  UserLocation _currentLocation;
  var location = Location();
  bool _locationPermission = false;

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        _locationPermission = true;
        print('current permission $_locationPermission');
      }
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      LocationData userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }

  StreamSubscription<UserLocation> get locationStream {
    return location.onLocationChanged.map((locationData) {
      print(locationData.longitude);
      return UserLocation(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      );
    }).listen((event) {});
  }

double toRadians(double degree) 
{ 
    // cmath library in C++  
    // defines the constant 
    // M_PI as the value of 
    // pi accurate to 1e-30 
double one_deg = (pi) / 180; 
    return (one_deg * degree); 
} 

 double distance(double lat1, double long1,double lat2,double long2) 
{ 
    // Convert the latitudes  
    // and longitudes 
    // from degree to radians. 
    lat1 = toRadians(lat1); 
    long1 = toRadians(long1); 
    lat2 = toRadians(lat2); 
    long2 = toRadians(long2); 
      
    // Haversine Formula 
   double dlong = long2 - long1; 
  double dlat = lat2 - lat1; 
  
  double ans = pow(sin(dlat / 2), 2) +  
                          cos(lat1) * cos(lat2) *  
                          pow(sin(dlong / 2), 2); 
  
    ans = 2 * asin(sqrt(ans)); 
  
    // Radius of Earth in  
    // Kilometers, R = 6371 
    // Use R = 3956 for miles 
double R = 6371; 
      
    // Calculate the result 
    ans = ans * R; 
  
    return ans; 
} 




}
