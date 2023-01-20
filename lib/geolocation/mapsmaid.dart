import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MaidMaps extends StatefulWidget {
  MaidMaps({Key? key}) : super(key: key);

  @override
  State<MaidMaps> createState() => _MaidMapsState();
}

class _MaidMapsState extends State<MaidMaps> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  String? addressLoc;
  String? postalCode;
  String? country;
  static const CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(2.225674, 102.454676), zoom: 14);

  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(2.225674, 102.454676),
        infoWindow: InfoWindow(title: 'Fixed Location'))
  ];

  loadData() {
    getUserCurrentLocation().then((value) async {
      print('my current location');
      print(value.latitude.toString() + " " + value.longitude.toString());

      _markers.add(
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow:
              InfoWindow(title: 'My Current Location', snippet: addressLoc),
        ),
      );

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 14);

      final GoogleMapController controller = await _googleMapController.future;
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: value.latitude,
          longitude: value.longitude,
          googleMapApiKey: "AIzaSyAeTdgjlC47FKjicCxlBU10CIogCR3HrBA");
      addressLoc = data.address;
      await FirebaseFirestore.instance
          .collection('maid')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('location')
          .add({
        'latitude': value.latitude,
        'longitude': value.longitude,
        'Address': data.address,
      });

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      Text('Address: $addressLoc');
      setState(() {});
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        title: const Text(
          "Pinned Location",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MaidHomePage(),
                ),
              );
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _googleMapController.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
