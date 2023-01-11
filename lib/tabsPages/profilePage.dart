import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AllScreens/loginScreen.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      
            
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: const ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Log out",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
      
    );
  }
}
