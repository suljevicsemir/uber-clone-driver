import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:uber_clone_driver/models/chat_info.dart';

class ChatListTile extends StatelessWidget {

  final ChatInfo chatInfo;


  ChatListTile({required this.chatInfo});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
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
              backgroundImage: AssetImage('assets/images/person_avatar.png'),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Somebody',
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                          children: [
                            TextSpan( text: ' ' + 'YAH')
                          ]
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('message', style: Theme.of(context).textTheme.headline1, overflow: TextOverflow.ellipsis,)
                  ],
                ),
              ),
            ),
            //Text(timeago.format(////date))
          ],
        ),
      ),
    );
  }
}
