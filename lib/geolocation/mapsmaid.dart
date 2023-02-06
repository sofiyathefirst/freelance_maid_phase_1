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

//dapatkan location maid
class _MaidMapsState extends State<MaidMaps> {
  late GoogleMapController googlemapcontroller;
  Marker? marker;
  Position? position;
  String? addressLoc;
  String? postalCode;
  String? country;

  bool locationtapped = false;

  void getMarkers() async {
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
        .collection('location')
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
  void initState() {
    super.initState();
    getMarkers();
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
          "Get Location",
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
                  googlemapcontroller = controller;
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
