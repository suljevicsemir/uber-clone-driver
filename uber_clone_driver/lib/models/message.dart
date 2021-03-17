
import 'package:uber_clone_driver/constants/chatting/message_fields.dart' as fields;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Message {
  final String message, firebaseUserId;
  final Timestamp timestamp;

  Message({
    required this.message,
    required this.timestamp,
    required this.firebaseUserId
  });



  Message.fromSnapshot(DocumentSnapshot snapshot) :
      message        = snapshot.get(fields.message),
      firebaseUserId = snapshot.get(fields.firebaseUserId),
      timestamp      = snapshot.get(fields.timestamp);
}