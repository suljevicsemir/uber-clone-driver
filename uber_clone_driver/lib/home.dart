import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/components/authentication_wrapper.dart';
import 'package:uber_clone_driver/services/firebase/authentication_service.dart';

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
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await Provider.of<AuthenticationService>(context, listen: false).signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthenticationWrapper()), (_) => false);
                },
                child: Text('Sign out'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
