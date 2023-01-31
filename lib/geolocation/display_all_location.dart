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
  List<Map<String, dynamic>> _locations = [];

  Future<void> _getLocationsFromDatabase() async {
    // retrieve all locations from FirebaseFirestore
    var locations = FirebaseFirestore.instance
        .collection('maid')
        .doc()
        .collection('location');
    setState(() {
      _locations = locations as List<Map<String, dynamic>>;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocationsFromDatabase();
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
          "Maids Location",
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
                markers: Set<Marker>.of(
                  [
                    for (var location in _locations)
                      Marker(
                        markerId: MarkerId('Maid'),
                        position:
                            LatLng(location["latitude"], location["longitude"]),
                        infoWindow: InfoWindow(
                          title: location["Address"],
                        ),
                      ),
                  ],
                ),
                initialCameraPosition: CameraPosition(
                    target: LatLng(2.225674, 102.454676), zoom: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
