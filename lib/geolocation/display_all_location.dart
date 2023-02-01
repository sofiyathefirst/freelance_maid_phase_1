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
  // List<Map<String, dynamic>> _locations = [];
  late GoogleMapController myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(specify['latitude'], specify['longitude']),
        infoWindow: InfoWindow(title: 'Maid', snippet: specify['Address']));
    setState(() {
      markers[markerId] = marker;
    });
  }

  _getLocationsFromDatabase() async {
    FirebaseFirestore.instance
        .collection('maid')
        .doc()
        .collection('location')
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (int i = 0; i < value.docs.length; i++) {
            initMarker(value.docs[i].data(), value.docs[i].get('maidemail'));
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getLocationsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> _getLocations() {
      return <Marker>[
        Marker(
            markerId: MarkerId('Maid'),
            position: LatLng(2.1649, 102.4330),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'Home'))
      ].toSet();
    }

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
          markers: Set<Marker>.of(markers.values),
          mapType: MapType.hybrid,
          initialCameraPosition:
              CameraPosition(target: LatLng(2.1649, 102.4330), zoom: 18),
          onMapCreated: (GoogleMapController controller) {
            controller = controller;
          }),
    );
  }
}
