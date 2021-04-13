

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeProvider extends ChangeNotifier {

  bool _status = false;


  void updateStatus() {
    _status = !_status;
    notifyListeners();
  }


  Future<void> updateLocation(LatLng data) async {

    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if( connectivityResult == ConnectivityResult.none) {
      print('Nemas konekcije role');
      return;
    }
    print('ide upis ');
    GeoPoint geoPoint = GeoPoint(data.latitude, data.longitude);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(FirebaseFirestore.instance.collection('drivers').doc(FirebaseAuth.instance.currentUser!.uid), {
            'location' : geoPoint
        });
      });
    }
    on TimeoutException catch(err) {
      print('Timeout occured');
      print(err.toString());
    }
    catch (err) {
      print('an error occured');
      print(err.toString());
    }
  }


  bool get status => _status;

  set status(bool value) {
    _status = value;
    notifyListeners();
  }
}