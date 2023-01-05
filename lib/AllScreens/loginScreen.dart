import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:apm_ambulance_app/AllScreens/mainscreen.dart';
import 'package:apm_ambulance_app/AllScreens/registrationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apm_ambulance_app/main.dart';
import 'registrationScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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
                height: 5.0,
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
                "Login as Driver",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bolt"),
                textAlign: TextAlign.center,
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
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                  ),
                  onPressed: () {
                    if (!emailTextEditingController.text.contains("@")) {
                      displayToastMessage(
                          "Email must contain @ symbol", context);
                    } else if (passwordTextEditingController.text.length < 7) {
                      displayToastMessage("password is mandatory", context);
                    } else {
                      loginAndAuthenticate(context);
                    }
                  },
                  child: const SizedBox(
                    height: 50.0,
                    child: Center(
                        child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                    )),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.idScreen, (route) => false);
                  },
                  child: const Text("Do not have an account? Sign up"))
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticate(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errormsg) {
      displayToastMessage("Error$errormsg", context);
    }))
        .user;

    //String userid = firebaseUser.getUid();

    if (firebaseUser != null) {
      //var currentfirebaseUser = firebaseUser.uid;

      displayToastMessage("Logged in Successfully", context);

      Navigator.pushNamed(context, MainScreen.idScreen);
    } else {
      displayToastMessage("Error", context);
    }
  }

  void displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
