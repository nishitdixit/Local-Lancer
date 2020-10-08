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
  Query currentLocationQuery;

  @override
  void initState() {
    super.initState();
    getLocation();
    currentLocationQuery =
        FirebaseDatabase.instance.reference().child('serviceMen');
  }

  void getLocation() async {
    userLocation = await LocationService().getLocation();
    print(userLocation.latitude);
    print(userLocation.longitude);
  }

  Widget buildServiceMenCard(Map serviceMenLocation) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(serviceMenLocation['profilePic']),
        ),
        title: Text(serviceMenLocation['name']),
        subtitle: Text(serviceMenLocation['phoneNo']),
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
                  child: FirebaseAnimatedList(
      query: currentLocationQuery,
      // padding: EdgeInsets.only(top: 25),
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
              Map serviceMenLocationDetails=snapshot.value;
          return buildServiceMenCard(serviceMenLocationDetails);
      },
    ),
        )
     
        );
  }
}
