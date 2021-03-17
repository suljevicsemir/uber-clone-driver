
import 'package:flutter/cupertino.dart';
import 'package:uber_clone_driver/constants/driver/driver_fields.dart' as fields;
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverPersonalInfo extends ChangeNotifier {
  String
    firstName,
    lastName,
    email,
    phoneNumber,
    from;



  DriverPersonalInfo.fromSnapshot(DocumentSnapshot snapshot):
      firstName = snapshot.get(fields.firstName),
      lastName = snapshot.get(fields.lastName),
      email = snapshot.get(fields.email),
      phoneNumber = snapshot.get(fields.phoneNumber),
      from = snapshot.get(fields.from);


  DriverPersonalInfo.fromMap(Map<String, String> map):
      firstName = map[fields.firstName]!,
      lastName = map[fields.lastName]!,
      email = map[fields.email]!,
      phoneNumber = map[fields.phoneNumber]!,
      from = map[fields.from]!;


}