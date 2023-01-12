// use this file only after implenting lib files

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Users {
  String? id;
  String? email;
  String? name;
  String? phone;

  Users({
    this.id,
    this.email,
    this.name,
    this.phone,
  });

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key!;
    var data = dataSnapshot.value as Map?;
    if(data != null)
    {
    email = data["email"].toString();
    name = data["name"].toString();
    phone = data["phone"].toString();
    }
    
  }
}
