import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:freelance_maid_phase_1/maid/booking_status.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_receipt.dart';
import 'package:freelance_maid_phase_1/maid/maid_review.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MaidHomePage extends StatefulWidget {
  MaidHomePage({Key? key}) : super(key: key);

  @override
  State<MaidHomePage> createState() => _MaidHomePageState();
}

class _MaidHomePageState extends State<MaidHomePage> {
  final bookingMaid = FirebaseFirestore.instance.collection('bookmaids');
  var currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<void> _delete(String bookingId) async {
    await bookingMaid.doc(bookingId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cancel Succesful'),
      ),
    );
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
            builder: (context) => MaidHomePage(),
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {},
        ),
        title: const Text(
          "Home Page",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashScreen2(),
                ),
              );
            },
          ),
          SizedBox(
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
              future: bookingMaid.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('There is error'),
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
                      final bookmaid = sd[i];

                      if (currentUser == bookmaid.get('maiduid')) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Text('Customer Booking List',
                                  style: GoogleFonts.heebo(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  textAlign: TextAlign.center),
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Customer Information',
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image(
                                            image: NetworkImage(
                                                bookmaid.get('custimage')),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Customer Name: \n' +
                                                  bookmaid
                                                      .get('custfirstname') +
                                                  '\t' +
                                                  bookmaid.get('cuslastname'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Customer Phone Number: \n' +
                                                  bookmaid.get('custpnum'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Customer Email: \n' +
                                                  bookmaid.get('custemail'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Customer Gender: \n' +
                                                  bookmaid.get('custgender'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Cleaning type: \n' +
                                                  bookmaid.get('cleaningtype'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Bedroom: ' +
                                                  bookmaid.get('bedroom'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Bathroom: ' +
                                                  bookmaid.get('bathroom'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Kitchen: ' +
                                                  bookmaid.get('kitchen'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Pantry: ' +
                                                  bookmaid.get('pantry'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Office: ' +
                                                  bookmaid.get('office'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Garden: ' +
                                                  bookmaid.get('garden'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Booking Date: ' +
                                                  bookmaid.get('bookdate'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Time Slot: \n' +
                                                  bookmaid.get('timeslot'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Total Payment: ' +
                                                  bookmaid
                                                      .get('totalpayment')
                                                      .toString(),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Status: \n' +
                                                  bookmaid.get('status'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                if ("Done" ==
                                                    bookmaid.get('status')) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MaidHomePage()),
                                                  );
                                                } else {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateBooking(
                                                              data: bookmaid),
                                                    ),
                                                  );
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.green.shade800),
                                              ),
                                              child: Text(
                                                'Update Status',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                        "Below is the location of customer's house",
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: GoogleMap(
                                    mapType: MapType.hybrid,
                                    markers: <Marker>{
                                      Marker(
                                          markerId: MarkerId(
                                              bookmaid.get('custemail')),
                                          position: LatLng(
                                            bookmaid.get('custlatitude'),
                                            bookmaid.get('custlongitude'),
                                          ),
                                          infoWindow: InfoWindow(
                                              title:
                                                  bookmaid.get('custaddress')),
                                          icon: BitmapDescriptor
                                              .defaultMarkerWithHue(
                                                  BitmapDescriptor.hueMagenta))
                                    }.toSet(),
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          bookmaid.get('custlatitude'),
                                          bookmaid.get('custlongitude')),
                                      zoom: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
