import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uber_clone_driver/models/driver/driver.dart';

import 'package:uber_clone_driver/services/cached_data/cached_data_service.dart';
import 'package:uber_clone_driver/services/firebase/firestore/driver_data_service.dart';

class DriverDataProvider extends ChangeNotifier{

  final CachedDataService _cachedService = CachedDataService();
  final FirestoreDriverService _firestoreService = FirestoreDriverService();
  Driver? _driver;

  DriverDataProvider() {
    print('Driver data provider constructor');
    if(FirebaseAuth.instance.currentUser != null) {
      Timer(const Duration(seconds: 4), () {
        _loadUser();

      });

    }
  }


  Future<void> _loadUser() async {
    _driver = await _firestoreService.getDriverData(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
  }

  Driver? get driver => _driver;

}