

import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier {

  bool _status = false;


  void updateStatus() {
    _status = !_status;
    notifyListeners();
  }


  bool get status => _status;

  set status(bool value) {
    _status = value;
    notifyListeners();
  }
}