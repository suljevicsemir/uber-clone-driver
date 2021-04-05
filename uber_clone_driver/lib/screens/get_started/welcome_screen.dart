

import 'package:uber_clone_driver/components/app_utils.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone_driver/screens/get_started/sign_in.dart';


class WelcomeScreen extends StatelessWidget {

  static const route = '/welcome';

  final TextStyle welcomeStyle = TextStyle(
    fontSize: 34,
    letterSpacing: 1.0
  );

  final TextStyle buttonStyle = TextStyle(
    fontSize: 20,
    letterSpacing: 0.8,
    fontWeight: FontWeight.w400
  );

  final TextStyle rideStyle = TextStyle(
    fontSize: 18,
    color: Colors.blue,
    fontWeight: FontWeight.w400
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/welcome.jpg'),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text('Welcome to the Driver app', style: welcomeStyle,)),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)
                          ),
                          onPrimary: Colors.white,

                        ),
                        onPressed: () async => await Navigator.pushNamed(context, SignIn.route),
                        child: Text('SIGN IN', style: buttonStyle.copyWith(color: Colors.white),)
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            elevation: 0.0,
                            onPrimary: Colors.blue,
                            primary: Theme.of(context).scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue, width: 1),
                              borderRadius: BorderRadius.circular(2),
                            )
                        ),
                        onPressed: () {},
                        child: Text('REGISTER', style: buttonStyle.copyWith(color: Colors.blue),)
                    ),
                  ),
                  SizedBox(width: 10,)


                ],
              ),
              Divider(height: 30, color: Colors.grey, thickness: 0.5,),
              GestureDetector(
                onTap: () async => await app.openAppLink(context),
                child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('or Ride with Uber', style: rideStyle,)
                ),
              ),
              SizedBox(height: 20,)

            ],
          )
        ),
      ),
    );
  }
}
