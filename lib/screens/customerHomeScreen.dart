import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/models/userLocation.dart';
import 'package:WorkListing/screens/serviceMenDetailPage.dart';
import 'package:WorkListing/services/geoHash.dart';
import 'package:WorkListing/services/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomerHomeScreen extends StatefulWidget {
  LocalUserData localUserData;
  CustomerHomeScreen({this.localUserData});
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserLocation userLocation;
  LocalUserData currentUser;
  LocationService locationService = LocationService();
  double distance;
  String geoHash;
  bool isQueryReady = false;

  Query currentLocationQuery;

  @override
  void initState() {
    super.initState();
    makeQuery();
    currentUser = widget.localUserData;
  }

  makeQuery() async {
    await getLocation().then((value) => currentLocationQuery =
            FirebaseDatabase.instance.reference().child('serviceMen')
        .orderByChild("geoHash")
        .startAt(geoHash)
        );
    setState(() {
      isQueryReady = true;
    });
  }

  Future<void> getLocation() async {
    userLocation = await locationService.getLocation();
    geoHash = Geohash.encode(latitude:userLocation.latitude,longitude: userLocation.longitude,codeLength:6 );
    print(geoHash);
    print(userLocation.latitude);
    print(userLocation.longitude);
  }

  Widget buildServiceMenCard(Map serviceMenLocation) {
    distance = locationService.distance(
        userLocation.latitude,
        userLocation.longitude,
        serviceMenLocation['lat'],
        serviceMenLocation['long']);
    return Container(
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      child: Card(
        
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        color: Colors.white,
        child: ListTile(
          onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ServiceMenDetailsPage(phoneNo: serviceMenLocation['phoneNo'],)));},
          leading: CircleAvatar(
            backgroundImage: NetworkImage(serviceMenLocation['profilePic']),
          ),
          title: Text(
            serviceMenLocation['name'],
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: 1),
          ),
          subtitle: Text(
            serviceMenLocation['phoneNo'],
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 15, letterSpacing: 1),
          ),
          trailing: Text(
            '${distance.truncate()} KMs away',
            style: TextStyle(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // currentUser=Provider.of<LocalUserData>(context);
    print(userLocation);
    print('built');
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return SafeArea(
      child: Scaffold(
          drawer: drawer(heightPiece,widthPiece),
          appBar: AppBar(
            // backgroundColor: Colors.white,
            title: Text('Service Mens List'),
          ),
          body: (!isQueryReady)
              ? Center(child: CircularProgressIndicator())
              : FirebaseAnimatedList(
                  query: currentLocationQuery,
                  // padding: EdgeInsets.only(top: 25),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map serviceMenLocationDetails = snapshot.value;
                    return buildServiceMenCard(serviceMenLocationDetails);
                  },
                )),
    );
  }

  Drawer drawer(double heightPiece,double widthPiece) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: heightPiece*4,
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
                            maxRadius: widthPiece*2,
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
              onPressed: () {_auth.signOut();},
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
