

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/models/ride_request.dart';
import 'package:uber_clone_driver/models/rider/rider.dart';
import 'package:uber_clone_driver/providers/location_provider.dart';
import 'package:uber_clone_driver/screens/go_to_rider/go_to_rider.dart';

class RideRequestBottomSheet extends StatefulWidget {


  final RideRequest rideRequest;

  RideRequestBottomSheet({required this.rideRequest});


  @override
  _RideRequestBottomSheetState createState() => _RideRequestBottomSheetState();
}

class _RideRequestBottomSheetState extends State<RideRequestBottomSheet> {


  Rider? rider;
  Location tracker = Location();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').doc(widget.rideRequest.riderId).get().then((DocumentSnapshot snapshot) {
      setState(() {
        rider = Rider.fromSnapshot(snapshot);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.black,
      child: rider == null ? Container() :
      Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(rider!.profilePictureUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(rider!.firstName + " " + rider!.lastName, style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 15)
                      ),
                      onPressed: () async {
                       Map<String, dynamic> path = {
                          'location' : Provider.of<LocationProvider>(context, listen: false).lastLocation!,
                          'rideRequest' : widget.rideRequest
                       };

                        Future.delayed(const Duration(milliseconds: 100), () =>
                            Navigator.pushNamed(context, GoToRider.route, arguments: path)
                        );

                      },
                      child: Text('Answer ride request', style: TextStyle(fontSize: 24),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}
