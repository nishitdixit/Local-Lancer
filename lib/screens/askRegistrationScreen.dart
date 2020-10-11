import 'package:WorkListing/components/components.dart';
import 'package:WorkListing/screens/customerRegistration.dart';
import 'package:WorkListing/screens/serviceMenRegistration.dart';
import 'package:flutter/material.dart';

class AskRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
        body: Center(
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              customButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ServiceMenRegistration()));
                  },
                  buttonText: 'Register as Service Men'),
              SizedBox(height: heightPiece),
              customButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CustomerRegistration()));
                  },
                  buttonText: 'Register as Customer'),
            ],
          ),
        ),
      ),
    ));
  }
}
