import 'package:WorkListing/models/userLocation.dart';
import 'package:WorkListing/services/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserLocation userLocation;
  LocationService locationService = LocationService();
  MaxMinLatLong maxMinLatLong;
  bool isQueryReady = false;

  Query currentLocationQuery;

  @override
  void initState() {
    super.initState();
    makeQuery();
  }

  makeQuery() async {
    await getLocation().then((value) => makeQueryLatLong().then((value) =>
        currentLocationQuery = FirebaseDatabase.instance
            .reference()
            .child('serviceMen')
            // .orderByChild('lat')
            // .startAt(maxMinLatLong.minLatitude)
            // .endAt(maxMinLatLong.maxLatitude)
            .orderByChild("phoneNo")
            .startAt('+919532')
            // .endAt(maxMinLatLong.maxLongitude)
            ));
    setState(() {
      isQueryReady = true;
    });
  }

  Future<void> getLocation() async {
    userLocation = await locationService.getLocation();
    print(userLocation.latitude);
    print(userLocation.longitude);
  }

  Future<void> makeQueryLatLong() async {
    maxMinLatLong = await locationService.maxMinLatLong(
        currentLocation: userLocation, kiloMeters: 120);
    print(maxMinLatLong.minLongitude);
    print(maxMinLatLong.maxLongitude);
  }

  Widget buildServiceMenCard(Map serviceMenLocation) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(serviceMenLocation['profilePic']),
        ),
        title: Text(serviceMenLocation['name']),
        subtitle: Text(serviceMenLocation['phoneNo']),
        trailing: Column(
          children: [
            Text('${serviceMenLocation['lat']}'),
            Text('${serviceMenLocation['long']}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(userLocation);
    print('built');
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
        body: SafeArea(
      child: (!isQueryReady)
          ? Center(child: CircularProgressIndicator())
          : FirebaseAnimatedList(
              query: currentLocationQuery,
              // padding: EdgeInsets.only(top: 25),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map serviceMenLocationDetails = snapshot.value;
                return buildServiceMenCard(serviceMenLocationDetails);
              },
            ),
    ));
  }
}
