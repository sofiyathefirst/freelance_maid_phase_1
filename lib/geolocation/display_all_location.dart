import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:google_fonts/google_fonts.dart';
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
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
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              //height: 500,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Drag the maps to view maid's location. You can tap on the purple location marker to view the maid's email.",
                    style: GoogleFonts.heebo(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 500,
                    child: GoogleMap(
                      mapType: MapType.hybrid,
                      markers: Set<Marker>.of(markers),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(2.1638028, 102.427727),
                        zoom: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
