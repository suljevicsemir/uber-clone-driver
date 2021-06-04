

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/providers/home_provider.dart';
import 'package:uber_clone_driver/screens/home/ride_request_bottom_sheet/ride_request_bottom_sheet.dart';

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
  bool isFirstRun = true;
  Set<Marker> markers = Set<Marker>();

  late StreamSubscription<QuerySnapshot> requests;

  Timestamp timestamp = Timestamp.now();

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        timestamp = Timestamp.now();
      });
    });


    requests = FirebaseFirestore.instance
      .collection('ride_requests')
      .where('endInterval', isGreaterThan: timestamp)
      .where('isActive', isEqualTo: true)
      .limit(100)
      .snapshots().listen((QuerySnapshot querySnapshot) {

        print(querySnapshot.docs.length);
        List<QueryDocumentSnapshot> list = querySnapshot.docs;


        Set<Marker> tempMarkers = Set<Marker>();

        if(marker != null)
        tempMarkers.add(marker!);

        for(int i = 0; i < list.length; i++) {
          DocumentSnapshot snapshot = list[i];
          GeoPoint geoPoint = snapshot.get("location") as GeoPoint;
          LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude);

          Marker riderMarker = Marker(
            markerId: MarkerId(snapshot.id),
            position: latLng,
            rotation: 0,
            draggable: false,
            zIndex: 2,
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              showModalBottomSheet(context: context, builder: (context) => RideRequestBottomSheet(riderId: snapshot.get("riderId"), rideRequestId: snapshot.id,));
            }
          );
          tempMarkers.add(riderMarker);
        }

        setState(() {

          markers = tempMarkers;
        });
    });
  }

  late StreamSubscription<LocationData> x;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if( isFirstRun) {

      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async{



        String mapValue = await DefaultAssetBundle.of(context).loadString('assets/map/style.json');
        ByteData byteData = await DefaultAssetBundle.of(context).load('assets/images/location.png');
        ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 60, targetHeight: 120);
        ui.FrameInfo fi = await codec.getNextFrame();
        Uint8List list =  (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

        setState(() {
          imageData = list;
          mapStyle = mapValue;
          isFirstRun = false;
        });


        await getCurrentLocation();
        x = tracker.onLocationChanged.listen((LocationData? data) async{

          if( data == null || lastLocation == null || data.latitude == null || data.longitude == null)
            return;

          if(geolocator.Geolocator.distanceBetween(lastLocation!.latitude!, lastLocation!.longitude!, data.latitude!, data.longitude!) < 10)
            return;

          if(Provider.of<HomeProvider>(context, listen: false).status) {
            print('Driver is active, updating the position...');
            Provider.of<HomeProvider>(context, listen: false).updateLocation(data);
          }
          else {
            print('Driver is not active, not updating the position...');
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
  }




  // sets initial camera position and initial marker position
  // sets lastLocation variable
  Future<void> getCurrentLocation() async{

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
    if(!this.mounted)
      return;

    markers.remove(marker);
    marker = Marker(
        markerId: MarkerId("driver"),
        position: latLng,
        rotation: data.heading!,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData!)
    );
    markers.add(marker!);
    setState(() {

    });
  }




  @override
  Widget build(BuildContext context) {

    if(mapStyle == null)
      return Container(
        child: Center(
          child: Text('Loading map style..l', style: TextStyle(fontSize: 22),),
        ),
      );

    if(initialCameraPosition == null)
      return Container(
        child: Center(
          child: Text('Trying to fetch your position...', style: TextStyle(fontSize: 22),),
        ),
      );

    if(marker == null)
      return Container(
        child: Center(
          child: Text('Loading marker...', style: TextStyle(fontSize: 22),),
        ),
      );

    if(imageData == null)
      return Container(
        child: Center(
          child: Text('Trying to fetch your position...', style: TextStyle(fontSize: 22),),
        ),
      );

  print('SET SIZE: ' + markers.length.toString());
    return GoogleMap(
      initialCameraPosition: initialCameraPosition!,
      onMapCreated: (GoogleMapController controller) async{
          controller.setMapStyle(mapStyle);
          mapController.complete(controller);
      },
      zoomControlsEnabled: false,
      markers: markers,
    );
  }

  @override
  void dispose() {
    super.dispose();
    x.cancel();
    requests.cancel();
  }
}
