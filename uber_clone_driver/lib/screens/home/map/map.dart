

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/providers/home_provider.dart';

class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {

  Completer<GoogleMapController> mapController = Completer();
  String? mapStyle;
  CameraPosition? initialCameraPosition;
  Location tracker = Location();
  LocationData? lastLocation;
  Uint8List? imageData;
  Marker? marker;

  Future<void> getCurrentLocation() async{
    await tracker.changeSettings(accuracy: LocationAccuracy.powerSave);
    LocationData data = await tracker.getLocation();
    setState(() {
      initialCameraPosition = CameraPosition(
        target: LatLng(data.latitude!, data.longitude!),
        zoom: 15
      );
      lastLocation = data;
    });
    updateMarker(data);
  }


  void updateMarker(LocationData data) {
    LatLng latLng = LatLng(data.latitude!, data.longitude!);
    setState(() {
      marker = Marker(
        markerId: MarkerId("home"),
        position: latLng,
        rotation: data.heading!,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData!)
      );
    });
  }


  StreamSubscription? x;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async{
      String mapValue = await DefaultAssetBundle.of(context).loadString('assets/map/style.json');
      ByteData byteData = await DefaultAssetBundle.of(context).load('assets/images/location.png');
      ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 60, targetHeight: 120);
      ui.FrameInfo fi = await codec.getNextFrame();

      Uint8List list =  (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();


      setState(() {
        imageData = list;
        mapStyle = mapValue;
      });

      await getCurrentLocation();


      x = tracker.onLocationChanged.listen((LocationData? data) async{
        if( data == null || lastLocation == null || data.latitude == null || data.longitude == null)
          return;


        if(geolocator.Geolocator.distanceBetween(lastLocation!.latitude!, lastLocation!.longitude!, data.latitude!, data.longitude!) < 10)
          return;



        /*if(data.heading!.abs() - lastLocation!.heading!.abs() < 30) {
          print('CHANGE IN HEADING LESS THAN 30 DEGREES');
          return;
        }*/




        if(Provider.of<HomeProvider>(context, listen: false).status) {
          print('DRIVER IS ACTIVE');
          Provider.of<HomeProvider>(context, listen: false).updateLocation(data);
        }
        else {
          print('DRIVER NOT ACTIVE, WILL NOT UPDATE POSITION');
        }
        lastLocation = data;
        await mapController.future.then((GoogleMapController controller) async {
          if(data.longitude == null || data.latitude == null)
            return;
          double zoomLevel = await controller.getZoomLevel();
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  bearing: 0,
                  target: LatLng(data.latitude!, data.longitude!),
                  tilt: 0,
                  zoom: zoomLevel
              )
          ));
          updateMarker(data);
        });
      });

    });










  }

  @override
  Widget build(BuildContext context) {

    if(mapStyle == null)
      return Container(
        child: Center(
          child: Text('MAP STYLE IS NULL', style: TextStyle(fontSize: 22),),
        ),
      );

    if(initialCameraPosition == null)
      return Container(
        child: Center(
          child: Text('INITIAL CAMERA POSITION IS NULL', style: TextStyle(fontSize: 22),),
        ),
      );

    if(marker == null)
      return Container(
        child: Center(
          child: Text('MARKER IS NULL', style: TextStyle(fontSize: 22),),
        ),
      );

    if(imageData == null)
      return Container(
        child: Center(
          child: Text('IMAGE DATA IS NULL', style: TextStyle(fontSize: 22),),
        ),
      );


    if( mapStyle == null || initialCameraPosition == null || marker == null || imageData == null)
      return Container();

    return GoogleMap(
      //onTap: (LatLng latLng) async => await Provider.of<HomeProvider>(context, listen: false).updateLocation(latLng),
      initialCameraPosition: initialCameraPosition!,
      onMapCreated: (GoogleMapController controller) async{
          controller.setMapStyle(mapStyle);
          mapController.complete(controller);
      },
      zoomControlsEnabled: false,
      markers: Set.of([marker!]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(x != null) {
      x!.cancel();
    }
  }
}
