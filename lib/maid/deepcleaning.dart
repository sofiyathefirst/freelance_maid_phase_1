import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_review.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DeepCleaning extends StatefulWidget {
  DeepCleaning({Key? key}) : super(key: key);

  @override
  State<DeepCleaning> createState() => _DeepCleaningState();
}

class _DeepCleaningState extends State<DeepCleaning> {
  final CollectionReference dataStream =
      FirebaseFirestore.instance.collection('maid');
  String type = "Deep Cleaning";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          "Deep Cleaning",
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
                                color: Colors.blue.shade100,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image(
                                      image: NetworkImage(maid.get('image')),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Text('Name: ' +
                                          maid.get('maidfirstname') +
                                          '\t' +
                                          maid.get('maidlastname')),
                                      SizedBox(height: 20),
                                      Text('Phone Number: ' +
                                          maid.get('phonenum').toString()),
                                      SizedBox(height: 20),
                                      Text('Email: ' + maid.get('maidemail')),
                                      SizedBox(height: 20),
                                      Text('Gender: ' + maid.get('gender')),
                                      SizedBox(height: 20),
                                      Text('State: ' + maid.get('state')),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Custbooking(data: maid),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.green.shade700),
                                            ),
                                            child: const Text(
                                              'Book Now',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Review(),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                            ),
                                            child: const Text(
                                              'Review',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Center(
                              child: Text(
                                "No Maid Available",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ],
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
