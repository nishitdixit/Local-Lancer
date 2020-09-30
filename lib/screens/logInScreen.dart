import 'package:WorkListing/components/components.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WorkListing/services/PhoneAuth.dart';


class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String phoneNo;

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      // backgroundColor: Color(0xffF57921),
      body: Stack(
        children: [
          backgroundClip(heightPiece, widthPiece),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                    height: heightPiece * 5,
                    width: widthPiece *8,
                    child:
                        Image(image: AssetImage('assets/images/service.png'),fit:BoxFit.fitWidth)),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthPiece),
                  child: customTextField(
                      context, 'Enter 10 digit mobile no.', TextInputType.phone,
                      ((value) {
                    phoneNo = '+91' + value;
                  }),Icon(Icons.phone))),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthPiece),
                child: RaisedButton(
                  padding: const EdgeInsets.only(bottom: 6.0, top: 8.0),
                  color: Colors.white,
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    PhoneAuth().verifyPhone(context,phoneNo);
                    // otherwise.
                  },
                  child: Text(
                    'Send OTP',
                    style: TextStyle(color: Color(0xffF57921)),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
