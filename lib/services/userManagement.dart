import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/screens/customerHomeScreen.dart';
import 'package:WorkListing/screens/logInScreen.dart';
import 'package:WorkListing/screens/serviceMenHomeScreen.dart';
import 'package:WorkListing/screens/askRegistrationScreen.dart';
import 'package:WorkListing/services/firestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      return RoleBasedRoute(currentAuthenticatedUser);
      
    }
  }
}

class RoleBasedRoute extends StatefulWidget {
  final LocalUser currentAuthenticatedUser;
  RoleBasedRoute(this.currentAuthenticatedUser);
  @override
  _RoleBasedRouteState createState() => _RoleBasedRouteState();
}

class _RoleBasedRouteState extends State<RoleBasedRoute> {
  @override
  Widget build(BuildContext context) {
   return StreamBuilder(
      stream: FirestoreService(uid: widget.currentAuthenticatedUser.uid,phoneNo: widget.currentAuthenticatedUser.phoneNo)
            .currentUserDocFromDBMappedIntoLocalUserData,
    
      builder: (BuildContext context, AsyncSnapshot userSnapshot){
        if(userSnapshot.connectionState==ConnectionState.waiting){ return Scaffold(body: Center(child: CircularProgressIndicator(),),);}
      if(userSnapshot.connectionState==ConnectionState.active){
        LocalUserData localUserData=userSnapshot.data;
        if (localUserData == null) {
      return AskRegistrationScreen();
    } else {
      print(localUserData.name);
      print(localUserData.role);
      if (localUserData.role == 'customer') {
        print('customer if block');
        return CustomerHomeScreen(localUserData:localUserData);
      } else {
        print('servicemen else block');
        return ServiceMenHomeScreen(localUserData:localUserData);
      }
    }}return Scaffold(body: Center(child: CircularProgressIndicator(),),);
      },
    );
    // final LocalUserData localUserData = Provider.of<LocalUserData>(context);
   
  }


}
