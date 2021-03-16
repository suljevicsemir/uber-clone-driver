import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/components/authentication_wrapper.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/get_started/sign_in.dart';
import 'package:uber_clone_driver/screens/get_started/welcome_screen.dart';
import 'package:uber_clone_driver/services/firebase/authentication_service.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
    UberDriver()
  );
}



class UberDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => AuthenticationService(),
        ),
        StreamProvider(
          initialData: null,
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        ),
        ChangeNotifierProvider(
          create: (context) => ProfilePicturesProvider(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        initialRoute: AuthenticationWrapper.route,
        routes: {
          AuthenticationWrapper.route : (context) => AuthenticationWrapper(),
          WelcomeScreen.route : (context) => WelcomeScreen(),
          SignIn.route : (context) => SignIn()
        },
      ),
    );
  }
}
