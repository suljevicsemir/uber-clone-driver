
import 'dart:async';
import 'package:uber_clone_driver/components/app_utils.dart' as app;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class CallRider extends StatefulWidget {

  final String phoneNumber;

  CallRider({required this.phoneNumber});

  @override
  _CallRiderState createState() => _CallRiderState();
}

class _CallRiderState extends State<CallRider> {


  bool pressed = false;
  void changePressedValue() {
    setState(() {
      pressed = !pressed;
    });
  }


  Future<void> onLongPress() async {
    changePressedValue();
    Timer(const Duration(milliseconds: 450), () => changePressedValue());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        changePressedValue();
        Timer(const Duration(milliseconds: 200), () async {
          await app.callNumber(context, phoneNumber: widget.phoneNumber);
          changePressedValue();
        });
      },
      onLongPress: onLongPress,
      child: AnimatedContainer(
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 5),
          duration: const Duration(milliseconds: 300),
          color: pressed ? Colors.grey : Colors.transparent,
          curve: Curves.fastOutSlowIn,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 20,),
                Text('Call driver', style: TextStyle(fontSize: 20),)
              ],
            ),
          )
      ),
    );
  }
}