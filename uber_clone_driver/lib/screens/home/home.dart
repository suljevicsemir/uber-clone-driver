import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/home/bottom_bar.dart';
import 'package:uber_clone_driver/screens/home/bottom_go_button.dart';
import 'package:uber_clone_driver/screens/home/top_bar.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    bool x = Provider.of<ProfilePicturesProvider>(context, listen: true).profilePicture == null && Provider.of<ProfilePicturesProvider>(context, listen: true).riderProfilePictures == null;
    if( x ) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
        child: SafeArea(
          child:  Container(
            child: Stack(
              children: [
                TopHomeBar(),
                BottomHomeBar(),
                BottomGoButton()
              ]
            ),
          )
        ),
      ),
    );
  }
}
