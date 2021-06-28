import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

  Future<void> callNumber(BuildContext context, {required String phoneNumber}) async{
    if(await canLaunch("tel://" + phoneNumber))
      launch("tel://" + phoneNumber);
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Unable to dial!', style: TextStyle(fontSize: 18, color: Colors.black87),),
          )
      );
    }
  }

  Future<void> sendSMS(BuildContext context, {required String phoneNumber}) async {
    if (await canLaunch('sms:' + phoneNumber)) {
      launch('sms:' + phoneNumber);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('Problem opening messaging app'))
      );
    }
  }

  Future<void> openAppLink(BuildContext context) async {
    bool shouldLaunch = true;
    if(Platform.isIOS) {
      if(await canLaunch('https://apps.apple.com/us/app/uber-driver/id1131342792')) {
        await launch('https://apps.apple.com/us/app/uber-driver/id1131342792');
      }
      else shouldLaunch = false;
    }
    if(Platform.isAndroid) {
      if(await canLaunch('https://play.google.com/store/apps/details?id=com.ubercab.driver&hl=en_US&gl=US')) {
        await launch('https://play.google.com/store/apps/details?id=com.ubercab.driver&hl=en_US&gl=US');
      }
      else shouldLaunch = false;
    }

    if(!shouldLaunch) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.symmetric(vertical: 10),
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 38,),
                SizedBox(width: 10,),
                Expanded(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Problem launching the rider app!', style: TextStyle(fontSize: 38),)),
                ),
                SizedBox(width: 10,)
              ],
            ),
          )
      );
    }


  }


  SnackBar connectivityOnlineSnackBar() {
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

  Row connectivityOfflineBanner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 5,
          width: 3,
          color: Colors.red,
        ),
        SizedBox(width: 1,),
        Container(
          color: const Color(0xff23272A),
          child: SizedBox(
            height: 8,
            width: 3,
          ),
        ),
        SizedBox(width: 1,),
        Container(
          color: const Color(0xff23272A),
          child: SizedBox(
            height: 11,
            width: 3,
          ),
        ),
        SizedBox(width: 10,),
        Text('Network connectivity limited or unavailable.')
      ],
    );
  }


  LatLng locationToLatLng(LocationData locationData) {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }