

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_driver/constants/rider/rider_fields.dart' as fields;
import 'package:uber_clone_driver/models/chat_info.dart';
class Rider {
  final String
    firstName,
    lastName,
    phoneNumber,
    firebaseId,
    profilePictureUrl;


    Rider.fromSnapshot(DocumentSnapshot snapshot) :
      firstName = snapshot.get(fields.firstName),
      lastName = snapshot.get(fields.lastName),
      phoneNumber = 'fake',
      firebaseId = snapshot.id,
      profilePictureUrl = snapshot.get("profilePictureUrl");

    Rider.fromChatInfo(ChatInfo chatInfo):
      firstName   = chatInfo.firstName,
      lastName    = chatInfo.lastName,
      phoneNumber = chatInfo.phoneNumber,
      firebaseId  = chatInfo.firebaseUserId,
      profilePictureUrl = "irrelevant";



}