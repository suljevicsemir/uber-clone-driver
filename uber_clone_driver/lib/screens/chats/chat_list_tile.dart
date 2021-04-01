import 'dart:io';

import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:uber_clone_driver/models/chat_info.dart';
import 'package:uber_clone_driver/models/rider/rider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/chat/chat.dart';

class ChatListTile extends StatelessWidget {

  final ChatInfo chatInfo;


  ChatListTile({required this.chatInfo});

  @override
  Widget build(BuildContext context) {

    File? picture = Provider.of<ProfilePicturesProvider>(context, listen: false).riderProfilePictures![chatInfo.firebaseUserId];

    if(picture == null) {
      picture = Provider.of<ProfilePicturesProvider>(context).riderProfilePictures![chatInfo.firebaseUserId];
    }

    return picture == null ? Container() :


    ElevatedButton(
      onPressed: () async => await Navigator.pushNamed(context, Chat.route, arguments: Rider.fromChatInfo(chatInfo)),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        onPrimary: Colors.grey[800]
      ),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.transparent,
              backgroundImage: FileImage(picture)
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: chatInfo.firstName,
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                          children: [
                            TextSpan( text: ' ' + chatInfo.lastName)
                          ]
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(chatInfo.lastMessage, style: Theme.of(context).textTheme.headline1, overflow: TextOverflow.ellipsis,)
                  ],
                ),
              ),
            ),
            Text(timeago.format(chatInfo.lastMessageTimestamp.toDate(), locale: 'en_short'))
          ],
        ),
      ),
    );
  }
}
