import 'package:WorkListing/models/localUser.dart';
import 'package:WorkListing/models/userLocation.dart';
import 'package:WorkListing/screens/logInScreen.dart';
import 'package:WorkListing/screens/serviceMenHomeScreen.dart';
import 'package:WorkListing/services/PhoneAuth.dart';
import 'package:WorkListing/services/firestoreService.dart';
import 'package:WorkListing/services/location.dart';
import 'package:WorkListing/services/userManagement.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarIconBrightness: Brightness.dark,systemNavigationBarColor: Colors.white,statusBarColor: Colors.white,statusBarIconBrightness: Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return StreamProvider<LocalUser>.value(
    //   value: PhoneAuth().user,
    return MultiProvider(
      providers: [
        StreamProvider<LocalUser>.value(
            value: PhoneAuth().currentUserFromAuthMappedIntoLocalUser),
        // StreamProvider<UserLocation>.value(
            // value: LocationService().locationStream),
        // StreamProvider<LocalUserData>.value(value: FirestoreService().currentUserDocFromDBMappedIntoLocalUserData),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          // accentTextTheme: TextTheme().,
          
          // fontFamily: 'Oxygen',
          // accentColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: UserManagement(),
        routes: <String, WidgetBuilder>{
          '/serviceMenHomeScreen': (BuildContext context) =>
              ServiceMenHomeScreen(),
          '/logInScreen': (BuildContext context) => LogInScreen(),
        },
      ),
    );
  }
}
