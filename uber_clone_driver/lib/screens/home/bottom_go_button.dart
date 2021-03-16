import 'package:flutter/material.dart';

class BottomGoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 100),
          child: ClipOval(
            child: Material(
              color: const Color(0xff3440c1),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.white,
                child: SizedBox(
                  height: height * 0.15,
                  width: height * 0.15,
                  child: Container(
                      margin: EdgeInsets.all(width * 0.025),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          border: Border.all(color: Colors.white, width: 2)
                      ),
                      child: Center(
                          child: Text('GO', style: TextStyle(color: Colors.white, fontSize: height * 0.05),)
                      )
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
