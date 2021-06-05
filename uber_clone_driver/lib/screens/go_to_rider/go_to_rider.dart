


import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uber_clone_driver/models/directions.dart';
import 'package:uber_clone_driver/services/directions_repository.dart';

class GoToRider extends StatefulWidget {

  static const String route = '/goToRider';

  final String mapStyle;
  final Uint8List? imageData;
  final LatLng? origin;
  final LatLng? destination;

  GoToRider({
    required this.mapStyle,
    required this.imageData,
    required this.destination,
    required this.origin
  });



  @override
  _GoToRiderState createState() => _GoToRiderState();
}

class _GoToRiderState extends State<GoToRider> {

  Completer<GoogleMapController> mapController = Completer();
  CameraPosition? initialCameraPosition;
  Location tracker = Location();

  bool isFirstRun = true;

  late Marker origin, destination;
  Directions? info;

  @override
  void initState() {

    super.initState();
    getCurrentLocation();
    origin = Marker(
      markerId: MarkerId("origin"),
      position: LatLng(43.796981, 18.092542),
      rotation: 0,
      draggable: false,
      icon: BitmapDescriptor.defaultMarker,
    );
    destination = Marker(
      markerId: MarkerId("destination"),
      position: LatLng(43.859350, 18.246751),
      rotation: 0,
      draggable: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
    );

    DirectionsRepository().getDirections(origin: LatLng(43.796981, 18.092542), destination: LatLng(43.859350, 18.246751)).then((Directions? directions) {
      if( directions != null)
      setState(() {

        info = directions;
        mapController.future.then((GoogleMapController controller) {
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(43.796981, 18.092542),
                zoom: 11
            )));
        });
      });
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  Future<void> getCurrentLocation() async {
    print('Fetching position..');
    LocationData data = await tracker.getLocation();
    print('Fetched position..');
    setState(() {
      initialCameraPosition = CameraPosition(
          target: LatLng(data.latitude!, data.longitude!),
          zoom: 15
      );

    });
  }


  @override
  Widget build(BuildContext context) {

    if( initialCameraPosition == null) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text('Fetching your position'),
          ),
        ),
      );
    }


    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition!,
        onMapCreated: (GoogleMapController controller) async {
          await controller.setMapStyle(widget.mapStyle);
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
        markers: Set.of([origin, destination]),

      ),
    );
  }
}
