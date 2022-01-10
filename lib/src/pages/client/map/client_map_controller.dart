import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clone/src/models/client.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';
import 'package:uber_clone/src/providers/client_provider.dart';
import 'package:uber_clone/src/providers/geofire_provider.dart';
import 'package:uber_clone/src/utils/custom_progress_dialog.dart';
import 'package:uber_clone/src/utils/custom_snackbar.dart';

class ClientMapController {
  late BuildContext context;
  late Function _refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  CameraPosition initialPosition = new CameraPosition(
    target: LatLng(-12.1513335, -77.0143298),
    zoom: 16.0,
  );
  Position? _position;
  late StreamSubscription<Position> _positionStream;
  late BitmapDescriptor _markerDriver;
  late GeofireProvider _geofireProvider;
  late AuthProvider _authProvider;
  bool isConnected = false;
  late ProgressDialog _progressDialog;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  late StreamSubscription<DocumentSnapshot<Object?>> _statusSubscription;
  late ClientProvider _clientProvider;
  Client? client;

  late StreamSubscription<DocumentSnapshot<Object?>> _clientSubscription;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this._refresh = refresh;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _progressDialog = CustomProgressDialog.createProgressDialog(context, 'Conectandose...');
    _markerDriver = await createMarkerImageFromAsset('assets/img/taxi_icon.png');
    _clientProvider = new ClientProvider();
    checkGPS();
    getClientInfo();
  }

  void dispose() {
    _positionStream.cancel();
    _statusSubscription.cancel();
    _clientSubscription.cancel();
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void getClientInfo() {
    Stream<DocumentSnapshot> stream = _clientProvider.getByIdStream(_authProvider.getUser()!.uid);
    _clientSubscription = stream.listen((DocumentSnapshot document) {
      client = clientFromJson(json.encode(document.data()));
      _refresh();
    });
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      _updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();

      if (locationGPS) {
        _updateLocation();
      }
    }
  }

  void _updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();
      getNearbyDrivers();
    } catch (error) {
      print('Error al obtener ubicación: $error');
    }
  }

  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyDrivers(_position!.latitude, _position!.longitude, 10);

    stream.listen((List<DocumentSnapshot> documentList) {
      for (MarkerId m in markers.keys) {
        bool remove = true;

        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }

        if (remove) {
          markers.remove(m);
          _refresh();
        }
      }

      for (DocumentSnapshot d in documentList) {
        Map<String, dynamic> position = d.get('position');
        GeoPoint point = position['geopoint'];

        _addMarker(
          d.id,
          point.latitude,
          point.longitude,
          'Conductor disponible',
          d.id,
          _markerDriver,
        );
      }

      _refresh();
    });
  }

  void centerPosition() {
    if (_position != null) {
      _animateCameraToPosition(_position!.latitude, _position!.longitude);
      _refresh();
    } else {
      CustomSnackBar.show(context, key, 'Activa el GPS para obtener tu ubicación');
    }
  }

  Future _animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    LatLng latLng = LatLng(latitude, longitude);
    CameraPosition cameraPosition = new CameraPosition(bearing: 0, target: latLng, zoom: 16);
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void _addMarker(
    String markerId,
    double lat,
    double lng,
    String title,
    String content,
    BitmapDescriptor iconMarker,
  ) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position!.heading);

    markers[id] = marker;
  }

  void signOut() async {
    await _authProvider.logOut();
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }
}
