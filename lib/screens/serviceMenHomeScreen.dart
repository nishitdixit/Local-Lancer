import 'package:WorkListing/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ServiceMenHomeScreen extends StatefulWidget {
  @override
  _ServiceMenHomeScreenState createState() => _ServiceMenHomeScreenState();
}

class _ServiceMenHomeScreenState extends State<ServiceMenHomeScreen> {
  
   FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(body: Stack(
      children: [backgroundClip(heightPiece, widthPiece),
        Center(
          child: RaisedButton(
                    child: Text('Logout'),
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.of(context).pushReplacementNamed('/logInScreen');
                    },
                  ),
        ),
      ],
    ),);
  }
}