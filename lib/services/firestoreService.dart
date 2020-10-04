import 'package:WorkListing/models/localUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final String uid;

  FirestoreService({this.uid});
  // collection reference
  final CollectionReference userDataCollectionRefrence =
      FirebaseFirestore.instance.collection('users');

  //update customer doc
  Future updateCustomerDoc({
    String uid,
    String profilePicUrl,
    String name,
    String phoneNo,
    String address,
    String gender,
  }) async {
    return await userDataCollectionRefrence.doc(uid).set({
      'uid': uid,
      'name': name,
      'phoneNo': phoneNo,
      'address': address,
      'profilePicUrl': profilePicUrl,
      'gender': gender,
      'role': 'customer'
    });
  }

  //update service men doc
  Future updateServiceMenDoc({
    String uid,
    String name,
    String phoneNo,
    String aadharNo,
    String age,
    String address,
    String profilePicUrl,
    String experience,
    String gender,
    String skill,
  }) async {
    return await userDataCollectionRefrence.doc(uid).set({
      'uid': uid,
      'name': name,
      'phoneNo': phoneNo,
      'aadharNo': aadharNo,
      'age': age,
      'address': address,
      'profilePicUrl': profilePicUrl,
      'experience': experience,
      'gender': gender,
      'skill': skill,
      'role': 'service men'
    });
  }

  // LocalUserData from snapshot
  LocalUserData _localUserDataFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot != null) {
      if (snapshot.data()['role'] == 'service men') {
        return LocalUserData(
            uid: uid,
            name: snapshot.data()['name'],
            address: snapshot.data()['address'],
            age: snapshot.data()['age'],
            aadharNo: snapshot.data()['aadharNo'],
            gender: snapshot.data()['gender'],
            phoneNo: snapshot.data()['phoneNo'],
            experience: snapshot.data()['experience'],
            skill: snapshot.data()['skill'],
            role: snapshot.data()['role']);
      } else {
        return LocalUserData(
            uid: uid,
            name: snapshot.data()['name'],
            address: snapshot.data()['address'],
            gender: snapshot.data()['gender'],
            phoneNo: snapshot.data()['phoneNo'],
            role: snapshot.data()['role']);
      }
    } else
      return null;
  }

  // get currentUserDataFromDB stream
  Stream<LocalUserData> get currentUserDocFromDBMappedIntoLocalUserData {
    return userDataCollectionRefrence
        .doc(uid)
        .snapshots()
        .map((snapshot) => _localUserDataFromSnapshot(snapshot));
  }
}
