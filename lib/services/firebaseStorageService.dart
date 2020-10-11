import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';


class FirebaseStorageService{
  StorageReference systemImageRefrence = FirebaseStorage.instance.ref().child('_DefaultImage');


//get system image by name
Future<Uint8List> getSystemImageByName({String imageName}) async{
  int max_size=7*1024*1024;
  return systemImageRefrence.child('$imageName.png').getData(max_size).then((value) =>value);
}

}