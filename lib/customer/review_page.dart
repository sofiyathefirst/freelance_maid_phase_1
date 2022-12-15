import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking_status.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_review.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../geolocation/geolocation.dart';
import 'cust_profilepage.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final rreview = FirebaseFirestore.instance.collection('review');
  var currentUser = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
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
          "Review Page",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Geolocation(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded),
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
      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        tabBackgroundColor: Colors.grey.shade400,
        gap: 2,
        tabs: [
          GButton(
            icon: Icons.person_rounded,
            text: "Profile",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CustProfile(),
                ),
              );
            },
          ),
          GButton(
            icon: Icons.receipt_rounded,
            text: "Receipt",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Receipt(),
                ),
              );
            },
          ),
          GButton(
            icon: Icons.book_online_rounded,
            text: "Booking",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CustBookingStatus(),
                ),
              );
            },
          ),
          GButton(
            icon: Icons.reviews_rounded,
            text: "Review",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: rreview.get(),
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
                final snapd = snapshot.data!.docs;
                return Column(
                  children: List.generate(
                    snapd.length,
                    (i) {
                      final review = snapd[i];
                      if (review.get('reviews') != null) {
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              color: Colors.teal[300],
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                      'Review from ' +
                                          review.get('custfirstname'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 10),
                                  Text('Maid Name: ' +
                                      review.get('maidfirstname') +
                                      '\t' +
                                      review.get('maidlastname')),
                                  SizedBox(height: 10),
                                  Text('Cleaning type: ' +
                                      review.get('cleaningtype')),
                                  SizedBox(height: 10),
                                  Text('Review: ' + review.get('reviews')),
                                  SizedBox(height: 10),
                                ],
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            )
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
