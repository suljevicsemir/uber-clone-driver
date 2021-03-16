
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/components/authentication_wrapper.dart';
import 'package:uber_clone_driver/firebase_response_results/sign_in.dart';
import 'package:uber_clone_driver/services/firebase/authentication_service.dart';

class SignIn extends StatefulWidget {

  static const route = '/signIn';

  @override
  _SignINState createState() => _SignINState();
}

class _SignINState extends State<SignIn> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextStyle titleStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500
  );

  @override
  void initState() {
    super.initState();

  }

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.black
        ),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Please sign in', style: titleStyle,),
                        SizedBox(height: 20,),
                        Form(
                          key: key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if(value == null) return 'Please enter your email address';
                                  String email = value;

                                  bool valid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                                  if(valid)
                                      return null;
                                  return 'Email format incorrect';
                                },
                                controller: emailController,
                                autofocus: true,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  errorStyle: TextStyle(fontSize: 19, color: Colors.red),
                                  labelText: 'Email address',
                                  hintText: 'name@example.com',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                  )
                                ),

                              ),
                              SizedBox(height: 50,),
                              TextFormField(
                                validator: (value) {
                                  if(value == null) {
                                    return 'Password cannot be empty!';
                                  }
                                  if(value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                  errorStyle: TextStyle(fontSize: 16, color: Colors.red),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red)
                                  )
                                ),

                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text('I forgot my password', style: TextStyle(fontSize: 19, color: Colors.blue, fontWeight: FontWeight.w300),)
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.white,
        child: Icon( Icons.arrow_forward_rounded),
        onPressed: () async {
          if(key.currentState!.validate()) {
            final SignInResult credential = await Provider.of<AuthenticationService>(context, listen: false).signInWithEmail(email: emailController.text, password: passwordController.text);
            if(credential.result == SignInResults.Success) {
              await Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context) => AuthenticationWrapper()), (_) => false);
            }

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  content: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 36, color: Colors.white,),
                      SizedBox(width: 10,),
                      Flexible(
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(credential.result.parseMessage(), style: TextStyle(fontSize: 22),)
                        ),
                      )
                    ],
                  ),
                )
            );
          }
        },
        elevation: 30,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
