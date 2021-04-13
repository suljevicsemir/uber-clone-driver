

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class ConnectivityProvider extends ChangeNotifier {

  ConnectivityResult _currentConnectivity = ConnectivityResult.wifi;


  ConnectivityProvider() {
    _setupConnectivity();
  }


  Future<void> _setupConnectivity() async {
    _currentConnectivity = await (Connectivity().checkConnectivity());
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('stream was called');
      if( result == ConnectivityResult.mobile || result == ConnectivityResult.wifi && _currentConnectivity == ConnectivityResult.none ) {
        _currentConnectivity = result;
        notifyListeners();
      }
      if( result == ConnectivityResult.none && _currentConnectivity != ConnectivityResult.none) {
        _currentConnectivity = result;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  bool isConnected() {
    return (_currentConnectivity == ConnectivityResult.mobile || _currentConnectivity == ConnectivityResult.wifi) ? true : false;
  }
}