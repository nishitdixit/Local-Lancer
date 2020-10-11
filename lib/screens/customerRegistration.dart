import 'dart:io';
import 'dart:typed_data';
import 'package:WorkListing/components/components.dart';
import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/services/firebaseStorageService.dart';
import 'package:WorkListing/services/firestoreService.dart';
import 'package:WorkListing/widgets/bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class CustomerRegistration extends StatefulWidget {
  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  PickedFile _profilePic;
  String _name;
  String _address;
  String _gender;
  Uint8List defaultProfileImageData;
  FirebaseStorageService storage = FirebaseStorageService();

  @override
  void initState() {
    super.initState();
    storage
        .getSystemImageByName(imageName: 'defaultProfilePic')
        .then((value) => setState(() {
              defaultProfileImageData = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LocalUser>(context);
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: heightPiece / 2),
          child: Form(key: _formKey, 
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                circularProfilePicWithEditOption(widthPiece, context),
                // customStackForShowingCircularProfilePic(user, context),
                SizedBox(height: 20),
                customTextFieldForName(widthPiece),
                SizedBox(height: 20),
                customTextFieldForAddress(widthPiece),
                SizedBox(height: 20),
                customTextFieldForAadhar(widthPiece),
                SizedBox(height: 20),
                customButtonToUpdateCustomerDocInDatabase(
                    widthPiece, user, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row circularProfilePicWithEditOption(
      double widthPiece, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: widthPiece / 2),
        circularProfilePic(widthPiece),
        camerButtonToEditPic(widthPiece, context),
      ],
    );
  }

  Padding camerButtonToEditPic(double widthPiece, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widthPiece * 3),
      child: IconButton(
        icon: Icon(
          Icons.camera_alt,
          size: 30.0,
        ),
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: ((builder) => BottomSheetWidget((image) {
                    setState(() {
                      _profilePic = image;
                      print('${image}');
                    });
                  })));
        },
      ),
    );
  }

  Align circularProfilePic(double widthPiece) {
    return Align(
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: (widthPiece * 2) + 5,
        backgroundColor: Color(0xff476cfb),
        child: ClipOval(
          child: new SizedBox(
            width: widthPiece * 4,
            height: widthPiece * 4,
            child: (_profilePic != null)
                ? Image.file(
                    File(_profilePic.path),
                    fit: BoxFit.fill,
                  )
                :(defaultProfileImageData==null)?CircularProgressIndicator():Image.memory(defaultProfileImageData,fit: BoxFit.fill,),
                //  Image.network(
                //     'https://firebasestorage.googleapis.com/v0/b/worklisting-61803.appspot.com/o/_DefaultImage%2Fblank_profile_pic.png?alt=media&token=da531832-6edc-4a1a-b9d8-4472d686b425',
                //     fit: BoxFit.fill,
                //   ),
          ),
        ),
      ),
    );
  }

  Padding customButtonToUpdateCustomerDocInDatabase(
      double widthPiece, LocalUser user, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthPiece),
      child: RaisedButton(
        padding: const EdgeInsets.only(bottom: 6.0, top: 8.0),
        color: Colors.white,
        onPressed: () async {
          _formKey.currentState.save();
          String fileName = basename(_profilePic.path);
          firebase_storage.StorageReference firebaseStorageRef =
              firebase_storage.FirebaseStorage.instance
                  .ref()
                  .child('${user.uid}/$fileName');
          var profilePicUrl;
          try {
            profilePicUrl = await firebaseStorageRef
                .putFile(File(_profilePic.path))
                .onComplete
                .then((value) async => await value.ref
                    .getDownloadURL()
                    .then((urlInstance) => urlInstance.toString()));
          } catch (e) {
            print(e);
          }
          // } var _profilePicUrl = await FirebaseStorage.instance
          //     .ref()
          //     .child('${user.uid}/$fileName')
          //     .getDownloadURL();
          await FirestoreService(uid: user.uid, phoneNo: user.phoneNo)
              .updateCustomerDoc(
                  uid: user.uid,
                  name: _name,
                  profilePicUrl: profilePicUrl,
                  phoneNo: user.phoneNo,
                  address: _address,
                  gender: _gender);
          Navigator.of(context).pop();
        },
        child: Text(
          'Register',
          style: TextStyle(color: Color(0xffF57921)),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.white)),
      ),
    );
  }

  Padding customTextFieldForAadhar(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: customTextFormField(labelText:
          'Gender',inputType:
          TextInputType.number,onsaved:
          ((value) {
            _gender = value;
          }),prefixIcon:
          Icon(Icons.person_pin_circle_outlined),validate:null,
        ));
  }

  Padding customTextFieldForAddress(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: customTextFormField(labelText:
            'Enter your address', inputType:TextInputType.streetAddress,onsaved: ((value) {
          _address = value;
        }), prefixIcon:Icon(Icons.location_city),validate: null,));
  }

  Padding customTextFieldForName(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: customTextFormField(labelText:'Enter Full Name', inputType:TextInputType.name,onsaved: ((value) {
          _name = value;
        }), prefixIcon:Icon(Icons.phone),validate:null, ));
  }
}
