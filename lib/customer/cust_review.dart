import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Review extends StatefulWidget {
  Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final bookingStatus = FirebaseFirestore.instance.collection('bookingstatus');
  var currentUser = FirebaseAuth.instance.currentUser?.email;

  late String? custfname = '';
  late String? custlname = '';
  late String? maidfname = '';
  late String? maidlname = '';
  late String? custemail = '';
  late String? maidemail = '';
  late String? cleaningtype = '';
  late String? date = '';
  late String? timestart = '';
  late String? timeend = '';
  late String? review = '';
  late int? totalpayment = '' as int?;

  final TextEditingController reviewcontroller = TextEditingController();

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("bookingstatus")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          custfname = snapshot.data()!['custfirstname'];
          custlname = snapshot.data()!['cuslastname'];
          custemail = snapshot.data()!['custemail'];
          maidfname = snapshot.data()!['maidfirstname'];
          maidlname = snapshot.data()!['maidlastname'];
          maidemail = snapshot.data()!['maidemail'];
          cleaningtype = snapshot.data()!['cleaningtype'];
          date = snapshot.data()!['date'];
          timestart = snapshot.data()!['timestart'];
          timeend = snapshot.data()!['timeend'];
          totalpayment = snapshot.data()!['totalpayment'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
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
        String review) {
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
          'review': review,
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
          "Home Page",
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
        gap: 2,
        tabs: [
          GButton(
            icon: Icons.home_rounded,
            text: "Home",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CustHomePage(),
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
                  builder: (context) => Custbooking(),
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
                  builder: (context) => Review(),
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
            children: <Widget>[
              Text("Review List"),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Text(
                    "Read from database customer review based on uid. Contoh: \n\nMaid Name: \nReview:" +
                        "\nRatings: ****" +
                        "\nTime Stamp"),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Text(
                    "Read from database customer review based on uid. Contoh: \n\nMaid Name: \nReview:" +
                        "\nRatings: ****" +
                        "\nTime Stamp"),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Text(
                    "Read from database customer review based on uid. Contoh: \n\nMaid Name: \nReview:" +
                        "\nRatings: ****" +
                        "\nTime Stamp"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: "Leave your review here"),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  child: const Text(
                    'Save Review',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
