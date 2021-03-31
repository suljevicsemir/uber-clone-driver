import 'package:flutter/cupertino.dart';
import 'package:uber_clone_driver/constants/chatting/chat_list.dart' as fields;
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class ChatInfo {
   final String
      chatId,
      lastMessage,
      lastMessageSenderFirebaseId,
      firebaseUserId,
      firstName,
      phoneNumber,
      lastName;
   final Timestamp lastMessageTimestamp;

  ChatInfo.fromSnapshot(DocumentSnapshot snapshot) :
        chatId                      = snapshot.id,
        lastMessage                 = snapshot.get(fields.lastMessage),
        lastMessageSenderFirebaseId = snapshot.get(fields.lastMessageSenderFirebaseId),
        lastMessageTimestamp        = snapshot.get(fields.lastMessageTimestamp),
        firebaseUserId              = snapshot[fields.firebaseUserId],
        firstName                   = snapshot[fields.firstName],
        lastName                    = snapshot[fields.lastName],
        phoneNumber                 = snapshot[fields.phoneNumber];
}