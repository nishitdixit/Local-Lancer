import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/screens/customerHomeScreen.dart';
import 'package:WorkListing/screens/serviceMenHomeScreen.dart';
import 'package:WorkListing/services/firestoreService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleBasedRoute extends StatefulWidget {
  @override
  _RoleBasedRouteState createState() => _RoleBasedRouteState();
}

class _RoleBasedRouteState extends State<RoleBasedRoute> {
  @override
  Widget build(BuildContext context) {
    final LocalUserData localUserData = Provider.of<LocalUserData>(context);
    if(localUserData==null) return Scaffold(body:Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),));
    print(localUserData.name);
    print(localUserData.role);
    print(localUserData.role.runtimeType);
    if (localUserData.role == 'customer') {
      print('customer if block');
      return CustomerHomeScreen();
    } else {
      print('servicemen else block');
      return ServiceMenHomeScreen();
    }
  }
}
