import 'dart:typed_data';

import 'package:WorkListing/components/components.dart';
import 'package:WorkListing/services/firebaseStorageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WorkListing/services/PhoneAuth.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String phoneNo;
  Uint8List logoImageData;
  FirebaseStorageService storage = FirebaseStorageService();
  FocusNode _blankFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    storage
        .getSystemImageByName(imageName: 'logo')
        .then((value) => setState(() {
              logoImageData = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      // backgroundColor: Color(0xffF57921),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_blankFocusNode);
        },
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  height: heightPiece * 5,
                  width: widthPiece * 8,
                  child: (logoImageData == null)
                      ? CircularProgressIndicator()
                      : Image.memory(logoImageData, fit: BoxFit.fitWidth),
                  // Image.network(
                  //     'https://firebasestorage.googleapis.com/v0/b/worklisting-61803.appspot.com/o/_DefaultImage%2FPngItem_5922090.png?alt=media&token=696c1cf9-c12f-4ec7-a12f-2bdedf727e39',
                  //     fit: BoxFit.fitWidth),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthPiece),
                  child: customTextFormField(
                      labelText: 'Enter 10 digit mobile no.',
                      inputType: TextInputType.phone,
                      onsaved: ((value) {
                        phoneNo = '+91' + value;
                      }),
                      prefixIcon: Icon(Icons.phone),
                      validate: (value) {
                        if (value.length < 10 || value.length > 10) {
                          return "Invalid";
                        } else {
                          print(value.length);
                          _formKey.currentState.save();
                          return null;
                        }
                      })),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthPiece),
                child: customButton(
                    buttonText: 'Send OTP',
                    onPressed: () {
                      _formKey.currentState.validate();
                      PhoneAuth().verifyPhone(context, phoneNo);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
