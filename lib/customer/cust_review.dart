import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';

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
  late String date = widget.data!.get('bookdate');
  late String timeslot = widget.data!.get('timeslot');
  late String reviews = '';
  late String totalpayment = widget.data?.get('totalpayment');

  final TextEditingController reviewcontroller = TextEditingController();
  late double _rating;

  Future addReview() async {
    FirebaseFirestore.instance.collection('reviews').doc().set({
      'maidfirstname': maidfname,
      'maidlastname': maidlname,
      'maidemail': maidemail,
      'cleaningtype': cleaningtype,
      'custfirstname': custfname,
      'cuslastname': custlname,
      'custemail': custemail,
      'bookdate': date,
      'timeslot': timeslot,
      'totalpayment': totalpayment,
      'reviews': reviewcontroller.text.trim(),
      'rating': _rating
    }).then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustHomePage(),
          ),
        ));
    SnackBar snackbar = const SnackBar(content: Text("Review Posted"));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  void initState() {
    super.initState();
  }

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
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {},
              ),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) => setState(() {
                  _rating = rating;
                }),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: addReview,
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
