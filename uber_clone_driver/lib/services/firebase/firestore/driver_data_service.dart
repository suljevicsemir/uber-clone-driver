

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_driver/constants/driver/driver_fields.dart' as fields;
import 'package:uber_clone_driver/models/driver/driver.dart';
class FirestoreDriverService {

  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<Driver?> getDriverData(String id) async {
    try {
      DocumentSnapshot? snapshot = await _instance.collection('drivers').doc(id).get().timeout(
          const Duration(seconds: 2)
      );
      return Driver.fromSnapshot(snapshot);
    }
    on TimeoutException catch(err) {
      print('Fetching driver data took too long');
      print(err.toString());
      return null;
    }
    on Exception catch(err) {
      print('An unexpected error occurred');
      print(err.toString());
      return null;
    }
  }




}