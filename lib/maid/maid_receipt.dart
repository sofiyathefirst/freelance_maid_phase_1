// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_review.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'maid_homepage.dart';

class MaidReceipt extends StatefulWidget {
  MaidReceipt({Key? key}) : super(key: key);

  @override
  State<MaidReceipt> createState() => _MaidReceiptState();
}

class _MaidReceiptState extends State<MaidReceipt> {
  final bookingStatus = FirebaseFirestore.instance.collection('bookmaids');
  var currentUser = FirebaseAuth.instance.currentUser?.email;

  Future<QuerySnapshot> getData() async {
    return await FirebaseFirestore.instance
        .collection('bookmaids')
        .where("maidemail", isEqualTo: currentUser)
        .get();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaidReceipt(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Maidreview(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaidProfile(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MaidHomePage(),
              ),
            );
          },
        ),
        title: const Text(
          "Booking Receipt",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen2(),
                ),
              );
            },
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Book",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews_rounded),
            label: "Review",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: bookingStatus.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delete Succesful'),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final sd = snapshot.data!.docs;
                return Column(
                  children: List.generate(
                    sd.length,
                    (i) {
                      final bookstatus = sd[i];
                      if (currentUser == bookstatus.get('maidemail')) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                                color: Colors.deepPurple[50],
                              ),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image(
                                      image: NetworkImage(
                                          bookstatus.get('custimage')),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text('Customer Information',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      const SizedBox(height: 5),
                                      Text('Customer Name: \n' +
                                          bookstatus.get('custfirstname') +
                                          '\t' +
                                          bookstatus.get('cuslastname')),
                                      const SizedBox(height: 5),
                                      Text('Customer Phone Number: \n' +
                                          bookstatus.get('custpnum')),
                                      const SizedBox(height: 5),
                                      Text('Customer Email: ' +
                                          bookstatus.get('custemail')),
                                      const SizedBox(height: 5),
                                      Text('Customer Gender: ' +
                                          bookstatus.get('custgender')),
                                      const SizedBox(height: 5),
                                      Text('Cleaning type: ' +
                                          bookstatus.get('cleaningtype')),
                                      const SizedBox(height: 5),
                                      Text('Bedroom: ' +
                                          bookstatus.get('bedroom')),
                                      const SizedBox(height: 5),
                                      Text('Bathroom: ' +
                                          bookstatus.get('bathroom')),
                                      const SizedBox(height: 5),
                                      Text('Kitchen: ' +
                                          bookstatus.get('kitchen')),
                                      const SizedBox(height: 5),
                                      Text('Pantry: ' +
                                          bookstatus.get('pantry')),
                                      const SizedBox(height: 5),
                                      Text('Office: ' +
                                          bookstatus.get('office')),
                                      const SizedBox(height: 5),
                                      Text('Garden: ' +
                                          bookstatus.get('garden')),
                                      const SizedBox(height: 5),
                                      Text('Booking Date: ' +
                                          bookstatus.get('bookdate')),
                                      const SizedBox(height: 5),
                                      Text('Time Slot: ' +
                                          bookstatus.get('timeslot')),
                                      const SizedBox(height: 5),
                                      Text('Total Payment: ' +
                                          bookstatus
                                              .get('totalpayment')
                                              .toString()),
                                      const SizedBox(height: 5),
                                      Text('Status: \n' +
                                          bookstatus.get('status')),
                                      const SizedBox(height: 15),

                                      /*SizedBox(
                                        height: 200,
                                        child: GoogleMap(
                                          mapType: MapType.normal,
                                          markers: <Marker>{
                                            Marker(
                                                markerId: MarkerId(bookstatus
                                                    .get('custemail')),
                                                position: LatLng(
                                                  bookstatus
                                                      .get('custlatitude'),
                                                  bookstatus
                                                      .get('custlongitude'),
                                                ),
                                                infoWindow: InfoWindow(
                                                    title: bookstatus
                                                        .get('custaddress')),
                                                icon: BitmapDescriptor
                                                    .defaultMarkerWithHue(
                                                        BitmapDescriptor
                                                            .hueGreen))
                                          }.toSet(),
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                bookstatus.get('custlatitude'),
                                                bookstatus
                                                    .get('custlongitude')),
                                            zoom: 15,
                                          ),
                                        ),
                                      )*/
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Colors.deepPurple[50],
                              ),
                              width: double.infinity,
                              child: SizedBox(
                                height: 150,
                                width: 150,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  markers: <Marker>{
                                    Marker(
                                        markerId: MarkerId(
                                            bookstatus.get('custemail')),
                                        position: LatLng(
                                          bookstatus.get('custlatitude'),
                                          bookstatus.get('custlongitude'),
                                        ),
                                        infoWindow: InfoWindow(
                                            title:
                                                bookstatus.get('custaddress')),
                                        icon: BitmapDescriptor
                                            .defaultMarkerWithHue(
                                                BitmapDescriptor.hueMagenta))
                                  }.toSet(),
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        bookstatus.get('custlatitude'),
                                        bookstatus.get('custlongitude')),
                                    zoom: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [],
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
