


import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uber_clone_driver/models/directions.dart';
import 'package:uber_clone_driver/services/directions_repository.dart';

class GoToRider extends StatefulWidget {

  static const String route = '/goToRider';


  final LatLng? origin;
  final LatLng? destination;

  GoToRider({
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

  Uint8List? imageData;
  String? mapStyle;


  bool isFirstRun = true;

  late Marker destination;
  Marker? marker;
  Directions? info;

  @override
  void initState() {

    super.initState();
    getCurrentLocation();

    destination = Marker(
      markerId: MarkerId("destination"),
      position: widget.destination!,
      rotation: 0,
      draggable: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
    );

    DirectionsRepository().getDirections(origin: widget.origin!, destination: widget.destination!).then((Directions? directions) {
      if( directions != null)
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
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if( isFirstRun) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
        String mapValue = await DefaultAssetBundle.of(context).loadString('assets/map/style.json');
        setState(() {
          isFirstRun = false;
          mapStyle = mapValue;
        });
      });
    }
  }

  Future<void> getCurrentLocation() async {
    print('Fetching position..');
    tracker.getLocation().then((LocationData data) async {
      setState(() {
        initialCameraPosition = CameraPosition(
          target: LatLng(data.latitude!, data.longitude!),
          zoom: 15
        );
      });

      ByteData byteData = await DefaultAssetBundle.of(context).load('assets/images/location.png');
      ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 60, targetHeight: 120);
      ui.FrameInfo fi = await codec.getNextFrame();
      Uint8List list =  (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

      setState(() {
        imageData = list;
        marker = Marker(
          markerId: MarkerId("driver"),
          position: LatLng(data.latitude!, data.longitude!),
          icon: BitmapDescriptor.fromBytes(list)
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if( initialCameraPosition == null) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text('Fetching your position...'),
          ),
        ),
      );
    }

    if( mapStyle == null || imageData == null || marker == null) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text('Prepping your trip..'),
          ),
        ),
      );
    }



    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition!,
        onMapCreated: (GoogleMapController controller) async {
          await controller.setMapStyle(mapStyle);
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
        markers: Set.of([destination, marker!]),

      ),
    );
  }
}
