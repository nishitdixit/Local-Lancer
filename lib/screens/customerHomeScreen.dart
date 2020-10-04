import 'package:WorkListing/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      body: Stack(
        children: [
          backgroundClip(heightPiece, widthPiece),
          Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('This is Customer Home Screen'),
                RaisedButton(
                  child: Text('Logout'),
                  onPressed: () async {
                    await _auth.signOut();
                    // Navigator.of(context).pushReplacementNamed('/logInScreen');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
