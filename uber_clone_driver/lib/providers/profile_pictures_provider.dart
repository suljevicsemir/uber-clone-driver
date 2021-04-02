

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber_clone_driver/services/cached_data/temp_directory_service.dart';
import 'package:uber_clone_driver/services/firebase/storage/firebase_storage_service.dart';

class ProfilePicturesProvider extends ChangeNotifier {

  final FirebaseStorageService storageService = FirebaseStorageService();
  final TempDirectoryService tempDirectoryService = TempDirectoryService();

  File? _profilePicture;
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
    _profilePicture = await tempDirectoryService.loadDriverPicture();
    if(_profilePicture == null) {
      Uint8List list = (await storageService.getCurrentDriverPicture())!;
      _profilePicture = await tempDirectoryService.storeDriverPicture(list);
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

  Future<File?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile == null) {
      return null;
    }

    Uint8List list = await pickedFile.readAsBytes();
    final File? picture = await tempDirectoryService.storeDriverPicture(list);
    if( picture == null) return null;
    TaskSnapshot? snapshot = await storageService.uploadPictureFromFile(picture);
    if(snapshot == null)
      return null;
    _profilePicture = File(pickedFile.path);
    notifyListeners();
    return picture;

  }




  Future<File?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final PickedFile? pickedFile = await picker.getImage(source: ImageSource.camera);

    if(pickedFile == null) {
      return null;
    }

    Uint8List list = await pickedFile.readAsBytes();
    final File? picture = await tempDirectoryService.storeDriverPicture(list);
    if( picture == null) return null;
    TaskSnapshot? snapshot = await storageService.uploadPictureFromFile(picture);
    if(snapshot == null)
      return null;
    _profilePicture = File(pickedFile.path);
    notifyListeners();
    return picture;
  }

  File? get profilePicture => _profilePicture;

  Future<void> deleteRiderPictures() async {
    await tempDirectoryService.deleteRiderPictures();
  }
  Future<void> deleteDriverPicture() async {
    await tempDirectoryService.deleteDriverPicture();
  }

}