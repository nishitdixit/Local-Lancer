import 'dart:io';
import 'package:WorkListing/components/components.dart';
import 'package:WorkListing/widgets/bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class CustomerRegistration extends StatefulWidget {
  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  PickedFile _profilePic;
  String _name;
  String _address;
  String _aadharNumber;
  @override
  Widget build(BuildContext context) {
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      // bottomNavigationBar: followButton(),
      body: Stack(
        children: <Widget>[
          backgroundClip(heightPiece, widthPiece),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height / 6.0,
            // left: 76.0,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _profilePic==null?AssetImage("assets/images/service.png"):Image.file(File(_profilePic.path)),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(80.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(5.0, 6.0),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 20.0,
                      child: InkWell(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: ((builder) => BottomSheetWidget((image){
                                _profilePic=image;Navigator.of(context).pop();
                              })));
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.0,
                ), Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthPiece),
                  child: customTextField(
                      context, 'Enter Full Name', TextInputType.phone,
                      ((value) {
                    _name = value;
                  }),Icon(Icons.phone))), Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthPiece),
                  child: customTextField(
                      context, 'Enter your address', TextInputType.phone,
                      ((value) {
                    _address =  value;
                  }),Icon(Icons.location_city))), Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthPiece),
                  child: customTextField(
                      context, 'Enter Aadhar Card Number', TextInputType.phone,
                      ((value) {
                    _aadharNumber =  value;
                  }),Icon(Icons.credit_card_outlined),))],
            ),
          ),
        ],
      ),
    );
  }


}
