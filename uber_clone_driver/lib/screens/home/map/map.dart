

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
    await tracker.changeSettings(accuracy: LocationAccuracy.navigation);
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


  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getIcon();
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

  BitmapDescriptor? locationIcon;

  Future<void> getIcon() async {

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async{
      String value = await DefaultAssetBundle.of(context).loadString('assets/map/style.json');
      ByteData byteData = await DefaultAssetBundle.of(context).load('assets/images/location.png');
      ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 60, targetHeight: 120);
      ui.FrameInfo fi = await codec.getNextFrame();

      Uint8List list = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
      setState(() {
        mapStyle = value;
        imageData = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if( mapStyle == null || initialCameraPosition == null || marker == null || imageData == null)
      return Container();

    return GoogleMap(
      initialCameraPosition: initialCameraPosition!,
      onMapCreated: (GoogleMapController controller) async{
          controller.setMapStyle(mapStyle);
          mapController.complete(controller);
      },
      zoomControlsEnabled: false,
      markers: Set.of([marker!]),
    );
  }
}
