

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_driver/constants/rider/rider_fields.dart' as fields;
class Rider {
  final String
    firstName,
    lastName,
    phoneNumber,
    firebaseId;


    Rider.fromSnapshot(DocumentSnapshot snapshot) :
      firstName = snapshot.get(fields.firstName),
      lastName = snapshot.get(fields.lastName),
      phoneNumber = snapshot.get(fields.phoneNumber),
      firebaseId = snapshot.id;





}