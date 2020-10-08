import 'dart:async';

import 'package:WorkListing/models/userLocation.dart';
import 'package:location/location.dart';

class LocationService {
  UserLocation _currentLocation;
    var location = Location();
  bool _locationPermission=false;

  LocationService(){
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        _locationPermission=true;
        print('current permission $_locationPermission');
      }});
  }


  Future<UserLocation> getLocation() async {
    try {
      LocationData userLocation = await location.getLocation();
      // print(userLocation);
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }







  // StreamController<UserLocation> _locationController =
  //     StreamController<UserLocation>();

  // Stream<UserLocation> get locationStream => _locationController.stream;

  // LocationService() {
  //   // Request permission to use location
  //   location.requestPermission().then((granted) {
  //     if (granted==PermissionStatus.granted) {
  //       // If granted listen to the onLocationChanged stream and emit over our controller
  //       location.onLocationChanged.listen((locationData) {
  //         if (locationData != null) {
  //           _locationController.add(UserLocation(
  //             latitude: locationData.latitude,
  //             longitude: locationData.longitude,
  //           ));
  //         }
  //       });
  //     }
  //   });
  // }
















  StreamSubscription<UserLocation> get locationStream {
    // Request permission to use location
    // location.requestPermission().then((granted) {
      
      // print(_locationPermission);
      // if (_locationPermission) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        return location.onLocationChanged
        .map((locationData) {
          print(locationData.longitude);
          return UserLocation(
            latitude: locationData.latitude,
            longitude: locationData.longitude,
          );
        }).listen((event) { });
      // }
  //     return _currentLocation;
  // });
    
  }
}
