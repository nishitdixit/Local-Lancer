import 'package:WorkListing/models/localUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneAuth {
  String phoneNo;
  String verificationId;
  String smsOTP;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  LocalUser _userFromLocalUser(user) {
    return (user != null)
        ? LocalUser(
            displayName: user.displayName,
            uid: user.uid,
            phoneNo: user.phoneNumber,
            photoUrl: user.photoURL)
        : null;
  }

  Stream<LocalUser> get user {
    return _auth
        .authStateChanges()
        .map((firebaseUser) => _userFromLocalUser(firebaseUser));
  }

  Future<void> verifyPhone(BuildContext context, String phoneNo) async {
    this.phoneNo = phoneNo;
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
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            print(phoneAuthCredential);
            Navigator.of(context).pop();

            await _auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      print(e);
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
                    // Navigator.of(context)
                    //     .pushReplacementNamed('/serviceMenHomeScreen');
                  } else {
                    signIn(context);
                  }
                },
              )
            ],
          );
        });
  }

  signIn(context) async {
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
      // Navigator.of(context).pushReplacementNamed('/serviceMenHomeScreen');
    } catch (e) {
      print(e);
    }
  }
}
