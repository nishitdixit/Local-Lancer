import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/screens/logInScreen.dart';
import 'package:WorkListing/screens/serviceMenHomeScreen.dart';
import 'package:WorkListing/services/PhoneAuth.dart';
import 'package:WorkListing/services/userManagement.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LocalUser>.value(
      value: PhoneAuth().user,
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
        
          primarySwatch: Colors.blue,
         
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:UserManagement(),
        routes: <String, WidgetBuilder>{
          '/serviceMenHomeScreen': (BuildContext context) => ServiceMenHomeScreen(),
          '/logInScreen': (BuildContext context) => LogInScreen(),
        },
      ),
    );
  }
}
