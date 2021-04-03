import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/components/authentication_wrapper.dart';
import 'package:uber_clone_driver/models/rider/rider.dart';
import 'package:uber_clone_driver/providers/driver_data_provider.dart';
import 'package:uber_clone_driver/providers/profile_pictures_provider.dart';
import 'package:uber_clone_driver/screens/account/account.dart';
import 'package:uber_clone_driver/screens/chat/chat.dart';
import 'package:uber_clone_driver/screens/chats/chats.dart';
import 'package:uber_clone_driver/screens/get_started/sign_in.dart';
import 'package:uber_clone_driver/screens/get_started/welcome_screen.dart';
import 'package:uber_clone_driver/screens/rider_account/rider_account.dart';
import 'package:uber_clone_driver/services/firebase/authentication_service.dart';
import 'package:uber_clone_driver/theme/theme.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
    UberDriver()
  );
}



class UberDriver extends StatefulWidget{




  @override
  _UberDriverState createState() => _UberDriverState();
}

class _UberDriverState extends State<UberDriver> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

  }


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
        ),
        ChangeNotifierProvider(
          create: (context) => DriverDataProvider(),
          lazy: false,
        ),

      ],
      child: MaterialApp(
        theme: AppTheme.appTheme(),
        initialRoute: AuthenticationWrapper.route,
        routes: {
          AuthenticationWrapper.route : (context) => AuthenticationWrapper(),
          WelcomeScreen.route : (context) => WelcomeScreen(),
          SignIn.route : (context) => SignIn(),
          Chats.route : (context) => Chats(),
          Account.route : (context) => Account(),
          RiderAccount.route: (context) => RiderAccount(rider: ModalRoute.of(context)!.settings.arguments as Rider),
          Chat.route : (context) => Chat(rider: ModalRoute.of(context)!.settings.arguments as Rider,)
        },
      ),
    );
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeDependencies();
    if(state == AppLifecycleState.paused) {
      print('app is paused');
    }
    if(state == AppLifecycleState.detached) {
      print('app is detached');
    }

    if(state == AppLifecycleState.inactive) {
      print('app is inactive');
    }
    if(state == AppLifecycleState.resumed) {
      print('app is resumed');
    }

  }
}
