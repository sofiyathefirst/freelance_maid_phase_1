import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder2/geocoder2.dart';

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
  CameraPosition _cameraposition =
      CameraPosition(target: LatLng(2.1638, 102.1277), zoom: 12);

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

  Future<void> getCurrentLoc() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _cameraposition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 12);
      });
      print('get the position');
      print(position.latitude);
      print(position.longitude);
    } catch (e) {
      print(e);
    }
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
    getCurrentLoc();
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
                    GeoData data = await Geocoder2.getDataFromCoordinates(
                        latitude: tapped.latitude,
                        longitude: tapped.longitude,
                        googleMapApiKey:
                            "AIzaSyAeTdgjlC47FKjicCxlBU10CIogCR3HrBA");
                    addressLoc = data.address;
                    getMarkers(tapped.latitude, tapped.longitude);
                    await FirebaseFirestore.instance
                        .collection('custlocation')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({
                      'latitude': tapped.latitude,
                      'longitude': tapped.longitude,
                      'Address': data.address,
                      'custemail': FirebaseAuth.instance.currentUser?.email
                    });
                    setState(() {
                      addressLoc = data.address;
                    });
                  }
                },
                compassEnabled: true,
                trafficEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  googlemapcontroller = controller;
                },
                initialCameraPosition: _cameraposition,
                markers: Set<Marker>.of(markers.values),
              ),
            ),
            Text('Address: $addressLoc'),
          ],
        ),
      ),
    );
  }
}
