import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

class LocationProvider extends ChangeNotifier{

  Location _location = Location();
  LocationData? _lastLocation;
  bool _driverStatus = false, _isFirstRun = true;
  Completer<GoogleMapController> mapController = Completer();

  bool _isDataReady = false;

  late StreamSubscription x;


  Marker? driverMarker;
  Uint8List? markerImage;
  String? mapStyle;




  LocationProvider(BuildContext context) {
    _loadMapData(context);
  }

  void _startLocationListener() {
    x = _location.onLocationChanged.listen((LocationData locationData) async{
      if( _lastLocation == null) {
        _lastLocation = locationData;
        notifyListeners();
      }
      if( !_isFirstRun && geolocator.Geolocator.distanceBetween(locationData.latitude!, locationData.longitude!, _lastLocation!.latitude!, _lastLocation!.longitude!) < 1) {
        return;
      }

      // driver is active, update driver's location
      if( _driverStatus) {

      }
      driverMarker = Marker(
          markerId: MarkerId("driver"),
          position: LatLng(locationData.latitude!, locationData.longitude!),
          rotation: locationData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerImage!)
      );

      if( _isFirstRun ) {
        _isDataReady = true;
        _isFirstRun = false;
      }


      _lastLocation = locationData;
      mapController.future.then((GoogleMapController controller) async {
        double zoomLevel = await controller.getZoomLevel();
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(locationData.latitude!, locationData.longitude!),
                bearing: 0,
                tilt: 0,
                zoom: zoomLevel
            )
        ));
      });
      notifyListeners();
    });
  }

  Future<void> _loadMarkerImage(BuildContext context) async {
    ByteData byteData = await DefaultAssetBundle.of(context).load('assets/images/location.png');
    ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 60, targetHeight: 120);
    ui.FrameInfo fi = await codec.getNextFrame();
    markerImage =  (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> _loadMapStyle(BuildContext context) async {
    mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map/style.json');
  }

  Future<void> _loadMapData(BuildContext context) async{
    await Future.wait([
      _loadMarkerImage(context),
      _loadMapStyle(context)
    ]);
    _startLocationListener();
    notifyListeners();
  }

  void changeDriverStatus() {
    _driverStatus = !_driverStatus;
    notifyListeners();
  }

  bool get driverStatus => _driverStatus;

  LatLng? get lastLocation {

    return _lastLocation == null ? null : LatLng(_lastLocation!.latitude!, _lastLocation!.longitude!);

  }


  bool get isDataReady => _isDataReady;

  @override
  void dispose() {
    super.dispose();
    mapController.future.then((value) => value.dispose());
    x.cancel();
  }

}