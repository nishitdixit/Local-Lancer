
import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/screens/logInScreen.dart';
import 'package:WorkListing/screens/serviceMenHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class UserManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LocalUser>(context);
    print(user);

    if(user == null){
      return LogInScreen();
    }else{
      return ServiceMenHomeScreen();
    }
  }
}












// class UserManagement {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   User user = FirebaseAuth.instance.currentUser;

//   // CollectionReference users = FirebaseFirestore.instance.collection('users');
//   Widget handleAuth() {
//     Widget upcomingScreen;
//    _auth.authStateChanges()
//   .listen((User user) {
//     if (user == null) {
//       print('User is currently signed out!');
//       upcomingScreen= LogInScreen();
//       return upcomingScreen;
//     } else {
//       print('User is signed in!');
//       print(user);
//       upcomingScreen= ServiceMenHomeScreen();
//     }
//   });return upcomingScreen;
    // return StreamBuilder(
    //   stream: _auth.authStateChanges(),
    //   builder: (BuildContext context, snapshot) {print(snapshot.data);
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     if (snapshot.hasError) {
    //       return Text('Error: ${snapshot.error}');
    //     }
    //     if (snapshot.hasData) {
    //       return ServiceMenHomeScreen();
    //     } else {
    //       return LogInScreen();
    //     }
    //   },
    // );
  // }

  // signOut(context) {
  //   FirebaseAuth.instance.signOut();
  //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()),
  // (Route<dynamic> route) => false,);
  // }

  // Widget checkRole(user) {
  //   Widget widget = Container(
  //       color: Colors.white,
  //       child: Center(
  //         child: CircularProgressIndicator(),
  //       ));
  //   users.doc(user.uid).get().then((document) => {
  //         if (document.get('type') == 'Executive')
  //           {ExecutiveHomeScreen()}
  //         else
  //           {CustomerHomeScreen()}
  //       });
  //   return LoginPage();
  //   // .snapshots(),
  // }
// }
