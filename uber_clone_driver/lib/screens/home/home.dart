import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/home/bottom_bar.dart';
import 'package:uber_clone_driver/screens/home/bottom_go_button.dart';
import 'package:uber_clone_driver/screens/home/drawer/drawer.dart';
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
    return Scaffold(
      key: globalKey,
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
                BottomGoButton(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 100),
                    child: ElevatedButton(
                      onPressed: () async =>await Provider.of<ProfilePicturesProvider>(context, listen: false).deleteRiderPictures(),
                      child: Text('Delete rider pictures'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 100),
                    child: ElevatedButton(
                      onPressed: () async =>await Provider.of<ProfilePicturesProvider>(context, listen: false).deleteDriverPicture(),
                      child: Text('Delete driver picture'),
                    ),
                  ),
                )

              ]
            ),
          )
        ),
      ),
      endDrawer: HomeDrawer(),
    );
  }
}
