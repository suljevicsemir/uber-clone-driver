
import 'package:uber_clone_driver/constants/driver/driver_fields.dart' as fields;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uber_clone_driver/models/driver/driver_personal_info.dart';

class Driver extends ChangeNotifier{

  DriverPersonalInfo? personalInfo;

  Map<int, int>? rating;
  int? numberOfTrips;
  bool? status;
  DateTime? dateOfStart;
  List<String>? languages;

  Driver.fromSnapshot(DocumentSnapshot snapshot) {
    rating = snapshot.get(fields.rating);
    numberOfTrips = snapshot.get(fields.numberOfTrips);
    status = snapshot.get(fields.status);
    dateOfStart = snapshot.get(snapshot.get(fields.dateOfStart));
    personalInfo = DriverPersonalInfo.fromSnapshot(snapshot);
    languages = snapshot.get(fields.languages);
  }





}