import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../customer/cust_homepage.dart';

class UserLocation extends StatefulWidget {
  UserLocation({Key? key}) : super(key: key);

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  late GoogleMapController googleMapController;
  Marker? marker;
  Position? position;
  bool locationtapped = false;
  String? addressLoc;
  String? postalCode;
  String? country;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(position!.latitude, position!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          draggable: true,
          onDragEnd: (newPosition) {
            _saveLocation(newPosition);
          });
    });
  }

  void _saveLocation(LatLng newPositon) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: newPositon.latitude,
        longitude: newPositon.longitude,
        googleMapApiKey: "AIzaSyAeTdgjlC47FKjicCxlBU10CIogCR3HrBA");
    addressLoc = data.address;

    await FirebaseFirestore.instance
        .collection('custlocation')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'latitude': newPositon.latitude,
      'longitude': newPositon.longitude,
      'Address': data.address,
      'custemail': FirebaseAuth.instance.currentUser?.email
    });
    setState(() {
      addressLoc = data.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
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
                  builder: (context) => CustHomePage(),
                ),
              );
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 600,
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(position?.latitude ?? 2.2214,
                      position?.longitude ?? 102.4531),
                  zoom: 12,
                ),
                markers: Set.of((marker != null) ? [marker!] : []),
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                },
              ),
            ),
            Text('Address: $addressLoc'),
          ],
        ),
      ),
    );
  }
}
