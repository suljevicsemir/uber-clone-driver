import 'package:flutter/material.dart';
import 'package:uber_clone_driver/screens/home/drawer/drawer_header.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(

          padding: EdgeInsets.zero,
          children: [
            HomeDrawerHeader(),
          ],
        ),
      ),
    );
  }
}
