// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:apm_ambulance_app/configMaps.dart';
import 'package:apm_ambulance_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apm_ambulance_app/AllScreens/registrationScreen.dart';

import 'package:geolocator/geolocator.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(12.9982, 77.553),
    zoom: 14.4746,
  );

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;

  late Position currentPosition;

  var geoLocator = Geolocator();

  String driverStatusText = "Go Online ";

  bool isDriverAvailable = false;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 15);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //String address =
    //  await AssistantMethods.searchCoordinateAddress(position, context);
    //print("This is your Address :: " + address);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),

        Container(
          height: 140.0,
          width: double.infinity,
          color: Color.fromARGB(90, 0, 0, 0),
        ),

        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (isDriverAvailable != true) {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        ElevatedButton.styleFrom(
                         backgroundColor: Color.fromARGB(255, 0, 223, 41));
                        driverStatusText = "Online Now ";
                        isDriverAvailable = true;
                      });
                      Fluttertoast.showToast(
                          msg: "You are Online Now",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 48, 48, 48),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      setState(() {
                        ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 39, 235, 0));
                        driverStatusText = "Go Online";
                        isDriverAvailable = false;
                      });
                      makeDriverOfflineNow();
                      //Geofire.removeLocation();
                    }
                  },
                   style: ElevatedButton.styleFrom(
                   backgroundColor: Color.fromARGB(255, 0, 204, 41)),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          driverStatusText,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 26.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        //
      ],
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    Geofire.initialize("availabelDrivers");

    Geofire.setLocation(currentfirebaseUser!.uid, currentPosition.latitude,
        currentPosition.longitude);
    rideRequestRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    StreamSubscription<Position> homeTabPageStreamSubscription;
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position postion) {
      currentPosition = postion;
      if (isDriverAvailable == true) {
        Geofire.setLocation(currentfirebaseUser!.uid, currentPosition.latitude,
            currentPosition.longitude);
      }
      LatLng latLng = LatLng(postion.latitude, postion.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}

void makeDriverOfflineNow() {
  Geofire.removeLocation(currentfirebaseUser!.uid);
  rideRequestRef.onDisconnect();
  rideRequestRef.remove();
  // rideRequestRef = null;

  Fluttertoast.showToast(
      msg: "You are Offline Now",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 63, 63, 63),
      textColor: Colors.white,
      fontSize: 16.0);
}
