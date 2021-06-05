import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:uber_clone_driver/models/directions.dart';

class DirectionsRepository {

  String _baseUrl = "https://maps.googleapis.com/maps/api/directions/json?";

  Dio dio = Dio();

  Future<Directions?> getDirections({required LatLng origin, required LatLng destination}) async {

    const API_KEY = "AIzaSyDth8SN5FaNka8ev2yVlIhVBWbXff8ASv0";


    final response = await dio.get(_baseUrl,
    queryParameters: {
      'origin'      : '${origin.latitude},${origin.longitude}',
      'destination' : '${destination.latitude},${destination.longitude}',
      'key'         : API_KEY
    });


    if(response.statusCode == 200) {
      print('map is oke');
      return Directions.fromMap(response.data);
    }

    return null;

  }



}