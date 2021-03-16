

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {

  final Reference storageReference = FirebaseStorage.instance.ref();



  Future<void> uploadPictureFromFile(File file) async {

  }

  Future<Uint8List?> getRiderPicture(String riderId) async {
    print('Downloading rider picture from storage with id ' + riderId);
    try {
      return await storageReference.child("images/riders/$riderId").getData(10485760);
    }
    catch(err) {
      print('error loading rider picture');
      print(err.toString());
      return null;
    }
  }

  Future<Uint8List?> getCurrentDriverPicture() async {

    print('Downloading current driver picture from storage');
    String? path = 'images/drivers/' + FirebaseAuth.instance.currentUser!.uid + '.jpg';
    print('ovo je putanja: ' + path);
    try {
      return await storageReference.child(path).getData(10485760);
    }
    catch(err) {
      print('error loading current driver picture');
      print(err.toString());
      return null;
    }
  }

}