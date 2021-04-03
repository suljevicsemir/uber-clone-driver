import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/components/call_number.dart';
import 'package:uber_clone_driver/models/driver/driver.dart';
import 'package:uber_clone_driver/models/message.dart';
import 'package:uber_clone_driver/models/rider/rider.dart';
import 'package:uber_clone_driver/providers/chat_provider.dart';
import 'package:uber_clone_driver/providers/driver_data_provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';

class Chat extends StatefulWidget {

 static const route = '/chat';

 final Rider rider;
 Chat({required this.rider});


  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  late ChatProvider chatProvider;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late File picture;
  late String chatId;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Driver? x = Provider.of<DriverDataProvider>(context, listen: false).driver;
    chatProvider = ChatProvider(driver: x!, rider: widget.rider);
    _scrollChatToBottom();
    picture = Provider.of<ProfilePicturesProvider>(context).riderProfilePictures![widget.rider.firebaseId]!;
  }




  _scrollChatToBottom() {

    if(scrollController.hasClients) {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 120),
        curve: Curves.linear
      );
    }
    else {
      Timer(const Duration(milliseconds: 40), () => _scrollChatToBottom());
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: Colors.transparent,
              backgroundImage: FileImage(picture),
            ),
            SizedBox(width: 10,),
            Text(widget.rider.firstName)
          ],
        ),
        actions: [

          CallNumber(phoneNumber: widget.rider.phoneNumber,)
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).viewInsets.bottom + 96,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chats').doc(chatProvider.chatId).collection('messages').limit(100).snapshots(),
                builder: (context, AsyncSnapshot snapshot)  {

                  if(!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if( snapshot.data!.docs.isEmpty) {
                    //create chat in chats collection and in users-chats
                    chatProvider.createChat();
                    return Center(
                        child: Text('No messages with ' + widget.rider.firstName + ' ' + widget.rider.lastName)
                    );
                  }
                  Timer(const Duration(milliseconds: 100), () => {
                    _scrollChatToBottom()
                  });
                  int docsLength = snapshot.data.docs.length;
                  return Container(
                    child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) => _buildMessage(context, Message.fromSnapshot(snapshot.data.docs[index]),
                            index < docsLength - 1 ? Message.fromSnapshot(snapshot.data.docs[index + 1]) : null,
                          index == docsLength - 1)

                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.blue,
                  border: Border(
                      top: BorderSide(
                          width: 0.5,
                          color: Colors.grey
                      )
                  )
              ),
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 19),
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 3)
                                  ),
                                  enabledBorder: InputBorder.none
                              ),
                              cursorColor: Colors.yellow,
                              cursorHeight: 26,
                              cursorWidth: 2,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          child: IconButton(
                              splashColor: Colors.red,
                              splashRadius: 25,
                              padding: EdgeInsets.all(8),
                              color: Colors.yellow,
                              onPressed: () async{
                                Timestamp timestamp = Timestamp.now();
                                Message message = Message(message: textController.text, timestamp: timestamp, firebaseUserId: FirebaseAuth.instance.currentUser!.uid);
                                textController.clear();
                                await chatProvider.sendMessage(message);
                                _scrollChatToBottom();
                              },
                              icon: Icon(Icons.send)
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {},
                          icon: Icon(Icons.animation),
                        ),
                        IconButton(icon: Icon(Icons.ac_unit), onPressed: () {})
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildMessage(BuildContext context, Message message, Message? nextMessage, bool isLast) {

    bool isNextSent = false;
    bool sentMessage = message.firebaseUserId == FirebaseAuth.instance.currentUser!.uid ? true : false;
    if( nextMessage != null) {
      isNextSent = nextMessage.firebaseUserId == FirebaseAuth.instance.currentUser!.uid;
    }

    bool shouldHavePicture = (isNextSent && !sentMessage) || (isLast && !sentMessage);



    return Row(
      mainAxisAlignment: sentMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        shouldHavePicture ? CircleAvatar(
          radius: 17,
          backgroundColor: Colors.transparent,
          backgroundImage: FileImage(picture),
        ):
        Container() ,
        Container(
          padding: EdgeInsets.all(10),
          margin: (sentMessage) ? EdgeInsets.only(right: 10, bottom: 10) : shouldHavePicture ? EdgeInsets.only(bottom: 10) :  EdgeInsets.only(left: 34 , bottom: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20)
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.5
          ),
          child: Text(message.message, style: TextStyle(color: Colors.black, fontSize: 17),),
        ),
      ],
    );
  }
}
