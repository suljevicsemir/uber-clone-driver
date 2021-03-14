import 'package:flutter/material.dart';
import 'package:uber_clone_driver/get_started/welcome_screen.dart';
import 'package:uber_clone_driver/home.dart';

void main() {
  runApp(
    UberDriver()
  );
}



class UberDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: WelcomeScreen(),
    );
  }
}
