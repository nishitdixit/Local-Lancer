import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/services/firestoreService.dart';
import 'package:flutter/material.dart';

class ServiceMenDetailsPage extends StatefulWidget {
  String phoneNo;
  ServiceMenDetailsPage({this.phoneNo});

  @override
  _ServiceMenDetailsPageState createState() => _ServiceMenDetailsPageState();
}

class _ServiceMenDetailsPageState extends State<ServiceMenDetailsPage> {
  LocalUserData serviceMenData;

  @override
  void initState() {
    super.initState();

    FirestoreService()
        .getServiceMenDetailsByPhoneNo(widget.phoneNo)
        .then((value) => setState(() {
              serviceMenData = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;

    return SafeArea(
      child: Scaffold(
        body: (serviceMenData == null)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
              child: Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.end,mainAxisSize: MainAxisSize.min,
                      children: [profileImage(heightPiece),
                        Text(
                          'Name : ${serviceMenData.name}',
                          style: TextStyle(fontSize: heightPiece / 3),
                        ),
                        Text('Contact : ${serviceMenData.phoneNo}',style: TextStyle(fontSize: heightPiece / 3),),
                        Text('Gender : ${serviceMenData.gender}',style: TextStyle(fontSize: heightPiece / 3),),
                        Text('Skill : ${serviceMenData.skill}',style: TextStyle(fontSize: heightPiece / 3),),
                        Text('Experience : ${serviceMenData.experience}',style: TextStyle(fontSize: heightPiece / 3),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Flexible profileImage(double heightPiece) {
    return Flexible(
      child: Container(
          // width: widthPiece*3,
          height: heightPiece * 5,
          margin: EdgeInsets.all(10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(serviceMenData.profilePicUrl))),
    );
  }
}
