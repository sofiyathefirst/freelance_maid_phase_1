import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/geolocation/maidgeolocation.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_review.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
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
            icon: Icon(Icons.location_on),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MaidGeolocation(),
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
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.deepPurple[50],
                              ),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  SizedBox(
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
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
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
                                      Text('Cleaning type: ' +
                                          bookstatus.get('cleaningtype')),
                                      SizedBox(height: 5),
                                      Text('Bedroom: ' +
                                          bookstatus.get('bedroom')),
                                      SizedBox(height: 5),
                                      Text('Bathroom: ' +
                                          bookstatus.get('bathroom')),
                                      SizedBox(height: 5),
                                      Text('Kitchen: ' +
                                          bookstatus.get('kitchen')),
                                      SizedBox(height: 5),
                                      Text('Pantry: ' +
                                          bookstatus.get('pantry')),
                                      SizedBox(height: 5),
                                      Text('Office: ' +
                                          bookstatus.get('office')),
                                      SizedBox(height: 5),
                                      Text('Garden: ' +
                                          bookstatus.get('garden')),
                                      SizedBox(height: 5),
                                      Text('Booking Date: ' +
                                          bookstatus.get('bookdate')),
                                      SizedBox(height: 5),
                                      Text('Time Slot: ' +
                                          bookstatus.get('timeslot')),
                                      SizedBox(height: 5),
                                      Text('Total Payment: RM' +
                                          bookstatus
                                              .get('totalpayment')
                                              .toString()),
                                      SizedBox(height: 5),
                                      Text('Status: \n' +
                                          bookstatus.get('status')),
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
            ),
          ],
        ),
      ),
    );
  }
}
