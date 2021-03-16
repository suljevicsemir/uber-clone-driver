import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone_driver/screens/home/bottom_bar.dart';
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 100),
                    child: ClipOval(
                      child: Material(
                        color: const Color(0xff3440c1),
                        child: InkWell(
                          onTap: () {},
                          splashColor: Colors.white,
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                                border: Border.all(color: Colors.white, width: 2)
                              ),
                              child: Center(
                                  child: Text('GO', style: TextStyle(color: Colors.white, fontSize: 30),)
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
