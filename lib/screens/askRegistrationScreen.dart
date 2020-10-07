
import 'package:WorkListing/screens/customerRegistration.dart';
import 'package:WorkListing/screens/serviceMenRegistration.dart';
import 'package:flutter/material.dart';



class AskRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ServiceMenRegistration()));},
            child: Text('Register as Service Men')),
             RaisedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomerRegistration()));},
            child: Text('Register as Customer'))
          ],
        ),
      )
    );
  }
}