import 'package:uber_clone_driver/constants/driver/driver_fields.dart' as fields;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uber_clone_driver/models/driver/driver_personal_info.dart';

class Driver extends ChangeNotifier{

  //DriverPersonalInfo? personalInfo;

  Map<String, String> rating = {};
  int? numberOfTrips;
  bool? status;
  Timestamp? dateOfStart;
  late List<String> languages = [];

  late String
    firstName,
    lastName,
    email,
    phoneNumber,
    from;



  Driver.fromSnapshot(DocumentSnapshot snapshot) {
    snapshot.get(fields.rating).forEach((key, value) {
        rating[key] = value.toString();
    });
    numberOfTrips = snapshot.get(fields.numberOfTrips);
    //status = snapshot.get(fields.status);
    dateOfStart = snapshot.get(fields.dateOfStart);
    snapshot.get(fields.language).forEach((element) {
      languages.add(element.toString());
    });
    firstName = snapshot.get(fields.firstName);
    lastName = snapshot.get(fields.lastName);
    email = snapshot.get(fields.email);
    phoneNumber = snapshot.get(fields.phoneNumber);
    from = snapshot.get(fields.from);
  }





}