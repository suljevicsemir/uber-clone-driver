import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

class DriverLocationService {


  Future<void> updatePosition(LocationData? locationData) async {

    if( locationData == null)
      return;

    GeoPoint geoPoint = GeoPoint(locationData.latitude!, locationData.longitude!);

    try {
      FirebaseFirestore.instance
          .collection('driver_locations')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'location': geoPoint,
            'heading' : locationData.heading
          });
    }
    on TimeoutException catch (err) {
      print('Updating position took too long');
      print(err.message);
    }
    on Exception catch (err) {
      print('Fatal error when updating driver position!');
      print(err.toString());
    }
  }


  Future<void> updateStatus(bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('driver_locations')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'status' : status
          });
    }
    on TimeoutException catch( err) {
      print('Updating status took too long!');
      print(err.message);
    }
    catch(err) {
      print('Fatal error when updating driver status occurred');
      print(err.toString());
    }
  }



}