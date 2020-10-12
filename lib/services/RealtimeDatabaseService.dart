
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class RealtimeDatabaseService{
  String nodeName = "skill1";
  FirebaseDatabase database = FirebaseDatabase.instance;
  Map currentLocationData;

  RealtimeDatabaseService({this.currentLocationData});

  updateLocation(){
    database.reference().child('serviceMen/${currentLocationData['phoneNo']}').set(currentLocationData);
  }

deleteLocation({@required String phoneNo}){
  database.reference().child('serviceMen/$phoneNo').remove();
}

}