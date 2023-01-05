import 'package:apm_ambulance_app/AllScreens/vehicleInfoScreen.dart';
import 'package:apm_ambulance_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:apm_ambulance_app/AllScreens/loginScreen.dart';
import 'package:apm_ambulance_app/AllScreens/mainscreen.dart';
import 'package:apm_ambulance_app/main.dart';

class RegistrationScreen extends StatelessWidget {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  static const String idScreen = "register";
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
                padding: EdgeInsets.all(40.0),
                child: Image(
                  image: AssetImage("images/apm_logo.png"),
                  height: 200,
                  width: 250,
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              const Text(
                "Register as Driver",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bolt"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: nameTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Name",
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
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
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
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: phoneTextEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone",
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
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: passwordTextEditingController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
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
              ),
              const SizedBox(
                height: 5.0,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,//change color of button
                              foregroundColor: Colors.white,//change text color
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                 
                  ),
                  onPressed: () {
                    if (nameTextEditingController.text.length < 4) {
                      displayToastMessage(
                          "Name must be more than 3 character", context);
                    } else if (!emailTextEditingController.text.contains("@")) {
                      displayToastMessage(
                          "Email must contain @ symbol", context);
                    } else if (phoneTextEditingController.text.isEmpty) {
                      displayToastMessage("Phone number is required", context);
                    } else if (passwordTextEditingController.text.length < 7) {
                      displayToastMessage(
                          "password must be more than 7 characters", context);
                    } else {
                      registerNewUser(context);
                    }
                  },
                  child: const SizedBox(
                    height: 50.0,
                    child: Center(
                        child: Text(
                      "Create Account",
                      style:
                          TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                    )),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: const Text("Already have an Account? Login Here"))
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errormsg) {
      displayToastMessage("Error$errormsg", context);
    }))
        .user;

    if (firebaseUser != null) {
      Map driverDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      driverRef.child(firebaseUser.uid).set(driverDataMap);

      currentfirebaseUser = firebaseUser;

      displayToastMessage("Account created successfully", context);

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, VehicleInfoScreen.idScreen);
    } else {
      displayToastMessage("Driver Account cannot be created", context);
    }
  }

  //TOAST FUNCTION
  void displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
