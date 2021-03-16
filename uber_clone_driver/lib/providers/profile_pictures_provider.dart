

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uber_clone_driver/services/cached_data/temp_directory_service.dart';
import 'package:uber_clone_driver/services/firebase/storage/firebase_storage_service.dart';

class ProfilePicturesProvider extends ChangeNotifier {

  final FirebaseStorageService storageService = FirebaseStorageService();
  final TempDirectoryService tempDirectoryService = TempDirectoryService();

  File? profilePicture;
  Map<String, File>? riderProfilePictures = {};

  ProfilePicturesProvider() {
    if(FirebaseAuth.instance.currentUser != null) {
      loadCachedData();
    }
    notifyListeners();
  }

  Future<void> loadCachedData() async {
    _loadProfilePicture();
    _loadRidersPictures();
    //notifyListeners();
  }

  Future<void> _loadProfilePicture() async {
    profilePicture = await tempDirectoryService.loadDriverPicture();
    if(profilePicture == null) {
      Uint8List list = (await storageService.getCurrentDriverPicture())!;
      profilePicture = await tempDirectoryService.storeDriverPicture(list);
    }
    notifyListeners();
  }

  Future<void> _loadRidersPictures() async{
    riderProfilePictures = await tempDirectoryService.loadRidersPictures();
    notifyListeners();
  }

  Future<void> getList(List<String> riderIds) async {

    riderIds.forEach((riderId) async {
      if(riderProfilePictures![riderId] == null) {
        Uint8List? list = await storageService.getRiderPicture(riderId);
        riderProfilePictures![riderId] = (await tempDirectoryService.storeRiderPicture(riderId, list!))!;

      }
      notifyListeners();
    });
  }

  Future<File> getRiderPicture(String riderId) async{
    if(riderProfilePictures![riderId] != null) {
      return riderProfilePictures![riderId]!;
    }

    Uint8List? list = await storageService.getRiderPicture(riderId);
    riderProfilePictures![riderId] = (await tempDirectoryService.storeRiderPicture(riderId, list!))!;
    return riderProfilePictures![riderId]!;

  }







}