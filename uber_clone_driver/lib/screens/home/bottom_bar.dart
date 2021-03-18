import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/providers/home_provider.dart';
import 'package:uber_clone_driver/screens/home/home.dart';

class BottomHomeBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 10,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                  child: Icon(Icons.keyboard_arrow_up_outlined, size: 40,)),
              //Spacer(),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Provider.of<HomeProvider>(context).status ?
                  Container(
                    child: Column(
                      children: [
                        Text('You are currently available', style: TextStyle(color: Colors.black, fontSize: 22),),
                        GestureDetector(
                          onTap: () {
                            Provider.of<HomeProvider>(context, listen: false).updateStatus();
                          },
                          child: Text('Go offline', style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.w500),))
                      ],
                    ),
                  )
                  :
                  Text('You\'re offline', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w500),),
                ),
              ),
              //Spacer(),
              Container(
                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04),
                  child: Icon(Icons.list, size: 40,))
            ],
          )
      ),
    );
  }
}
