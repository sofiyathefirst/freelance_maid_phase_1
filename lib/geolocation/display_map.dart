import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DisplayMaps extends StatefulWidget {
  DisplayMaps({Key? key}) : super(key: key);

  @override
  State<DisplayMaps> createState() => _DisplayMapsState();
}

class _DisplayMapsState extends State<DisplayMaps> {
  GoogleMapController? myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        infoWindow: InfoWindow(title: 'Customer', snippet: specify['address']));
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    await FirebaseFirestore.instance
        .collection('customer')
        .doc()
        .collection('location')
        .get()
        .then((userData) {
      if (userData.docs.isNotEmpty) {
        for (int i = 0; i < userData.docs.length; i++) {
          initMarker(userData.docs[i].data, userData.docs[i].id);
        }
      }
    });
  }

  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarker() {
      return <Marker>[
        Marker(
            markerId: MarkerId('Me'),
            position: LatLng(2.225674, 102.454676),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'My Home')),
      ].toSet();
    }

    return Scaffold(
      body: GoogleMap(
        markers: Set<Marker>.of(markers.values),
        mapType: MapType.hybrid,
        initialCameraPosition:
            CameraPosition(target: LatLng(2.225674, 102.454676), zoom: 14.476),
        onMapCreated: (GoogleMapController controller) {
          myController = controller;
        },
      ),
    );
  }
}
