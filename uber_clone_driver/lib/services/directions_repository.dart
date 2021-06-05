
import 'dart:convert';

import 'package:uber_clone_driver/.env.dart' as env;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:uber_clone_driver/models/directions.dart';
import 'package:http/http.dart' as http;
class DirectionsRepository {

  String _baseUrl = "https://maps.googleapis.com/maps/api/directions/json?";

  Dio dio = Dio();

  Future<Directions?> getDirections({required LatLng origin, required LatLng destination}) async {

    const API_KEY = "AIzaSyDth8SN5FaNka8ev2yVlIhVBWbXff8ASv0";
    String url = _baseUrl + "origin=Boston,MA&destination=Concord,MA&key=$API_KEY";

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