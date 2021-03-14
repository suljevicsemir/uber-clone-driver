import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: Container(
          child: Text('Semir je konj'),
        ),
      ),
    );
  }
}
