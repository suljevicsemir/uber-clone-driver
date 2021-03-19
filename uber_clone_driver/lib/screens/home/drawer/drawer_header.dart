

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uber_clone_driver/models/driver/driver.dart';
import 'package:uber_clone_driver/providers/driver_data_provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/account/account.dart';
import 'package:uber_clone_driver/screens/chats/chats.dart';

class HomeDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final File? picture = Provider.of<ProfilePicturesProvider>(context, listen: false).profilePicture;
    Driver? driver = Provider.of<DriverDataProvider>(context, listen: false).driver;
    if( driver == null) {
      driver = Provider.of<DriverDataProvider>(context).driver;
    }

    return (driver == null || picture == null) ?
    Shimmer.fromColors(
      //direction: ShimmerDirection.ttb,
        child: Container(
          height: 100,
          margin: EdgeInsets.only(left: 20, top: 10),
          width: double.infinity,
          child: Row(
            children: <Widget>[
              ClipOval(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Container(
                    color: Colors.red,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    'Loading, please wait...',
                    style: TextStyle(
                      fontSize: 48.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      baseColor: Colors.black12,
      highlightColor: Colors.white,
    ) :
    Container(
      color: Colors.black,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black
          ),
          child: Container(
           //margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async => await Navigator.pushNamed(context, Account.route),
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(picture),
                          backgroundColor: Colors.transparent,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                            child: RichText(
                              text: TextSpan(
                                  text: driver.firstName,
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan( text: ' ' + driver.lastName)
                                  ]
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Divider(color: Colors.grey, height: 1,),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      //onTap: () {},
                      onTap: () async => await Navigator.pushNamed(context, Chats.route),
                      splashColor: Colors.white,
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Text('Messages', style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.0),),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: ClipOval(
                                child: Container(
                                  color: Colors.blue,
                                  width: 10,
                                  height: 10,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(Icons.keyboard_arrow_right, color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
