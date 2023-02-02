import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:location/location.dart';

class Maps extends StatefulWidget {
  Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

//dapatkan location customer
class _MapsState extends State<Maps> {
  GoogleMapController? googlemapcontroller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position? positions;
  String? addressLoc;
  String? postalCode;
  String? country;
  Location location = Location();
  bool locationtapped = false;

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
              if (locationtapped) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustHomePage(),
                  ),
                );
              }
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
                  onTap: (tapped) async {
                    if (!locationtapped) {
                      locationtapped = true;
                      /*GeoData data = await Geocoder2.getDataFromCoordinates(
                          latitude: tapped.latitude,
                          longitude: tapped.longitude,
                          googleMapApiKey:
                              "AIzaSyAeTdgjlC47FKjicCxlBU10CIogCR3HrBA");*/
                      //addressLoc = data.address;
                      getMarkers(tapped.latitude, tapped.longitude);
                      await FirebaseFirestore.instance
                          .collection('custlocation')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'latitude': tapped.latitude,
                        'longitude': tapped.longitude,
                        //'Address': data.address,
                        'custemail': FirebaseAuth.instance.currentUser?.email
                      });
                      setState(() {
                        //addressLoc = data.address;
                      });
                    }
                  },
                  mapType: MapType.hybrid,
                  compassEnabled: true,
                  trafficEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    googlemapcontroller = controller;
                  },
                  initialCameraPosition: CameraPosition(
                      target: positions != null
                          ? LatLng(positions!.latitude.toDouble(),
                              positions!.longitude.toDouble())
                          : LatLng(2.3113, 102.4309),
                      zoom: 14.476),
                  markers: Set<Marker>.of(markers.values)),
            ),
          ],
        ),
      ),
    );
  }
}
