import 'package:flutter/material.dart';

class BottomHomeBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          color: Colors.white,
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
                  child: Text('You\'re offline', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w500),),
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
