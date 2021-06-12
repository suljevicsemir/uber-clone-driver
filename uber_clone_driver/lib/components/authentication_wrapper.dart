import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/providers/driver_data_provider.dart';
import 'package:uber_clone_driver/providers/home_provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/get_started/welcome_screen.dart';
import 'package:uber_clone_driver/screens/home/home.dart';


class AuthenticationWrapper extends StatelessWidget {

  static const String route = '/';
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);
    if( user == null) return WelcomeScreen();
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Home(),
    );
  }
}
