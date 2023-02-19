import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_fonts/google_fonts.dart';

class MaidRecommendation extends StatefulWidget {
  MaidRecommendation({Key? key}) : super(key: key);

  @override
  State<MaidRecommendation> createState() => _MaidRecommendationState();
}

class RecommendationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getTopNMaids(int n) async {
    // Fetch all the ratings from the "reviews" collection
    QuerySnapshot snapshot = await _firestore.collection("reviews").get();
    List<DocumentSnapshot> docs = snapshot.docs;

    // Calculate the average rating for each maid
    Map<String, double> maidRatings = {};
    for (var doc in docs) {
      String maidEmail = doc.get('maidemail');
      double rating = double.parse(doc.get('rating').toString());
      if (maidRatings.containsKey(maidEmail)) {
        maidRatings[maidEmail] = (maidRatings[maidEmail] ?? 0.0) + rating;
      } else {
        maidRatings[maidEmail] = rating;
      }
    }
    maidRatings.forEach((maid, rating) =>
        maidRatings[maid] = (maidRatings[maid] ?? 0.0) / docs.length);

    // Sort the maids based on their average ratings
    List<String> sortedMaids = maidRatings.keys.toList()
      ..sort(
          (maid1, maid2) => maidRatings[maid2]!.compareTo(maidRatings[maid1]!));

    // Recommend the top N maids to the customer
    return sortedMaids.sublist(0, n);
  }

  Future<List<Map<String, dynamic>>> getTopNMaidDetails(
      List<String> topNMaids) async {
    List<Map<String, dynamic>> topNMaidDetails = [];

    for (var maidEmail in topNMaids) {
      var querySnapshot = await _firestore
          .collection("maid")
          .where("maidemail", isEqualTo: maidEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        Map<String, dynamic> maidDetails =
            snapshot.data() as Map<String, dynamic>;
        topNMaidDetails.add(maidDetails);
      }
    }
    return topNMaidDetails;
  }
}

class _MaidRecommendationState extends State<MaidRecommendation> {
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

  Future<List<Map<String, dynamic>>> getData() async {
    var topNMaids = await RecommendationService().getTopNMaids(6);
    var topNMaidDetails =
        await RecommendationService().getTopNMaidDetails(topNMaids);
    return topNMaidDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
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
          "Maid Recommendation",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout_rounded, color: Colors.black),
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
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              //height: 500,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Maid Recommendations",
                    style: GoogleFonts.heebo(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "These recommendations are based on top 5 highest rate maids. The rate are total average rates that given by their customers",
                      style: GoogleFonts.heebo(
                        textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              height: 400,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image(
                                    image: NetworkImage(
                                        snapshot.data![index]["image"]),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                        'Name: \n' +
                                            snapshot.data![index]
                                                ["maidfirstname"] +
                                            '\t' +
                                            snapshot.data![index]
                                                ["maidlastname"],
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    Text(
                                        'Phone Number: \n' +
                                            snapshot.data![index]["phonenum"]
                                                .toString(),
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    Text(
                                        'Email: \n' +
                                            snapshot.data![index]["maidemail"],
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    Text(
                                        'Gender: \n' +
                                            snapshot.data![index]["gender"],
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    Text(
                                        'Rate per 2 hour: \n' +
                                            snapshot.data![index]
                                                ["rateperhour"],
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    Text(
                                        'Cleaning type: \n' +
                                            snapshot.data![index]
                                                ["cleaningtype"],
                                        style: GoogleFonts.heebo(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 20),
                                  ],
                                )
                              ],
                            ),
                            // Add more fields as needed
                            Divider(),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
