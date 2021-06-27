import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/components/connectivity_notifier.dart';

import 'package:uber_clone_driver/providers/internet_connectivity_provider.dart';
import 'package:uber_clone_driver/providers/location_provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/home/bottom_bar.dart';
import 'package:uber_clone_driver/screens/home/bottom_go_button.dart';
import 'package:uber_clone_driver/screens/home/drawer/drawer.dart';
import 'package:uber_clone_driver/screens/home/map/map.dart';
import 'package:uber_clone_driver/screens/home/top_bar.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final globalKey = GlobalKey<ScaffoldState>();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    bool x = Provider.of<ProfilePicturesProvider>(context, listen: true).profilePicture == null && Provider.of<ProfilePicturesProvider>(context, listen: true).riderProfilePictures == null;
    if( x ) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if( !Provider.of<LocationProvider>(context).isDataReady)

      return Scaffold(
        body: Container(
          child: Center(
            child: Text('Loading resources...'),
          ),
        ),
      );


    return Scaffold(
      key: globalKey,
      //extendBodyBehindAppBar: true,
      //backgroundColor: Colors.blue,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
        child: Container(
          child: Stack(
            children: [
              HomeMap(),
              TopHomeBar(),
              BottomHomeBar(),
              BottomGoButton(),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: ConnectivityNotifier()
              )
            ]
          ),
        ),
      ),
      endDrawer: HomeDrawer(),
    );
  }
}
