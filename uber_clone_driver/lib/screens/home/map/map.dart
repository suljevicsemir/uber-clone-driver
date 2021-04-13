

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;


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



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tracker.onLocationChanged.listen((LocationData? data) async{
      if( data == null || lastLocation == null)
        return;

      if(geolocator.Geolocator.distanceBetween(lastLocation!.latitude!, lastLocation!.longitude!, data.latitude!, data.longitude!) < 5)
        return;
      //Provider.of<HomeProvider>(context, listen: false).updateLocation(LatLng(data.latitude!, data.longitude!));
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




    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async{
      String mapValue = await DefaultAssetBundle.of(context).loadString('assets/map/style.json');
      ByteData byteData = await DefaultAssetBundle.of(context).load('assets/images/location.png');
      ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 60, targetHeight: 120);
      ui.FrameInfo fi = await codec.getNextFrame();

      Uint8List list =  (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

      fi.image.toByteData(format: ui.ImageByteFormat.png).then((ByteData? byteData) {

        setState(() {
          imageData = byteData!.buffer.asUint8List();
        });
        getCurrentLocation();
      });

      setState(() {
        mapStyle = mapValue;

      });
    });

  }

  @override
  Widget build(BuildContext context) {

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
}
