import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DisplayAllLocation extends StatefulWidget {
  DisplayAllLocation({Key? key}) : super(key: key);

  @override
  State<DisplayAllLocation> createState() => _DisplayAllLocationState();
}

class _DisplayAllLocationState extends State<DisplayAllLocation> {
  //untuk display semua location maid dekat maps
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    getDataFromFirestore();
  }

  getDataFromFirestore() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snap = await firestore.collection('location').get();
    snap.docs.forEach((element) {
      markers.add(
        Marker(
            markerId: MarkerId(element.id),
            position: LatLng(
              element['latitude'],
              element['longitude'],
            ),
            infoWindow: InfoWindow(title: element['email']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet)),
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustHomePage(),
              ),
            );
          },
        ),
        title: const Text(
          "Maids Location",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: GoogleMap(
        markers: Set<Marker>.of(markers),
        initialCameraPosition: CameraPosition(
          target: LatLng(2.1638028, 102.427727),
          zoom: 17,
        ),
      ),
    );
  }
}
