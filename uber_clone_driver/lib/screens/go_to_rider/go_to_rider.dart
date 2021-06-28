import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/models/directions.dart';
import 'package:uber_clone_driver/models/ride_request.dart';
import 'package:uber_clone_driver/providers/driver_data_provider.dart';
import 'package:uber_clone_driver/providers/location_provider.dart';
import 'package:uber_clone_driver/screens/export.dart';
import 'package:uber_clone_driver/services/directions_repository.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:uber_clone_driver/components/app_utils.dart' as app;

class GoToRider extends StatefulWidget {
  static const String route = '/goToRider';

  final RideRequest rideRequest;
  final LatLng? origin;

  GoToRider({
    required this.origin,
    required this.rideRequest
  });

  @override
  _GoToRiderState createState() => _GoToRiderState();
}

class _GoToRiderState extends State<GoToRider> {

  Completer<GoogleMapController> mapController = Completer();
  CameraPosition? initialCameraPosition;
  Location tracker = Location();

  Uint8List? imageData;
  String? mapStyle;


  bool isFirstRun = true;
  bool rideStarted = false;
  bool originReached = false;

  late Marker location;
  late Marker destination;

  Directions? info;

  StreamSubscription<LocationData>? x;


  @override
  void initState() {

    super.initState();

    location = Marker(
        markerId: MarkerId("location"),
        position: LatLng(widget.rideRequest.location.latitude, widget.rideRequest.location.longitude),
        rotation: 0,
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
    );

    destination = Marker(
      markerId: MarkerId("destination"),
      position: LatLng(widget.rideRequest.destination.latitude, widget.rideRequest.destination.longitude),
      rotation: 0,
      draggable: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)
    );

    DirectionsRepository().getDirections(
        origin: widget.origin!,
        destination: LatLng(widget.rideRequest.location.latitude, widget.rideRequest.location.longitude))
        .then((Directions? directions) async{
      if( directions != null) {

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(FirebaseFirestore.instance
              .collection('ride_requests')
              .doc(widget.rideRequest.id), {
              'answeredBy'      : FirebaseAuth.instance.currentUser!.uid,
              'answeredFrom'    : GeoPoint(widget.origin!.latitude, widget.origin!.longitude),
              'expectedArrival' : directions.totalDuration,
              'isActive'        : false
          });
          transaction.set(FirebaseFirestore.instance
              .collection('drivers')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('ride_answers')
              .doc(widget.rideRequest.id),
              widget.rideRequest.toMap()
          );

        });

        setState(() {

          info = directions;
          mapController.future.then((GoogleMapController controller) {
            controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: widget.origin!,
                    zoom: 11
                )));
          });
        });

      }

    });
  }


  Future<bool> notifyRider(BuildContext context, LocationData data) async {
    setState(() {
      originReached = true;
    });

    Map<String, dynamic> map = {
      'latitude' : data.latitude,
      'longitude' : data.longitude,
      'firstName' : Provider.of<DriverDataProvider>(context, listen: false).driver!.firstName,
      'lastName'  : Provider.of<DriverDataProvider>(context, listen: false).driver!.lastName
    };


    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.rideRequest.riderId)
        .collection('ride_notifications')
        .doc(widget.rideRequest.id)
        .set(map);

    DirectionsRepository().getDirections(
      origin: Provider.of<LocationProvider>(context, listen: false).lastLocation!,
      destination: LatLng(widget.rideRequest.destination.latitude, widget.rideRequest.destination.longitude)
    ).then((Directions? directions) {
      setState(() {
        info = directions;
      });
    });


    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('You reached your destination!'),
        content: Text('Your rider will be notified of your arrival. If the rider does not see you '
            'we will help them contact you!'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK')
          )
        ],
      );
    });

    return true;
  }


  Future<void> startListener() async{
    setState(() {
      rideStarted = true;
    });

    x = tracker.onLocationChanged.listen((LocationData? data) async {
      if( data == null)
        return;

      if( data.latitude == null || data.longitude == null)
        return;

      double distance = geolocator.Geolocator.distanceBetween(
          widget.rideRequest.destination.latitude,
          widget.rideRequest.destination.longitude,
          data.latitude!,
          data.longitude!);

      if( distance < 3) {
          await x!.cancel();
          notifyRider(context, data);
      }

      updateDriverMarker(data);

    });
  }

  void updateDriverMarker(LocationData data) {
    mapController.future.then((GoogleMapController controller) async {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(data.latitude!, data.longitude!),
              bearing: data.heading!,
              tilt: 90,
              zoom: 18
          )
      ));
    });
  }




  @override
  Widget build(BuildContext context) {

    if(info == null) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text('Prepping your trip..'),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: Provider.of<LocationProvider>(context, listen: false).lastLocation!,
              zoom: 15
            ),
            onMapCreated: (GoogleMapController controller) async {
              await controller.setMapStyle(Provider.of<LocationProvider>(context, listen: false).mapStyle);
              mapController.complete(controller);
            },
            polylines: info == null ? Set.of([]) : Set.of([
              Polyline(
                  polylineId: PolylineId("polyline"),
                  color: Colors.red,
                  width: 5,
                  points: info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList()
              ),
            ]),
            markers: Set.of([location, destination, Provider.of<LocationProvider>(context).driverMarker!]),

          ),

          if (info != null && !rideStarted) Container(
            margin: EdgeInsets.only(top: 30),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent, width: 5)
                ),
                child: Text(
                  info!.totalDuration, style: TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ) else Container(),

         !rideStarted?
          Container(
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 1.0)
                      ),
                      onPressed: () async{
                        mapController.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                          target: Provider.of<LocationProvider>(context, listen : false).lastLocation!,
                          tilt: 90,
                          zoom: 18
                        )))
                        );
                        startListener();

                      },
                      child: Text('START TRIP'),
                    ),
                  ),
                ],
              )
            ),
          )  : Container(),

          rideStarted && !originReached ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        textStyle: TextStyle(fontSize: 22, color: Colors.black),
                        primary: Colors.white,
                        onPrimary: Colors.black
                      ),
                      onPressed: () async{
                        LocationData data = await tracker.getLocation();
                        await notifyRider(context, data);
                      },
                      child: Text('Notify rider of your arrival!'),
                    ),
                  ),
                ],
              )
            ),
          ) : Container(),

          originReached ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            textStyle: TextStyle(fontSize: 22, color: Colors.black),
                            primary: Colors.white,
                            onPrimary: Colors.black
                        ),
                        onPressed: () async{
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: Text('You ended the ride.'),
                            content: Text('If you had only complaints, find your ride in your history section and submit to us.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text('OK'))
                            ],
                          ));
                        },
                        child: Text('End the ride'),
                      ),
                    ),
                  ],
                )
            ),
          ) : Container()

        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();

    if( x != null) {
      x!.cancel();
    }

  }
}
