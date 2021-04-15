import 'package:uber_clone_driver/constants/chatting/chat_list.dart' as chat_list;
import 'package:uber_clone_driver/constants/chatting/message_fields.dart' as message_fields;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_driver/models/chat_info.dart';
import 'package:uber_clone_driver/models/driver/driver.dart';
import 'package:uber_clone_driver/models/message.dart';
import 'package:uber_clone_driver/models/rider/rider.dart';

class ChatProvider {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  final CollectionReference _driversReference = FirebaseFirestore.instance.collection('drivers');
  final CollectionReference _userReference = FirebaseFirestore.instance.collection('users');
  final CollectionReference _chatReference = FirebaseFirestore.instance.collection('chats');

  final Driver driver;
  late String chatId;
  final Rider rider;


  ChatProvider({ required this.driver, required this.rider}) {
    chatId = 'chat' +  (driver.id.compareTo(rider.firebaseId) < 0 ?
    (driver.id + rider.firebaseId) : (rider.firebaseId + driver.id));
  }

  Future<void> sendMessage(Message message) async {

    Map<String, dynamic> snapshot = _buildMessage(message);

    await _instance.runTransaction((transaction) async {
      transaction.set(_chatReference.doc(chatId).collection('messages').doc(DateTime.now().millisecondsSinceEpoch.toString()), snapshot);
    });

    await _instance.runTransaction((transaction) async {
      transaction.update(_driversReference.doc( driver.id ).collection('chats').doc(chatId), {
        chat_list.lastMessage                 : message.message,
        chat_list.lastMessageTimestamp        : message.timestamp,
        chat_list.lastMessageSenderFirebaseId : driver.id
      });
    });


    await _instance.runTransaction((transaction) async {
      transaction.update(_userReference.doc(rider.firebaseId).collection('chats').doc(chatId), {
        chat_list.lastMessage                 : message.message,
        chat_list.lastMessageTimestamp        : message.timestamp,
        chat_list.lastMessageSenderFirebaseId : driver.id
      });
    });


  }

  Map<String, dynamic> _buildMessage(Message message) {
    return {
      message_fields.firebaseUserId   : driver.id,
      message_fields.message          : message.message,
      message_fields.timestamp        : message.timestamp
    };
  }

  Future<void> createChat() async {

    //first we check are the collections already created
    DocumentSnapshot chatHistory = await _chatReference.doc(chatId).get();
    // chat collections are already created, even if there aren't any messages exchanged
    if(chatHistory.exists) {
      return;
    }

    // if not, we need to create three new collections

    _instance.runTransaction((transaction) async {
      transaction.set(_chatReference.doc(chatId), {
        'firebaseUserId1' : driver.id,
        'firebaseUserId2' : rider.firebaseId
      });
    });




    //chat list of current user
    _instance.runTransaction((transaction) async {
      transaction.set( _driversReference.doc(driver.id).collection('chats').doc(chatId), {
        chat_list.firebaseUserId              : rider.firebaseId,
        chat_list.firstName                   : rider.firstName,
        chat_list.lastName                    : rider.lastName,
        //chat_list.lastMessage                 : '',
        //chat_list.lastMessageTimestamp        : null,
        //chat_list.lastMessageSenderFirebaseId : null,
        chat_list.phoneNumber                 : rider.phoneNumber
      });
    });

    //chat list of driver the user is chatting with
    _instance.runTransaction((transaction) async {
      transaction.set(_userReference.doc(rider.firebaseId).collection('chats').doc(chatId), {
        chat_list.firebaseUserId              : driver.id,
        chat_list.firstName                   : driver.firstName,
        chat_list.lastName                    : driver.lastName,
        //chat_list.lastMessage                 : '',
        //chat_list.lastMessageTimestamp        : null,
        //chat_list.lastMessageSenderFirebaseId : null,
        chat_list.phoneNumber                 : driver.phoneNumber
      });
    });


  }



}