
import 'dart:async';
import 'package:uber_clone_driver/components/app_utils.dart' as app;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class SMSRider extends StatefulWidget {

  final String phoneNumber;

  SMSRider({required this.phoneNumber});

  @override
  _SMSRiderState createState() => _SMSRiderState();
}

class _SMSRiderState extends State<SMSRider> {

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
          await app.sendSMS(context, phoneNumber: widget.phoneNumber);
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
                Icon(Icons.sms_outlined),
                SizedBox(width: 20,),
                Text('SMS message', style: TextStyle(fontSize: 20),)
              ],
            ),
          )
      ),
    );
  }
}
