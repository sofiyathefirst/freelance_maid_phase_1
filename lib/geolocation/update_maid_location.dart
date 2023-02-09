import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class UpdateMaidLocation extends StatefulWidget {
  UpdateMaidLocation({Key? key}) : super(key: key);

  @override
  State<UpdateMaidLocation> createState() => _UpdateMaidLocationState();
}

//dapatkan location maid
class _UpdateMaidLocationState extends State<UpdateMaidLocation> {
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
        .update({
      'latitude': newPositon.latitude,
      'longitude': newPositon.longitude,
      'Address': data.address,
      'email': FirebaseAuth.instance.currentUser?.email
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {},
        ),
        title: const Text(
          "Update Location",
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
                  googlemapcontroller = controller;
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
                    builder: (context) => MaidProfile(),
                  ),
                );
                SnackBar snackbar = const SnackBar(
                  content: Text("Location Updated!"),
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
