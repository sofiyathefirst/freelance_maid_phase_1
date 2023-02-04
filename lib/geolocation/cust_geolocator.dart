import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class CustGeolocator extends StatefulWidget {
  CustGeolocator({Key? key}) : super(key: key);

  @override
  State<CustGeolocator> createState() => _CustGeolocatorState();
}

class _CustGeolocatorState extends State<CustGeolocator> {
  late GoogleMapController mapController;
  TextEditingController _searchController = TextEditingController();
  List<Marker> allMarkers = [];
  bool locationtapped = false;
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];
  late LatLng _selectedlocation;
  late String description;
  List<Location>? locations;

  @override
  void initState() {
    super.initState();

    void getSuggestion(String input) async {
      String kPLACES_API_KEY = "AIzaSyAeTdgjlC47FKjicCxlBU10CIogCR3HrBA";
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

      var response = await http.get(Uri.parse(request));
      var data = response.body.toString();

      print(data);
      if (response.statusCode == 200) {
        setState(() {
          _placesList = jsonDecode(response.body.toString())['predictions'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    }

    void onChange() {
      if (_sessionToken == null) {
        setState(() {
          _sessionToken = uuid.v4();
        });
      }

      getSuggestion(_searchController.text);
    }

    _searchController.addListener(() {
      onChange();
    });
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(hintText: "Search Your Address"),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _placesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    locations = await locationFromAddress(
                        _placesList[index]['description']);

                    setState(() {
                      description = _placesList[index]['description'];
                    });

                    print(locations!.last.longitude);
                    print(locations!.last.latitude);
                  },
                  title: Text(_placesList[index]['description']),
                );
              },
            )),
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(locations!.last.latitude, locations!.last.longitude),
                zoom: 15,
              ),
              markers: Set.of([
                Marker(
                    markerId: MarkerId("location"),
                    position: LatLng(
                        locations!.last.latitude, locations!.last.longitude),
                    infoWindow: InfoWindow(title: description))
              ]),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                    target: LatLng(
                        locations!.last.latitude, locations!.last.longitude),
                    zoom: 15,
                  )));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
