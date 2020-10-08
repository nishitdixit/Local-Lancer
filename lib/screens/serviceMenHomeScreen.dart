import 'dart:async';

import 'package:WorkListing/components/components.dart';
import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/models/realtimeLocation.dart';
import 'package:WorkListing/models/userLocation.dart';
import 'package:WorkListing/services/RealtimeDatabaseService.dart';
import 'package:WorkListing/services/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceMenHomeScreen extends StatefulWidget {
  LocalUserData localUserData;
  ServiceMenHomeScreen({this.localUserData});
  @override
  _ServiceMenHomeScreenState createState() => _ServiceMenHomeScreenState();
}

class _ServiceMenHomeScreenState extends State<ServiceMenHomeScreen> {
  StreamSubscription<UserLocation> locationSS;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Map currentLocationWithUserDetails;

updateRealtimeLocation(UserLocation userLocation){
  currentLocationWithUserDetails=RealtimeLocation(lat: userLocation.latitude,long: userLocation.longitude).toMap(widget.localUserData);
  RealtimeDatabaseService(currentLocationData: currentLocationWithUserDetails).updateLocation();
}
locationSubscription(){
locationSS=LocationService().locationStream;
   locationSS.onData((userChangedLocation) { 
     updateRealtimeLocation(userChangedLocation);
   });
}
  @override
  void initState() {
    super.initState();
    RealtimeLocation(phoneNo: _auth.currentUser.phoneNumber);
   locationSubscription();
  }
  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is Service Men Home Screen'),
            Text('${LocalUser().phoneNo}'),
            // Text('Data from location Subscription'),
            RaisedButton(
              child: Text('Logout'),
              onPressed: () async {
                locationSS.cancel();
                await _auth.signOut();
                // Navigator.of(context).pushReplacementNamed('/logInScreen');
              },
            ),
            RaisedButton(onPressed: (){locationSS.cancel();})
          ],
        ),
      ),
    );
  }
}
