import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking_status.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';
import 'package:freelance_maid_phase_1/geolocation/geolocation.dart';
import 'package:freelance_maid_phase_1/maid/maid_review.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Review extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  Review({Key? key, this.data}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();

  static fromJson(Map<String, dynamic> data) {}
}

class _ReviewState extends State<Review> {
  var currentUser = FirebaseAuth.instance.currentUser?.email;

  late String custfname = widget.data!.get('custfirstname');
  late String custlname = widget.data!.get('cuslastname');
  late String maidfname = widget.data!.get('maidfirstname');
  late String maidlname = widget.data!.get('maidlastname');
  late String custemail = widget.data!.get('custemail');
  late String maidemail = widget.data!.get('maidemail');
  late String cleaningtype = widget.data!.get('cleaningtype');
  late String date = widget.data!.get('bookingdate');
  late String timestart = widget.data!.get('timestart');
  late String timeend = widget.data!.get('timeend');
  late String reviews = '';
  late int totalpayment = widget.data?.get('totalpayment');

  final TextEditingController reviewcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference reviewref =
        FirebaseFirestore.instance.collection('review');
    Add(
        String maidfname,
        String maidlname,
        String maidemail,
        String cleaningtype,
        String custfname,
        String custlname,
        String custemail,
        String date,
        String timestart,
        String timeend,
        int totalpayment,
        String reviews) {
      try {
        return reviewref.add({
          'maidfirstname': maidfname,
          'maidlastname': maidlname,
          'maidemail': maidemail,
          'cleaningtype': cleaningtype,
          'custfirstname': custfname,
          'cuslastname': custlname,
          'custemail': custemail,
          'bookingdate': date,
          'timestart': timestart,
          'timeend': timeend,
          'totalpayment': totalpayment,
          'reviews': reviews,
        }).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Review posted!'),
            ),
          ),
        );
      } on FirebaseException catch (e) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.code),
        ));
      }
    }

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
        child: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Text(
                'Maid Name: $maidfname\t$maidlname',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 15),
              Text(
                'Maid Email: $maidemail',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 15),
              Text(
                'Customer Name: $custfname\t$custlname',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 15),
              Text(
                'Customer Email: $custemail',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 15),
              Text(
                'Booking Date: $date',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: reviewcontroller,
                decoration: InputDecoration(
                  hintText: 'Leave your review',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () {
                    Add(
                        maidfname,
                        maidlname,
                        maidemail,
                        cleaningtype,
                        custfname,
                        custlname,
                        custemail,
                        date,
                        timestart,
                        timeend,
                        totalpayment,
                        reviewcontroller.text);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Maidreview(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orangeAccent),
                  ),
                  child: const Text(
                    'Save Review',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
