import 'package:WorkListing/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    print(phoneNo);
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 40),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/serviceMenHomeScreen');
          },
          verificationFailed: (FirebaseAuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  var user = _auth.currentUser;
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed('/serviceMenHomeScreen');
                  } else {
                    signIn();
                  }
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User currentUser = _auth.currentUser;
      assert(userCredential.user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/serviceMenHomeScreen');
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  void initState() {
    Firebase.initializeApp();
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
                  }))),
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
                    verifyPhone();
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
