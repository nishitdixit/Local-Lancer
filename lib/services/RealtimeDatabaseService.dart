import 'package:WorkListing/services/firestoreService.dart';
import 'package:WorkListing/services/location.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService{
  String nodeName = "skill1";
  FirebaseDatabase database = FirebaseDatabase.instance;
  Map currentLocationData;

  RealtimeDatabaseService({this.currentLocationData});

  updateLocation(){
    database.reference().child('serviceMen/${currentLocationData['phoneNo']}').set(currentLocationData);
  }


  // var currentUser=FirestoreService().currentUserDocFromDBMappedIntoLocalUserData;
  // var locationSS= LocationService().locationStream.onData((data) {print(data.latitude); print(data.longitude);});


}