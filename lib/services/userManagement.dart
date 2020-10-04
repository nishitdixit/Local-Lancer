import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/screens/customerHomeScreen.dart';
import 'package:WorkListing/screens/logInScreen.dart';
import 'package:WorkListing/screens/serviceMenHomeScreen.dart';
import 'package:WorkListing/screens/askRegistrationScreen.dart';
import 'package:WorkListing/services/firestoreService.dart';
import 'package:WorkListing/services/roleBasedRoute.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  @override
  Widget build(BuildContext context) {
    final currentAuthenticatedUser = Provider.of<LocalUser>(context);
    print(currentAuthenticatedUser);

    if (currentAuthenticatedUser == null) {
      return LogInScreen();
    } else {
      return CheckForRegistration(
          currentAuthenticatedUser: currentAuthenticatedUser);
    }
  }
}

class CheckForRegistration extends StatefulWidget {
  const CheckForRegistration({
    Key key,
    @required this.currentAuthenticatedUser,
  }) : super(key: key);

  final LocalUser currentAuthenticatedUser;

  @override
  _CheckForRegistrationState createState() => _CheckForRegistrationState();
}

class _CheckForRegistrationState extends State<CheckForRegistration> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreService(uid: widget.currentAuthenticatedUser.uid)
            .currentUserDocFromDBMappedIntoLocalUserData,
        builder: (BuildContext context, snapshotOfLocalUserData) {
          print(snapshotOfLocalUserData.data);

          if (snapshotOfLocalUserData.connectionState ==
              ConnectionState.waiting)
            return Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.white)));

          if (snapshotOfLocalUserData.data != null) {
            return StreamBuilder<LocalUserData>(
                stream:
                    FirestoreService(uid: widget.currentAuthenticatedUser.uid)
                        .currentUserDocFromDBMappedIntoLocalUserData,
                builder: (context, snapshot) {
                  if (snapshotOfLocalUserData.connectionState ==
                      ConnectionState.waiting)
                    return CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    );
                  if (snapshot.data == null) {
                    return Scaffold(
                        body: Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white)));
                  } else {
                    return StreamProvider.value(
                      value: FirestoreService(
                              uid: widget.currentAuthenticatedUser.uid)
                          .currentUserDocFromDBMappedIntoLocalUserData,
                      child: RoleBasedRoute(),
                    );
                  }
                  // LocalUserData localUserData = snapshot.data;
                  // if (localUserData.role == 'customer') {
                  //   print('customer if block');
                  //   return CustomerHomeScreen();
                  // } else {
                  //   print('servicemen else block');
                  //   return ServiceMenHomeScreen();
                  // }
                });
            // print(snapshotOfLocalUserData.data);
            // print(localUserData.role);
            // print(localUserData.role.runtimeType);
            // if (localUserData.role == 'customer') {
            //   print('customer if block');
            //   return CustomerHomeScreen();
            // } else {
            //   print('servicemen else block');
            //   return ServiceMenHomeScreen();
            // }
          } else {
            return AskRegistrationScreen();
          }
        });
  }
}

// class UserRoleBasedManagement extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final localUser = Provider.of<LocalUserData>(context);
//     print(localUser);
//     // print('${user.name} and ${user.role}');
//   StreamBuilder(
//     stream: StreamProvider<LocalUserData>.value(value: FirestoreService().userData), ,
//     builder: (BuildContext context, AsyncSnapshot snapshot){
//       return Container(
//         child: child,
//       );
//     },
//   ),
//     if (localUser == null) {
//       return AskRegistrationScreen();
//     } else {
//       switch (localUser.role) {
//         case 'service men':
//           return ServiceMenHomeScreen();
//           break;
//         case 'customer':
//           return CustomerHomeScreen();
//           break;
//         default:
//         return CustomerHomeScreen();
//       }
//     }
//   }

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
