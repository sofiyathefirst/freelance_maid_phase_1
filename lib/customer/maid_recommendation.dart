import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';

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
          "Maid Recommendation",
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
        child: Column(
          children: [
            Text("Maid Recommendations"),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 200,
              child: FutureBuilder<List<String>>(
                future: RecommendationService().getTopNMaids(5),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Text(snapshot.data![index]);
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
