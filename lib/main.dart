import 'package:apm_ambulance_app/AllScreens/vehicleInfoScreen.dart';
import 'package:apm_ambulance_app/configMaps.dart';
import 'package:apm_ambulance_app/tabsPages/ICEpage.dart';
import 'package:apm_ambulance_app/tabsPages/homeTabPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:apm_ambulance_app/AllScreens/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apm_ambulance_app/AllScreens/mainscreen.dart';
import 'package:apm_ambulance_app/AllScreens/registrationScreen.dart';

import 'package:apm_ambulance_app/AllScreens/userDetail.dart';

import 'AllScreens/ICEpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentfirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(const MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .ref()
    .child("drivers")
    .child("currentfirebaseUser.uid")
    .child("newRide");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apm Driver App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen: MainScreen.idScreen,
     // initialRoute: MainScreen.idScreen,

      routes: {
        IceScreen.idScreen: (context) => IceScreen(),
        RegistrationScreen.idScreen: (context) => RegistrationScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen(),
        UserDetail.idScreen: (context) => UserDetail(),
        VehicleInfoScreen.idScreen: (context) => VehicleInfoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
