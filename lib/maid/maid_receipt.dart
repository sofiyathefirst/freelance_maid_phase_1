import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking_status.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_review.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'maid_homepage.dart';

class MaidReceipt extends StatefulWidget {
  MaidReceipt({Key? key}) : super(key: key);

  @override
  State<MaidReceipt> createState() => _MaidReceiptState();
}

class _MaidReceiptState extends State<MaidReceipt> {
  final bookingStatus = FirebaseFirestore.instance.collection('bookingstatus');
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
          "Home Page",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_rounded),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MaidProfile(),
              ),
            ),
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
            icon: Icons.home_rounded,
            text: "Home",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MaidHomePage(),
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
                            SizedBox(height: 20),
                            Container(
                              color: Colors.teal[300],
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('Customer Information',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text('Customer Name: ' +
                                      bookstatus.get('custfirstname') +
                                      '\t' +
                                      bookstatus.get('cuslastname')),
                                  SizedBox(height: 5),
                                  Text('Customer Phone Number: ' +
                                      bookstatus.get('custpnum')),
                                  SizedBox(height: 5),
                                  Text('Customer Email: ' +
                                      bookstatus.get('custemail')),
                                  SizedBox(height: 5),
                                  Text('Customer Gender: ' +
                                      bookstatus.get('custgender')),
                                  SizedBox(height: 5),
                                  Text('Customer Address: ' +
                                      bookstatus.get('custaddress') +
                                      '\n' +
                                      bookstatus.get('custcity') +
                                      '\t' +
                                      bookstatus.get('custpostcode') +
                                      '\t' +
                                      bookstatus.get('custstate')),
                                  SizedBox(height: 5),
                                  Text('Cleaning type: ' +
                                      bookstatus.get('cleaningtype')),
                                  SizedBox(height: 5),
                                  Text(
                                      'Bedroom: ' + bookstatus.get('bedrooms')),
                                  SizedBox(height: 5),
                                  Text('Bathroom: ' +
                                      bookstatus.get('bathrooms')),
                                  SizedBox(height: 5),
                                  Text('Kitchen: ' + bookstatus.get('kitchen')),
                                  SizedBox(height: 5),
                                  Text('Pantry: ' + bookstatus.get('pantry')),
                                  SizedBox(height: 5),
                                  Text('Office: ' + bookstatus.get('office')),
                                  SizedBox(height: 5),
                                  Text('Garden: ' + bookstatus.get('garden')),
                                  SizedBox(height: 5),
                                  Text('Rate Per Hour: ' +
                                      bookstatus.get('rateperhour')),
                                  SizedBox(height: 5),
                                  Text('Booking Date: ' +
                                      bookstatus.get('bookingdate')),
                                  SizedBox(height: 5),
                                  Text('Time Start: ' +
                                      bookstatus.get('timestart')),
                                  SizedBox(height: 5),
                                  Text(
                                      'Time End: ' + bookstatus.get('timeend')),
                                  SizedBox(height: 5),
                                  Text('Total Hour: ' + bookstatus.get('hour')),
                                  SizedBox(height: 5),
                                  Text('Total Payment: RM' +
                                      bookstatus
                                          .get('totalpayment')
                                          .toString()),
                                  SizedBox(height: 20),
                                  SizedBox(height: 5),
                                  Text('Status: ' + bookstatus.get('status')),
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
