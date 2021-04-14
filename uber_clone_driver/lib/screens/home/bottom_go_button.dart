import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/providers/home_provider.dart';


class BottomGoButton extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Provider.of<HomeProvider>(context).status ? Container() : Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 100),
            child: ClipOval(
              child: Material(
                color: const Color(0xff3440c1),
                child: InkWell(
                  onTap: () async {
                   await Provider.of<HomeProvider>(context, listen: false).updateStatus();
                  },
                  splashColor: Colors.transparent,
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
      ),
    ) ;
  }
}
