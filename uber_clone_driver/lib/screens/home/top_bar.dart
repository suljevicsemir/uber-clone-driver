import 'package:flutter/material.dart';

class TopHomeBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: Material(
                color: Colors.white,
                child: InkWell(
                  splashColor: Colors.grey[800],
                  child: SizedBox(
                      width: 42,
                      height: 42,
                      child: Icon(Icons.search)
                  ),
                  onTap: () {},
                ),
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: height * 0.012, horizontal: width * 0.05),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2.5)
              ),
              child: Row(
                children: [
                  Text('\$ ', style: TextStyle(color: Colors.green, fontSize: 14),),
                  Text('135.48', style: TextStyle(color: Colors.white, fontSize: 22),)
                ],
              ),
            ),
            Spacer(),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/person_avatar.png'),
            )
          ],
        ),
      ),
    );
  }
}
