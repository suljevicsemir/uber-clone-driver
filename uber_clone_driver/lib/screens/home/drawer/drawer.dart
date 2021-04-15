import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/screens/home/drawer/drawer_header.dart';
import 'package:uber_clone_driver/services/firebase/authentication_service.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            HomeDrawerHeader(),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                      width: double.infinity,
                      child: InkWell(
                        onTap: () async => await Provider.of<AuthenticationService>(context, listen: false).signOut(),
                        splashColor: Colors.grey[900],
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Sign out'
                          ),
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
