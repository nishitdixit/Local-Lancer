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
  LocalUserData currentUser;
  bool trackingPermission = false;
  Map currentLocationWithUserDetails;

  updateRealtimeLocation(UserLocation userLocation) {
    currentLocationWithUserDetails = RealtimeLocation(
            lat: userLocation.latitude, long: userLocation.longitude)
        .toMap(widget.localUserData);
    RealtimeDatabaseService(currentLocationData: currentLocationWithUserDetails)
        .updateLocation();
  }

  locationSubscription() {
    locationSS = LocationService().locationStream;
    locationSS.onData((userChangedLocation) {
      updateRealtimeLocation(userChangedLocation);
    });
  }

  @override
  void initState() {
    super.initState();
    RealtimeLocation(phoneNo: _auth.currentUser.phoneNumber);
    locationSubscription();
    currentUser = widget.localUserData;
  }

  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      drawer: drawer(heightPiece, widthPiece),
      appBar: AppBar(
        title: Text('HomeScreen'),
        actions: [
          Switch(
              value: (locationSS.isPaused) ? false : true,
              onChanged: (locationPermission) {
                setState(() {
                  (locationSS.isPaused)
                      ? locationSS.resume()
                      : locationSS.pause();
                  trackingPermission = locationPermission;
                });
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Image(
                    height: heightPiece * 4,
                    image: (trackingPermission)
                        ? AssetImage('assets/images/happyEmoji.png')
                        : AssetImage('assets/images/sadEmoji.png'))),
            SizedBox(
              height: heightPiece / 2,
            ),
            Text((trackingPermission)
                ? 'You are visible to other people,\n just sit back and relax,\n you may get calls for work......'
                : 'You turned off your visibility,\n no one can find you for work.....'
                ,style: TextStyle(fontFamily: 'Oxygen',fontSize: heightPiece/3)),
            // Text('Data from location Subscription'),
            // RaisedButton(
            //   child: Text('Logout'),
            //   onPressed: () async {
            //     locationSS.cancel();
            //     await _auth.signOut();
            //     // Navigator.of(context).pushReplacementNamed('/logInScreen');
            //   },
            // ),
            // RaisedButton(onPressed: () {
            //   locationSS.cancel();
            // })
          ],
        ),
      ),
    );
  }

  Drawer drawer(double heightPiece, double widthPiece) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: heightPiece * 4,
            child: (currentUser == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser.profilePicUrl),
                            maxRadius: widthPiece * 2,
                          ),
                        ),
                      ),
                      Text(
                        currentUser.name,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(currentUser.phoneNo,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic))
                    ],
                  ),
          ),
          Divider(),
          // Slider(value: null, onChanged: null),
          Divider(),
          FlatButton(
              onPressed: () {
                locationSS.cancel();
                _auth.signOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Logout'),
                  Icon(Icons.logout),
                ],
              ))
        ],
      ),
    ));
  }
}
