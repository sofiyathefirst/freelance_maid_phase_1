import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking_status.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_review.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';

import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Receipt extends StatefulWidget {
  Receipt({Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
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
          "Booking Receipt",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Geolocation(),
                ),
              );*/
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
              future: bookingMaid.get(),
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
                      final bookmaid = sd[i];

                      if (currentUser == bookmaid.get('custuid')) {
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.deepPurple[50],
                              ),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  SizedBox(width: 15),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image(
                                        image: NetworkImage(
                                            bookmaid.get('maidimage'))),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Text('Maid Name: ' +
                                          bookmaid.get('maidfirstname') +
                                          '\t' +
                                          bookmaid.get('maidlastname')),
                                      SizedBox(height: 5),
                                      Text('Maid Phone Number: ' +
                                          bookmaid.get('maidpnum')),
                                      SizedBox(height: 5),
                                      Text('Maid Email: ' +
                                          bookmaid.get('maidemail')),
                                      SizedBox(height: 5),
                                      Text('Maid Gender: ' +
                                          bookmaid.get('maidgender')),
                                      SizedBox(height: 5),
                                      Text('Cleaning type: ' +
                                          bookmaid.get('cleaningtype')),
                                      SizedBox(height: 5),
                                      Text('Bedroom: ' +
                                          bookmaid.get('bedroom')),
                                      SizedBox(height: 5),
                                      Text('Bathroom: ' +
                                          bookmaid.get('bathroom')),
                                      SizedBox(height: 5),
                                      Text('Kitchen: ' +
                                          bookmaid.get('kitchen')),
                                      SizedBox(height: 5),
                                      Text('Pantry: ' + bookmaid.get('pantry')),
                                      SizedBox(height: 5),
                                      Text('Office: ' + bookmaid.get('office')),
                                      SizedBox(height: 5),
                                      Text('Garden: ' + bookmaid.get('garden')),
                                      SizedBox(height: 5),
                                      Text('Booking Date: ' +
                                          bookmaid.get('bookdate')),
                                      SizedBox(height: 5),
                                      Text('Status: \n' +
                                          bookmaid.get('status')),
                                      SizedBox(height: 5),
                                      Text('Time Slot: ' +
                                          bookmaid.get('timeslot')),
                                      SizedBox(height: 5),
                                      Text('Total Payment: RM' +
                                          bookmaid
                                              .get('totalpayment')
                                              .toString()),
                                      SizedBox(height: 10),
                                      Text(
                                        'Cancellation must be 3 days \n before the booking date!',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _delete(bookmaid.id);
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Receipt()),
                                                (Route<dynamic> route) => false,
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.red.shade800),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Review(
                                                    data: bookmaid,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.green.shade800),
                                            ),
                                            child: Text(
                                              'Leave Review',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ],
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
            )
          ],
        ),
      ),
    );
  }
}
