import 'package:flutter/material.dart';
import 'package:uber_clone_driver/screens/get_started/sign_in.dart';
import 'package:uber_clone_driver/screens/get_started/welcome_screen.dart';


void main() {
  runApp(
    UberDriver()
  );
}



class UberDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: WelcomeScreen(),
      initialRoute: WelcomeScreen.route,
      routes: {
        WelcomeScreen.route : (context) => WelcomeScreen(),
        SignIn.route : (context) => SignIn()
      },
    );
  }
}
