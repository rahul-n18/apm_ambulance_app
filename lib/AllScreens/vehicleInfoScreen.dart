import 'dart:io';

import 'package:apm_ambulance_app/AllScreens/userDetail.dart';
import 'package:apm_ambulance_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:apm_ambulance_app/AllScreens/loginScreen.dart';
import 'package:apm_ambulance_app/AllScreens/mainscreen.dart';
import 'package:apm_ambulance_app/main.dart';
import 'registrationScreen.dart';

class VehicleInfoScreen extends StatefulWidget {
  static const String idScreen = "Driver Detail";

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  File? image;

  TextEditingController vehicleRegTextEditingController =
      TextEditingController();

  TextEditingController ambulanceRegTextEditingController =
      TextEditingController();

  TextEditingController orgNameTextEditingController = TextEditingController();

  TextEditingController birthdayTextEditingController = TextEditingController();

  TextEditingController phoneTextEditingController = TextEditingController();

  TextEditingController alterPhoneTextEditingController =
      TextEditingController();

  TextEditingController permaAddressTextEditingController =
      TextEditingController();

  // method for image picker(gallery)
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //method for image picker(Camera)
  Future pickImage1() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    birthdayTextEditingController.text =
        ""; //set the initial value of text field
    super.initState();
  }

  var ownership = [
    'Individual Ownership',
    '108,112,1088,etc',
    'Private Hospital',
    'NGO',
    'Private Organisation',
    'Government Hospital',
  ];
  var supportType = [
    'Basic Life Support',
    'Advance Life Support',
    'Nursing Care Vehicle',
    'Mobile Incubator',
    'Mortuary Ambulance',
  ];
  String ownershipDropDown = "Individual Ownership";
  String supportTypeDropDown = "Basic Life Support";

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 1.0,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Image(
                  image: AssetImage("images/apm_logo.png"),
                  height: 100,
                  width: 250,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Driver Detail's",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bolt"),
                textAlign: TextAlign.center,
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        //Ambulance Registration
                        TextFormField(
                          controller: ambulanceRegTextEditingController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter vehicle Registration Number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Vehicle Reg Number",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14.0),
                        ),

                        //vehicle Registration
                        TextFormField(
                          controller: vehicleRegTextEditingController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter ambulance Registration Number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "AMBULANCE Reg Number",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14.0),
                        ),

                        //Organisation Name
                        TextFormField(
                          controller: orgNameTextEditingController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Organisation Name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Organisation Name",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14.0),
                        ),

                        //birth date
                        TextField(
                          controller: birthdayTextEditingController,
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                            labelText: "Date of Birth",
                            suffixIcon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14.0),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                birthdayTextEditingController.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter phono no.";
                            }
                            return null;
                          },
                          controller: phoneTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "phone no.",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter alternate phone number";
                            }
                            return null;
                          },
                          controller: alterPhoneTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "Alternate Phone no.",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter permanent address";
                            }
                            return null;
                          },
                          controller: permaAddressTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Permanent address",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton(
                              value: ownershipDropDown,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: ownership.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  ownershipDropDown = newValue!;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            DropdownButton(
                              value: supportTypeDropDown,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: supportType.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  supportTypeDropDown = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                  color: Colors.blueAccent,
                                  child: const Text("Upload License",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    //method for image picker gallery
                                    //pickImage();

                                    //method for image picker camera
                                    pickImage1();
                                  }),
                              const SizedBox(
                                height: 10.0,
                                width: 40.0,
                              ),
                              MaterialButton(
                                  color: Colors.blueAccent,
                                  minWidth: 10.0,
                                  child: const Text("Upload Vehicle RC",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    //method for image picker camera
                                    pickImage1();
                                  }),
                              const SizedBox(
                                height: 60.0,
                              ),
                            ]),

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.blueAccent, //change color of button
                              foregroundColor: Colors.white, //change text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                firebaseUser =
                                    FirebaseAuth.instance.currentUser;
                                driverRef.child(firebaseUser!.uid).update({
                                  "vehicle reg": vehicleRegTextEditingController
                                      .text
                                      .trim(),
                                  "ambulance reg":
                                      ambulanceRegTextEditingController.text
                                          .trim(),
                                  "organisation":
                                      orgNameTextEditingController.text.trim(),
                                  "dob":
                                      birthdayTextEditingController.text.trim(),
                                  "phone no":
                                      phoneTextEditingController.text.trim(),
                                  "alternate no":
                                      alterPhoneTextEditingController.text
                                          .trim(),
                                  "permanent address":
                                      permaAddressTextEditingController.text
                                          .trim(),
                                });
                                Navigator.pushNamedAndRemoveUntil(context,
                                    UserDetail.idScreen, (route) => false);
                              }
                            },
                            child: const SizedBox(
                              height: 50.0,
                              child: Center(
                                  child: Text(
                                "Next ",
                                style: TextStyle(
                                    fontSize: 18.0, fontFamily: "Brand Bold"),
                              )),
                            )),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }



//TOAST FUNCTION
  void displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
