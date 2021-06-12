import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/components/authentication_wrapper.dart';
import 'package:uber_clone_driver/models/ride_request.dart';
import 'package:uber_clone_driver/models/rider/rider.dart';
import 'package:uber_clone_driver/providers/chat_provider.dart';
import 'package:uber_clone_driver/screens/export.dart';
import 'package:uber_clone_driver/screens/get_started/sign_in.dart';
import 'package:uber_clone_driver/screens/get_started/welcome_screen.dart';
import 'package:uber_clone_driver/screens/go_to_rider/go_to_rider.dart';


class UberRouter {

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Account.route:
        return MaterialPageRoute(
            builder: (_) => Account()
        );

      case Chat.route:
        Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => Provider(
                create: (context) => ChatProvider(driver: map['driver'], rider: map['rider']),
                child: Chat(rider: map['rider'] as Rider,)
            )
        );

      case Chats.route:
        return MaterialPageRoute(
            builder: (_) => Chats()
        );

      case WelcomeScreen.route:
        return MaterialPageRoute(
            builder: (_) => WelcomeScreen()
        );

      case SignIn.route:
        return MaterialPageRoute(
            builder: (_) => SignIn()
        );

      case RiderAccount.route:
        return MaterialPageRoute(
            builder: (_) => RiderAccount(rider: settings.arguments as Rider)
        );

      case GoToRider.route:

        Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
        LatLng origin = map['location'] as LatLng;
        RideRequest rideRequest = map['rideRequest'];

        return MaterialPageRoute(
          builder: (_) => GoToRider(
            origin: origin,
            rideRequest: rideRequest,)
        );

      default:
        return MaterialPageRoute(
            builder: (_) => AuthenticationWrapper()
        );
    }
  }
}