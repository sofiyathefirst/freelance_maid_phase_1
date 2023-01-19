import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

class Maps2 extends StatefulWidget {
  Maps2({Key? key}) : super(key: key);

  @override
  State<Maps2> createState() => _Maps2State();
}

class _Maps2State extends State<Maps2> {
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  late LatLng _defaultLatLng;
  String draggedAddress = "";

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    _defaultLatLng = LatLng(2.225674, 102.454676);
    _cameraPosition = CameraPosition(target: _defaultLatLng, zoom: 14);
    _gotoUserCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _gotoUserCurrentPosition();
        },
        child: Icon(Icons.location_searching_rounded),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [_getMap(), _getCustomPin()],
    );
  }

  Widget _showDraggedAddress() {
    return Container(
      decoration: BoxDecoration(color: Colors.deepPurple),
      child: Text(
        "Address",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _getMap() {
    return GoogleMap(
      initialCameraPosition: _cameraPosition!,
      mapType: MapType.normal,
      onCameraIdle: () {
        //this function will trigger when user stop dragging on map
      },
      onCameraMove: (cameraPosition) {
        //this function will trigger when user keep dragging on map
      },
      onMapCreated: (GoogleMapController controller) {
        //this function will trigger when map is fully loaded
        if (_googleMapController.isCompleted) {
          //set controller to google map when it is fully loaded
          _googleMapController.complete(controller);
        }
      },
    );
  }

  Widget _getCustomPin() {
    return Center(
      child: Container(
        width: 150,
        child: Icon(Icons.location_on),
      ),
    );
  }

  //get user's current location and set the camera's map to that location
  Future _gotoUserCurrentPosition() async {
    Position currentPosition = await _determineUserCurrentPosition();
    _gotoSpecificLocation(
        LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  //go to specific position by latlng
  Future _gotoSpecificLocation(LatLng position) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14)));
  }

  Future _determineUserCurrentPosition() async {
    LocationPermission locationPermission;
    bool isLocationLocationServiceEnabled =
        await Geolocator.isLocationServiceEnabled();
    //check if user enable service for location permission
    if (!isLocationLocationServiceEnabled) {
      print("user don't enable location permission");
    }

    locationPermission = await Geolocator.checkPermission();
    //check if user denied location and retry requesting for permission
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        print("user denied location permission");
      }
    }

    //check if user denied permission forever
    if (locationPermission == LocationPermission.deniedForever) {
      print("user denied permission forever");
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
