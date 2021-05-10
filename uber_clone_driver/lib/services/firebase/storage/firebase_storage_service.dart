

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {

  final Reference storageReference = FirebaseStorage.instance.ref();



  Future<TaskSnapshot?> uploadPictureFromFile(File file) async {
    print('Uploading picture...');
    try {
      TaskSnapshot? task = await storageReference.child("images/drivers/${FirebaseAuth.instance.currentUser!.uid}").putFile(file);
      if(task.state == TaskState.success) {
        print('Profile picture updated');
        String url = await task.ref.getDownloadURL();
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(FirebaseFirestore.instance.collection('drivers').doc(FirebaseAuth.instance.currentUser!.uid), {
            'profilePictureUrl' : url,
            'profilePictureTimestamp' : Timestamp.now()
          });
        });
      }
      return task;
    }
    catch (err) {
      print('Error uploading picture');
      print(err.toString());
      return null;
    }
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
    String? path = 'images/drivers/' + FirebaseAuth.instance.currentUser!.uid;
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