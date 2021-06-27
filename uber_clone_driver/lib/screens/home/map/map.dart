import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_driver/models/ride_request.dart';
import 'package:uber_clone_driver/providers/location_provider.dart';
import 'package:uber_clone_driver/screens/home/ride_request_bottom_sheet/ride_request_bottom_sheet.dart';

class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap>{

  bool isFirstRun = true;
  Set<Marker> markers = Set<Marker>();

  late StreamSubscription<QuerySnapshot> requests;

  Timestamp timestamp = Timestamp.now();

  @override
  void initState() {
    super.initState();
    requests = FirebaseFirestore.instance
      .collection('ride_requests')
      .where('endInterval', isGreaterThan: timestamp)
      .where('isActive', isEqualTo: true)
      .limit(100)
      .snapshots().listen((QuerySnapshot querySnapshot) {
        print(querySnapshot.docs.length);
        List<QueryDocumentSnapshot> list = querySnapshot.docs;

        markers.clear();

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
            onTap: () async{
              RideRequest rideRequest = RideRequest.fromSnapshot(snapshot);
              showModalBottomSheet(context: context, builder: (context) => RideRequestBottomSheet(rideRequest: rideRequest));
            }
          );
          markers.add(riderMarker);
        }
        setState(() {
        });
    });
  }

  @override
  Widget build(BuildContext context) {




    markers.add(Provider.of<LocationProvider>(context, listen: false).driverMarker!);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: Provider.of<LocationProvider>(context, listen: false).lastLocation!,
        zoom: 15
      ),
      onMapCreated: (GoogleMapController controller) async {
          await controller.setMapStyle(Provider.of<LocationProvider>(context, listen: false).mapStyle);
          Provider.of<LocationProvider>(context, listen: false).mapController.complete(controller);
      },
      zoomControlsEnabled: false,
      markers: markers
    );
  }

  @override
  void dispose() {
    super.dispose();
    requests.cancel();
  }
}
