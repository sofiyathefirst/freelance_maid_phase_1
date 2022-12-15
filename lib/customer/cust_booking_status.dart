import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_review.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';
import 'package:freelance_maid_phase_1/geolocation/geolocation.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustBookingStatus extends StatefulWidget {
  CustBookingStatus({Key? key}) : super(key: key);

  @override
  State<CustBookingStatus> createState() => _CustBookingStatusState();
}

class _CustBookingStatusState extends State<CustBookingStatus> {
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
                builder: (context) => CustHomePage(),
              ),
            );
          },
        ),
        title: const Text(
          "Booking Status",
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
                      if (currentUser == bookstatus.get('custemail')) {
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              color: Colors.teal[300],
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('Maid Information',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text('Maid Name: ' +
                                      bookstatus.get('maidfirstname') +
                                      '\t' +
                                      bookstatus.get('maidlastname')),
                                  SizedBox(height: 5),
                                  Text('Maid Phone Number: ' +
                                      bookstatus.get('maidpnum')),
                                  SizedBox(height: 5),
                                  Text('Maid Email: ' +
                                      bookstatus.get('maidemail')),
                                  SizedBox(height: 5),
                                  Text('Maid Gender: ' +
                                      bookstatus.get('maidgender')),
                                  SizedBox(height: 5),
                                  Text('Maid State: ' +
                                      bookstatus.get('maidstate')),
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
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Review(data: bookstatus),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green.shade700),
                                    ),
                                    child: const Text(
                                      'Leave Review',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
