import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_review.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';

import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Receipt extends StatefulWidget {
  Receipt({Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  final bookingMaid = FirebaseFirestore.instance.collection('bookmaids');
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  final review = FirebaseFirestore.instance.collection('reviews');

  Future<void> _delete(String bookingId) async {
    try {
      await bookingMaid.doc(bookingId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cancel Successful'),
        ),
      );
    } catch (e) {
      if (e is FlutterError && e.message.contains('unmounted')) {
        return;
      }
      rethrow;
    }
  }

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
          "Booking Receipt",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: 15,
          ),
        ],
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
              future: bookingMaid.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('There is an error'),
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
                                color: Colors.white,
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
                                      Text(
                                        'Maid Name: \n' +
                                            bookmaid.get('maidfirstname') +
                                            '\t' +
                                            bookmaid.get('maidlastname'),
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
                                        'Maid Phone Number: \n' +
                                            bookmaid.get('maidpnum'),
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
                                        'Maid Email: \n' +
                                            bookmaid.get('maidemail'),
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
                                        'Maid Gender: ' +
                                            bookmaid.get('maidgender'),
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
                                        'Bedroom: ' + bookmaid.get('bedroom'),
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
                                        'Bathroom: ' + bookmaid.get('bathroom'),
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
                                        'Kitchen: ' + bookmaid.get('kitchen'),
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
                                        'Pantry: ' + bookmaid.get('pantry'),
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
                                        'Office: ' + bookmaid.get('office'),
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
                                        'Garden: ' + bookmaid.get('garden'),
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
                                        'Status: \n' + bookmaid.get('status'),
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
                                        'Time Slot: ' +
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
                                      SizedBox(height: 10),
                                      Text(
                                        'Cancellation must be before \nmaid Accept the job!',
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.pink,
                                                backgroundColor: Colors.red),
                                            onPressed: () {
                                              if ("No Status" !=
                                                  bookmaid.get('status')) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Receipt()),
                                                );
                                              } else {
                                                _delete(bookmaid.id);
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Receipt()),
                                                );
                                              }
                                            },
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
                                              if ("Done" ==
                                                  bookmaid.get('status')) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Review(
                                                      data: bookmaid,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Receipt()),
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
