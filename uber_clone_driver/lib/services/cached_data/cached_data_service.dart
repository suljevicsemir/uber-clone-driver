import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uber_clone_driver/models/driver/driver_personal_info.dart';
import 'package:uber_clone_driver/constants/driver/driver_fields.dart' as fields;

class CachedDataService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<DriverPersonalInfo?> readData() async {
    Map<String, String> map = await _secureStorage.readAll();
    if(map.isEmpty)
      return null;

    return DriverPersonalInfo.fromMap(map);


  }

  Future<bool> saveData(DriverPersonalInfo info) async {
    try {
      await _secureStorage.write(key: fields.firstName, value: info.firstName);
      await _secureStorage.write(key: fields.lastName, value: info.lastName);
      await _secureStorage.write(key: fields.email, value: info.email);
      await _secureStorage.write(key: fields.phoneNumber, value: info.email);
      await _secureStorage.write(key: fields.from, value: info.email);
      return true;
    }
    catch(err) {
      print('Error saving data to secure storage');
      print(err.toString());
      return false;
    }
  }


  Future<bool> updateField(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      return true;
    }
    catch(err) {
      print('Error updating field ' + key + ' with value ' + value);
      print(err.toString());
      return false;
    }
  }




}