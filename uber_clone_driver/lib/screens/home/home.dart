import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone_driver/screens/home/bottom_bar.dart';
import 'package:uber_clone_driver/screens/home/bottom_go_button.dart';
import 'package:uber_clone_driver/screens/home/top_bar.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  void f () {
    Map<String, String> map = {};
    var x = map["nesto"];
    if(map["nesto"] == null) {

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
        child: SafeArea(
          child: Container(
            //margin: EdgeInsets.only(bottom: 20),
            child: Stack(
              children: [
                TopHomeBar(),
                BottomHomeBar(),
                BottomGoButton()
              ],
            ),
          )
        ),
      ),
    );
  }
}
