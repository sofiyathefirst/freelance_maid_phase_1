import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

class Maps extends StatefulWidget {
  Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late GoogleMapController googlemapcontroller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position? positions;
  String? addressLoc;
  String? postalCode;
  String? country;
  Location location = Location();

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(snippet: addressLoc));
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    Position currentPosition =
        await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      positions = currentPosition;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 600,
              child: GoogleMap(
                  onTap: (tapped) async {
                    GeoData data = await Geocoder2.getDataFromCoordinates(
                        latitude: tapped.latitude,
                        longitude: tapped.longitude,
                        googleMapApiKey:
                            "AIzaSyAeTdgjlC47FKjicCxlBU10CIogCR3HrBA");
                    addressLoc = data.address;
                    getMarkers(tapped.latitude, tapped.longitude);
                    await FirebaseFirestore.instance
                        .collection('customer')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('location')
                        .add({
                      'latitude': tapped.latitude,
                      'longitude': tapped.longitude,
                      'Address': data.address,
                    });
                    setState(() {
                      addressLoc = data.address;
                    });
                  },
                  mapType: MapType.hybrid,
                  compassEnabled: true,
                  trafficEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    googlemapcontroller = controller;
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(positions!.latitude.toDouble(),
                          positions!.longitude.toDouble()),
                      zoom: 14.476),
                  markers: Set<Marker>.of(markers.values)),
            ),
            Text('Address: $addressLoc'),
          ],
        ),
      ),
    );
  }
}
