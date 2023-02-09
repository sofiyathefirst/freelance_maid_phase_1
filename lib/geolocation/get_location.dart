import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {},
        ),
        title: const Text(
          "Pinned Location",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text('Drag and move the location marker to pinned your location',
                style: GoogleFonts.heebo(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 300,
              child: GoogleMap(
                zoomGesturesEnabled: true,
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
            Text('View Addres Here before Submit: $addressLoc',
                style: GoogleFonts.heebo(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                  shadowColor: Colors.cyanAccent),
              child: Text('Save My Location',
                  style: GoogleFonts.heebo(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustHomePage(),
                  ),
                );
                SnackBar snackbar = const SnackBar(
                  content: Text("Registered Successful!"),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              },
            ),
          ],
        ),
      ),
    );
  }
}
