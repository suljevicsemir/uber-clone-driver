

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_driver/models/driver/driver.dart';
import 'package:uber_clone_driver/models/rider/rider.dart';
import 'package:uber_clone_driver/screens/rider_account/rider_account.dart';

class DriverRiderSearchDelegate extends SearchDelegate{


  List<Rider> riders = [];

  DriverRiderSearchDelegate() {
    _load();
  }


  Future<void> _load() async{
    riders = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    var list = snapshot.docs;
    for(int i = 0; i < list.length; i++) {
      riders.add(Rider.fromSnapshot(list.elementAt(i)));
    }

  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () { query = "";},
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('What dis do?');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: riders.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, RiderAccount.route, arguments: riders.elementAt(index));
            },
            /*onTap: () async => await Navigator.pushNamed(context, DriverContact.route, arguments:
            MockDriver.fromObject(_drivers.elementAt(index))
            ),*/
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 10, bottom: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300]
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(riders.elementAt(index).firstName),
                      Text(' ' + riders.elementAt(index).lastName)
                    ],
                  )
              ),
            ),
          );
        },
      ),
    );
  }

}