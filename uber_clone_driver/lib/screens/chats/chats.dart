import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone_driver/models/chat_info.dart';
import 'package:uber_clone_driver/screens/chats/chat_list_tile.dart';
import 'package:uber_clone_driver/screens/chats/search_drivers_riders/search_delegate.dart';

class Chats extends StatefulWidget {

  static const String route = '/chats';

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Messages'),
        actions: [
          IconButton(
            onPressed: () async => await showSearch(context: context, delegate: DriverRiderSearchDelegate()),
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('drivers').doc(FirebaseAuth.instance.currentUser!.uid).collection('chats').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.hasError)
                return Text('There was an error');
              if(!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if( snapshot.data.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/such_empty.jpg'),
                      SizedBox(height: 50,),
                      Text('Wow, such empty.', style: TextStyle(fontSize: 22, color: Colors.grey[700]),)
                    ],
                  ),
                );
              }
              return Container(
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(color: Colors.grey, height: 0.0,),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) => snapshot.data.docs[index].get('lastMessage') != '' ?  ChatListTile(chatInfo: ChatInfo.fromSnapshot(snapshot.data.docs[index])) : Container()
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
