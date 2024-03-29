import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';
import 'package:freelance_maid_phase_1/geolocation/display_all_location.dart';

import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Gardening extends StatefulWidget {
  Gardening({Key? key}) : super(key: key);

  @override
  State<Gardening> createState() => _GardeningState();
}

class _GardeningState extends State<Gardening> {
  final CollectionReference dataStream =
      FirebaseFirestore.instance.collection('maid');
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  String type = "Gardening";

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustHomePage(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Receipt(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustProfile(),
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
          "Gardening",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Book",
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
              future: dataStream.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  //TODO: add snackbar
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final storedocs = snapshot.data!.docs;
                return Column(
                  children: List.generate(
                    storedocs.length,
                    (i) {
                      final maid = storedocs[i];

                      if (type == maid.get('cleaningtype')) {
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image(
                                          image:
                                              NetworkImage(maid.get('image')),
                                        ),
                                      ),
                                      SizedBox(width: 25),
                                      Column(
                                        children: [
                                          SizedBox(height: 20),
                                          Text(
                                              'Name: \n' +
                                                  maid.get('maidfirstname') +
                                                  '\t' +
                                                  maid.get('maidlastname'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              textAlign: TextAlign.center),
                                          SizedBox(height: 10),
                                          Text(
                                              'Phone Number: \n' +
                                                  maid
                                                      .get('phonenum')
                                                      .toString(),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              textAlign: TextAlign.center),
                                          SizedBox(height: 10),
                                          Text(
                                              'Email: \n' +
                                                  maid.get('maidemail'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              textAlign: TextAlign.center),
                                          SizedBox(height: 10),
                                          Text(
                                              'Gender: \n' + maid.get('gender'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              textAlign: TextAlign.center),
                                          SizedBox(height: 10),
                                          Text(
                                              'Rate per 2 hour: \n' +
                                                  maid.get('rateperhour'),
                                              style: GoogleFonts.heebo(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              textAlign: TextAlign.center),
                                          SizedBox(height: 10),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.cyanAccent,
                                            backgroundColor: Colors.green),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Custbooking(data: maid),
                                            ),
                                          );
                                        },
                                        child: Text('Book Now',
                                            style: GoogleFonts.heebo(
                                              textStyle: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                      SizedBox(width: 40),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.pinkAccent,
                                            backgroundColor: Colors.black),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewPage(data: maid),
                                            ),
                                          );
                                        },
                                        child: Text('View Review',
                                            style: GoogleFonts.heebo(
                                              textStyle: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                    ],
                                  )
                                ],
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
