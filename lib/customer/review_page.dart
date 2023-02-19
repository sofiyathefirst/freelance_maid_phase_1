import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cust_profilepage.dart';

class ReviewPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  const ReviewPage({Key? key, this.data}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final rreview = FirebaseFirestore.instance.collection('reviews');
  var currentUser = FirebaseAuth.instance.currentUser?.email;
  late String maidemail = widget.data!.get('maidemail');

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
          "Review Page",
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
                      if (review.get('maidemail') == maidemail) {
                        return Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                        'Review from ' +
                                            review.get('custfirstname'),
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    Text(
                                        'Maid Name: ' +
                                            review.get('maidfirstname') +
                                            '\t' +
                                            review.get('maidlastname'),
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
                                        'Cleaning type: ' +
                                            review.get('cleaningtype'),
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    Text('Review: \n' + review.get('reviews'),
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    RatingBar.builder(
                                        initialRating:
                                            review.get("rating").toDouble(),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        glow: true,
                                        itemSize: 30,
                                        onRatingUpdate: (rating) => {}),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              )
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
