import 'dart:io';
import 'dart:typed_data';
import 'package:WorkListing/components/components.dart';
import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/services/firebaseStorageService.dart';
import 'package:WorkListing/services/firestoreService.dart';
import 'package:WorkListing/widgets/bottomSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class ServiceMenRegistration extends StatefulWidget {
  @override
  _ServiceMenRegistrationState createState() => _ServiceMenRegistrationState();
}

class _ServiceMenRegistrationState extends State<ServiceMenRegistration> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PickedFile _profilePic;
  Uint8List defaultProfileImageData;
  FirebaseStorageService storage = FirebaseStorageService();
  CollectionReference defaultCollectionReference =
      FirebaseFirestore.instance.collection('default');
  FocusNode _blankFocusNode = FocusNode();

  String _name;
  String _aadharNo;
  String _age;
  String _address;
  String _experience;
  String _gender;
  String _skill;
  bool imageError = false;
  bool skillError = false;

  List<ListItem> _dropdownItems = [
    ListItem(1, "Male"),
    ListItem(2, "Female"),
    ListItem(3, "other"),
  ];

  List<DropdownMenuItem<ListItem>> _genderDropdownMenuItems;
  List<DropdownMenuItem<ListItem>> _skillDropdownMenuItems=[];
  ListItem _selectedGender;
  ListItem _selectedSkill;
  List skillList;

  Future<List<String>> _buildSkillList() async {      print(skillList);

    await defaultCollectionReference.doc('skills').get().then((value) {
      skillList = value.data()['skill'];
      print(skillList);
       for (int i = 0; i < skillList.length; i++) {
      _skillDropdownMenuItems.add(DropdownMenuItem(
        child: Text(skillList[i]),
        value: ListItem(i,skillList[i] ),
      ));
      print(skillList);
    }
    });
   
   
  }

  List<DropdownMenuItem<ListItem>> buildGenderDropDownMenuItems(
      List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  String requiredValidator(value) {
    if (value.length == 0) {
      return 'field can not be empty';
    } else {
      _formKey.currentState.save();
      return null;
    }
  }

  String numberCountValidator(value, int requiredCount) {
    if (value.length < requiredCount || value.length > requiredCount) {
      return "Invalid";
    } else {
      print(value.length);
      _formKey.currentState.save();
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _genderDropdownMenuItems = buildGenderDropDownMenuItems(_dropdownItems);
    _buildSkillList();
    _selectedGender = _genderDropdownMenuItems[0].value;
    _gender = _selectedGender.name;
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
      // bottomNavigationBar: followButton(),
      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_blankFocusNode);
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: heightPiece / 2),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  circularProfilePicWithEditOption(widthPiece, context),
                  (imageError == true)
                      ? Text(
                          'Please Upload Image',
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                  SizedBox(height: 18.0),
                  customTextFIeldForName(widthPiece),
                  SizedBox(height: 20),
                  customTextFIeldForAge(widthPiece),
                  SizedBox(height: 20),
                 
                  customTextFieldForAddress(widthPiece),
                  SizedBox(height: 20),
                  customTextFieldForAadhar(widthPiece),
                  SizedBox(height: 20),
                  customTextFieldForExperience(widthPiece),
                  SizedBox(height: 20),
                   customTextFieldForSkills(widthPiece),
                  (skillError == true)
                      ? Text(
                          'Please choose Your Skill',
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                  SizedBox(height: 20),
                  fieldForGender(widthPiece),
                  SizedBox(height: 20),
                  buttonToUploadPicInStorageAndRegisterServiceMen(
                      widthPiece, user, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buttonToUploadPicInStorageAndRegisterServiceMen(
      double widthPiece, LocalUser user, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthPiece),
      child: RaisedButton(
        padding: const EdgeInsets.only(bottom: 6.0, top: 8.0),
        color: Colors.white,
        onPressed: () async {
          _formKey.currentState.validate();
          var profilePicUrl;
          if (_skill == null) {
            setState(() {
              skillError = true;
              return;
            });
          }
          if (_profilePic != null) {
            String fileName = basename(_profilePic.path);
            firebase_storage.StorageReference firebaseStorageRef =
                firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child('${user.uid}/$fileName');

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
          } else {
            setState(() {
              imageError = true;
            });
            return;
          }
          await FirestoreService(uid: user.uid, phoneNo: user.phoneNo)
              .updateServiceMenDoc(
                  uid: user.uid,
                  name: _name,
                  phoneNo: user.phoneNo,
                  address: _address,
                  gender: _gender,
                  experience: _experience,
                  profilePicUrl: profilePicUrl,
                  age: _age,
                  skill: _skill,
                  aadharNo: _aadharNo);
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

  Padding fieldForGender(double widthPiece) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthPiece),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Gender :'),
          DropdownButton<ListItem>(
              elevation: 25,
              dropdownColor: Colors.grey,
              value: _selectedGender,
              items: _genderDropdownMenuItems,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                  _gender = value.name;
                });
              }),
        ],
      ),
      // customTextFormField(
      //   labelText: 'Enter gender',
      //   inputType: TextInputType.text,
      //   onsaved: ((value) {
      //     _gender = value;
      //   }),
      //   prefixIcon: Icon(Icons.person_pin_circle_outlined),
      //   validate: null,
      // )
    );
  }

  Padding customTextFieldForExperience(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: customTextFormField(
            labelText: 'Enter experience in years',
            inputType: TextInputType.number,
            onsaved: ((value) {
              _experience = value;
            }),
            prefixIcon: Icon(Icons.timeline),
            validate: requiredValidator));
  }

  Padding customTextFieldForAadhar(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: customTextFormField(
            labelText: 'Enter Aadhar Card Number',
            inputType: TextInputType.phone,
            onsaved: ((value) {
              _aadharNo = value;
            }),
            prefixIcon: Icon(Icons.credit_card_outlined),
            validate: (value) => numberCountValidator(value, 12)));
  }

  Padding customTextFieldForAddress(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: customTextFormField(
          labelText: 'Enter your address',
          inputType: TextInputType.streetAddress,
          onsaved: ((value) {
            _address = value;
          }),
          prefixIcon: Icon(Icons.location_city),
          validate: requiredValidator,
        ));
  }

  Row circularProfilePicWithEditOption(
      double widthPiece, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: widthPiece / 2),
        Align(
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
                    : (defaultProfileImageData == null)
                        ? CircularProgressIndicator()
                        : Image.memory(
                            defaultProfileImageData,
                            fit: BoxFit.fill,
                          ),
                // Image.network(
                //     'https://firebasestorage.googleapis.com/v0/b/worklisting-61803.appspot.com/o/_DefaultImage%2Fblank_profile_pic.png?alt=media&token=da531832-6edc-4a1a-b9d8-4472d686b425',
                //     fit: BoxFit.fill,
                //   ),
              ),
            ),
          ),
        ),
        Padding(
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
        ),
      ],
    );
  }

  Padding customTextFieldForSkills(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Skill :'),
            DropdownButton(
                items: _skillDropdownMenuItems,
                elevation: 25,
                dropdownColor: Colors.grey,
                value: _selectedSkill,
                hint: Text('Choose Skill'),
                onChanged: (value) {
                  print(value);
                  setState(() {
                    _selectedSkill = value;
                    _skill = value.name;
                  });
                }),
          ],
        )

        //  customTextFormField(
        //   labelText: 'Enter your skill',
        //   inputType: TextInputType.text,
        //   onsaved: ((value) {
        //     _skill = value;
        //   }),
        //   prefixIcon: Icon(Icons.work),
        //   validate: requiredValidator,
        // )
        );
  }

  Padding customTextFIeldForAge(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: customTextFormField(
          labelText: 'Enter your age',
          inputType: TextInputType.number,
          onsaved: ((value) {
            _age = value;
          }),
          prefixIcon: Icon(Icons.hourglass_top_outlined),
          validate: requiredValidator,
        ));
  }

  Padding customTextFIeldForName(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: customTextFormField(
          labelText: 'Enter Full Name',
          inputType: TextInputType.name,
          onsaved: ((value) {
            _name = value;
          }),
          prefixIcon: Icon(Icons.person),
          validate: requiredValidator,
        ));
  }
}
