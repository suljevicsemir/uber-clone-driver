import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/models/directions.dart';
import 'package:uber_clone_driver/models/ride_request.dart';
import 'package:uber_clone_driver/providers/driver_data_provider.dart';
import 'package:uber_clone_driver/services/directions_repository.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
class GoToRider extends StatefulWidget {

  static const String route = '/goToRider';

  final RideRequest rideRequest;
  final LatLng? origin;
  final LatLng? destination;

  GoToRider({
    required this.destination,
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

  late Marker destination;
  Marker? marker;
  Directions? info;

  StreamSubscription<LocationData>? x;


  Future<bool> notifyRider(BuildContext context, LocationData data) async {

    Map<String, dynamic> map = {
      'location' : GeoPoint(data.latitude!, data.longitude!),
      'firstName' : Provider.of<DriverDataProvider>(context, listen: false).driver!.firstName,
      'lastName'  : Provider.of<DriverDataProvider>(context, listen: false).driver!.lastName
    };


    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.rideRequest.riderId)
        .collection('ride_notifications')
        .doc(widget.rideRequest.id)
        .set(map);


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
          widget.destination!.latitude,
          widget.destination!.longitude,
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
    if( marker == null)
      return;

    LatLng latLng = LatLng(data.latitude! , data.longitude!);

    marker = Marker(
      markerId: MarkerId("driver"),
      position: latLng,
      rotation: data.heading!,
      draggable: false,
      //zIndex: 2,
      flat: true,
      icon: BitmapDescriptor.fromBytes(imageData!)
    );

    mapController.future.then((GoogleMapController controller) async {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(data.latitude!, data.longitude!),
          bearing: data.heading!,
          tilt: 90,
          zoom: 18
        )
      ));
      setState(() {

      });
    });




  }


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
      if( directions != null) {
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

    if( mapStyle == null || imageData == null || marker == null || info == null) {
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
                        startListener();
                      },
                      child: Text('START TRIP'),
                    ),
                  ),
                ],
              )
            ),
          )  : Container(),


          rideStarted ? Align(
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
