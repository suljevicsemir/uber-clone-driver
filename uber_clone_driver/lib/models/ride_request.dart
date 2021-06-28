

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_driver/constants/ride_request.dart' as fields;
@immutable
class RideRequest {

  final String riderId, token, id;
  final Timestamp timestamp, startInterval, endInterval;
  final GeoPoint location, destination;


  RideRequest({
    required this.timestamp,
    required this.destination,
    required this.location,
    required this.riderId,
    required this.token,
    required this.startInterval,
    required this.endInterval,
    required this.id
  });

  RideRequest.fromSnapshot(DocumentSnapshot snapshot):
      timestamp     = snapshot.get(fields.timestamp),
      destination   = snapshot.get(fields.destination),
      location      = snapshot.get(fields.location),
      riderId       = snapshot.get(fields.riderId),
      token         = snapshot.get(fields.token),
      startInterval = snapshot.get(fields.startInterval),
      id            = snapshot.id,
      endInterval   = snapshot.get(fields.endInterval);

  Map<String, dynamic> toMap() {
    return {
      fields.timestamp     : timestamp,
      fields.destination   : destination,
      fields.location      : location,
      fields.riderId       : riderId,
      fields.token         : token,
      fields.startInterval : startInterval,
      'id'                 : id,
      fields.endInterval   : endInterval
    };
  }

}