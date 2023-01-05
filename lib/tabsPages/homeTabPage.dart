// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:apm_ambulance_app/configMaps.dart';
import 'package:apm_ambulance_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
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

  String driverStatusText = "Go Online Now";

  Color driverStatusColor = Colors.black;

  bool isDriverAvailable = false;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        // ignore: unnecessary_new
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
                        driverStatusColor = Colors.green;
                        driverStatusText = "Online Now";
                        isDriverAvailable = true;
                      });
                    } else {
                      //Geofire.removeLocation();
                    }
                  },
                 // color: driverStatusColor,
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

    Geofire.setLocation("ZVI5ry0JGQc0vPDp2mPbc7WPcGT2",
        currentPosition.latitude, currentPosition.longitude);
    rideRequestRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    // ignore: unused_local_variable
    StreamSubscription<Position> homeTabPageStreamSubscription;
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position postion) {
      currentPosition = postion;
      Geofire.setLocation("ZVI5ry0JGQc0vPDp2mPbc7WPcGT2",
          currentPosition.latitude, currentPosition.longitude);
      LatLng latLng = LatLng(postion.latitude, postion.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
