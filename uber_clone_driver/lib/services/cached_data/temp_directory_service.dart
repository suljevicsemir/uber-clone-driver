import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class TempDirectoryService {


  Future<File?> loadDriverPicture() async {
    final Directory temp = await getTemporaryDirectory();
    final File profilePicture = File('${temp.path}/${FirebaseAuth.instance.currentUser!.uid}');
    if(await profilePicture.exists()) {
      print('Profile picture exists locally');
      return profilePicture;
    }

    print('Profile picture doesn\'t exist locally');
    return null;

  }

  Future<File?> storeDriverPicture(Uint8List list) async {
    try {
      final Directory temp = await getTemporaryDirectory();
      File picture = File('${temp.path}/${FirebaseAuth.instance.currentUser!.uid}');
      if(await picture.exists()) {
        print('Profile picture already exists, it will be replaced!');
        picture = await picture.writeAsBytes(list);
        return picture;
      }

      return await picture.writeAsBytes(list);
    }
    catch(err) {
      print('Error storing the driver profile picture');
      print(err.toString());
      return null;
    }
  }

  Future<Map<String, File>?> loadRidersPictures() async {
    final Directory temp = await getTemporaryDirectory();
    Map<String, File> map = {};

    try {
      Directory x = Directory(temp.path + '/riders');

      if( await x.exists()) {
        List<FileSystemEntity> files = x.listSync();
        files.forEach((element) {
          print(element.path);
          map[element.path.split('/').last] = File(element.path);
        });
      }
      else {
        await _createDriverDirectory();
      }
    }
    catch(err) {
      print('error while reading all pictures');
      return null;
    }
    return map;
  }

   Future<File?> storeRiderPicture(String driverId, Uint8List list) async {

    try {
      final Directory temp = await getTemporaryDirectory();
      File x = File('${temp.path}/riders/$driverId');

      if(await x.exists()) {
        print('FILE ALREADY EXISTS');
        return x;
      }

      print('FILE DOESNT EXIST');
      File created = await x.create(recursive: true);
      return await created.writeAsBytes(list);
    }
    catch(err) {
      print('error while storing driver picture');
      return null;
    }



  }




  Future<void> _createDriverDirectory() async {
    try {
      final Directory temp = await getTemporaryDirectory();
      await Directory('${temp.path}/riders').create();
    }
    catch(err) {
      print('error while creating drivers directory');
    }
  }




}