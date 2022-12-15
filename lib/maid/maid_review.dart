import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking_status.dart';
import 'package:freelance_maid_phase_1/geolocation/geolocation.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_receipt.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Maidreview extends StatefulWidget {
  Maidreview({Key? key}) : super(key: key);

  @override
  State<Maidreview> createState() => _MaidreviewState();
}

class _MaidreviewState extends State<Maidreview> {
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
                builder: (context) => MaidHomePage(),
              ),
            );
          },
        ),
        title: const Text(
          "Review",
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
                  builder: (context) => MaidProfile(),
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
                  builder: (context) => MaidReceipt(),
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
                  builder: (context) => Maidreview(),
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
                final sd = snapshot.data!.docs;
                return Column(
                  children: List.generate(
                    sd.length,
                    (i) {
                      final review = sd[i];
                      if (currentUser == review.get('maidemail')) {
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              color: Colors.teal[300],
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                      'Review from ' +
                                          review.get('custfirstname'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text('Maid Name: ' +
                                      review.get('maidfirstname') +
                                      '\t' +
                                      review.get('maidlastname')),
                                  SizedBox(height: 5),
                                  Text('Cleaning type: ' +
                                      review.get('cleaningtype')),
                                  SizedBox(height: 5),
                                  Text('Review: ' + review.get('reviews')),
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
