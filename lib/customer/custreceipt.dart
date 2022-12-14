import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/update_booking.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Receipt extends StatefulWidget {
  Receipt({Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  final bookingMaid = FirebaseFirestore.instance.collection('bookingmaid');
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
          "Booking Receipt",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CustProfile(),
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
        gap: 8,
        tabs: [
          GButton(icon: Icons.home_rounded, text: "Home"),
          GButton(icon: Icons.receipt_rounded, text: "Receipt"),
          GButton(icon: Icons.book_online_rounded, text: "Booking"),
          GButton(icon: Icons.reviews_rounded, text: "Review"),
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

                      if (currentUser == bookmaid.get('uid')) {
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
                                  Text('Maid State: ' +
                                      bookmaid.get('maidstate')),
                                  SizedBox(height: 5),
                                  Text('Cleaning type: ' +
                                      bookmaid.get('cleaningtype')),
                                  SizedBox(height: 5),
                                  Text('Bedroom: ' + bookmaid.get('bedrooms')),
                                  SizedBox(height: 5),
                                  Text(
                                      'Bathroom: ' + bookmaid.get('bathrooms')),
                                  SizedBox(height: 5),
                                  Text('Kitchen: ' + bookmaid.get('kitchen')),
                                  SizedBox(height: 5),
                                  Text('Pantry: ' + bookmaid.get('pantry')),
                                  SizedBox(height: 5),
                                  Text('Office: ' + bookmaid.get('office')),
                                  SizedBox(height: 5),
                                  Text('Garden: ' + bookmaid.get('garden')),
                                  SizedBox(height: 5),
                                  Text('Rate Per Hour: ' +
                                      bookmaid.get('rateperhour')),
                                  SizedBox(height: 5),
                                  Text('Booking Date: ' +
                                      bookmaid.get('bookingdate')),
                                  SizedBox(height: 5),
                                  Text('Time Start: ' +
                                      bookmaid.get('timestart')),
                                  SizedBox(height: 5),
                                  Text('Time End: ' + bookmaid.get('timeend')),
                                  SizedBox(height: 5),
                                  Text('Total Hour: ' + bookmaid.get('hour')),
                                  SizedBox(height: 5),
                                  Text('Total Payment: RM' +
                                      bookmaid.get('totalpayment').toString()),
                                  SizedBox(height: 10),
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
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red.shade800),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateBooking(),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green.shade800),
                                        ),
                                        child: Text(
                                          'View Update',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
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
            )
          ],
        ),
      ),
    );
  }
}
