import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uber_clone_driver/models/driver/driver.dart';

import 'package:uber_clone_driver/services/cached_data/cached_data_service.dart';
import 'package:uber_clone_driver/services/firebase/firestore/driver_data_service.dart';

class DriverDataProvider extends ChangeNotifier{

  final CachedDataService _cachedService = CachedDataService();
  final FirestoreDriverService _firestoreService = FirestoreDriverService();
  Driver? _driver;
  bool didLoad = false;
  DriverDataProvider() {
    print('Driver data provider constructor');
    if(FirebaseAuth.instance.currentUser != null) {
      Timer(const Duration(seconds: 4), () {
        _loadUser();

      });

    }
  }


  Future<void> _loadUser() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      _driver = await _firestoreService.getDriverData(FirebaseAuth.instance.currentUser!.uid);
      didLoad = true;
      notifyListeners();
    }
    on TimeoutException catch(err) {
      print('Timeout occurred while fetching the user data');
      print(err.toString());
    }
    on Exception catch(err) {
      print('Unexpected error occurred while fetching the user data');
      print(err.toString());
    }
  }

  Driver? get driver => _driver;

}