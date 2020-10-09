import 'dart:async';
import 'dart:math';

import 'package:WorkListing/models/userLocation.dart';
import 'package:location/location.dart';

class LocationService {
  UserLocation _currentLocation;
  var location = Location();
  bool _locationPermission = false;
//   double earth = 6378.137; //radius of the earth in kilometer
// var m = (1 / ((2 * pi / 360) * earth) / 1000);  //1 meter in degree

// number of km per degree = ~111km (111.32 in google maps, but range varies
  //  between 110.567km at the equator and 111.699km at the poles)
// 1km in degree = 1 / 111.32km = 0.0089
// 1m in degree = 0.0089 / 1000 = 0.0000089

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

  StreamSubscription<UserLocation> get locationStream {
    // Request permission to use location
    // location.requestPermission().then((granted) {

    // print(_locationPermission);
    // if (_locationPermission) {
    // If granted listen to the onLocationChanged stream and emit over our controller
    return location.onLocationChanged.map((locationData) {
      print(locationData.longitude);
      return UserLocation(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      );
    }).listen((event) {});
  }

  maxMinLatLong({UserLocation currentLocation, int kiloMeters}) {
    double coef = kiloMeters * 0.0089;
    return MaxMinLatLong(
      maxLatitude: currentLocation.latitude + coef,
      minLatitude: currentLocation.latitude - coef,
      maxLongitude: currentLocation.longitude +
          coef / cos(currentLocation.latitude * 0.018),
      minLongitude: currentLocation.longitude -
          coef / cos(currentLocation.latitude * 0.018),
    );
  }
}
