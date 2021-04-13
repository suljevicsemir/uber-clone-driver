



import 'package:flutter/material.dart';

class ConnectivityOnlineSnackBar extends StatefulWidget {
  @override
  _ConnectivityOnlineSnackBarState createState() => _ConnectivityOnlineSnackBarState();
}

class _ConnectivityOnlineSnackBarState extends State<ConnectivityOnlineSnackBar> {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xff2C2f33),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('You are back online!', style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }
}


