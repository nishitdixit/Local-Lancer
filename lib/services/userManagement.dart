import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/screens/customerHomeScreen.dart';
import 'package:WorkListing/screens/logInScreen.dart';
import 'package:WorkListing/screens/serviceMenHomeScreen.dart';
import 'package:WorkListing/screens/askRegistrationScreen.dart';
import 'package:WorkListing/services/firestoreService.dart';
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
      return StreamProvider.value(
        value: FirestoreService(uid: currentAuthenticatedUser.uid)
            .currentUserDocFromDBMappedIntoLocalUserData,
        catchError: (_, __) => null,
        child: RoleBasedRoute(),
      );
    }
  }
}

class RoleBasedRoute extends StatefulWidget {
  @override
  _RoleBasedRouteState createState() => _RoleBasedRouteState();
}

class _RoleBasedRouteState extends State<RoleBasedRoute> {
  @override
  Widget build(BuildContext context) {
    final LocalUserData localUserData = Provider.of<LocalUserData>(context);
    if (localUserData == null) {
      return AskRegistrationScreen();
    } else {
      print(localUserData.name);
      print(localUserData.role);
      if (localUserData.role == 'customer') {
        print('customer if block');
        return CustomerHomeScreen();
      } else {
        print('servicemen else block');
        return ServiceMenHomeScreen();
      }
    }
  }
}
