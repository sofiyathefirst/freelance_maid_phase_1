import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';

class CollaborativeFiltering extends StatefulWidget {
  CollaborativeFiltering({Key? key}) : super(key: key);

  @override
  State<CollaborativeFiltering> createState() => _CollaborativeFilteringState();
}

class _CollaborativeFilteringState extends State<CollaborativeFiltering> {
  Map<String, Map<String, double>> ratings = {};
  Map<String, Map<String, double>> similarityScores = {};
  Map<String, double> predictions = {};
  String customerEmail = "example@email.com";

  @override
  void initState() {
    super.initState();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection("reviews").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        String maidEmail = document.get("maidmail");
        double rating = document.get("rating");
        customerEmail = document.get("custemail");

        if (!ratings.containsKey(maidEmail)) {
          ratings[maidEmail] = {};
        }
        ratings[maidEmail]![customerEmail] = rating;
      });
      makeRecommendation();
    });
  }

  Future<Map<String, double>> makeRecommendation() async {
    for (var maid1 in ratings.keys) {
      for (var maid2 in ratings.keys) {
        if (maid1 == maid2) {
          continue;
        }

        if (!similarityScores.containsKey(maid1)) {
          similarityScores[maid1] = {};
        }

        if (!similarityScores.containsKey(maid2)) {
          similarityScores[maid2] = {};
        }

        double numerator = 0.0;
        double maid1Denominator = 0.0;
        double maid2Denominator = 0.0;

        for (var customer in ratings[maid1]!.keys) {
          if (!ratings[maid2]!.containsKey(customer)) {
            continue;
          }

          numerator += ratings[maid1]![customer]! * ratings[maid2]![customer]!;
          maid1Denominator += pow(ratings[maid1]![customer]!, 2);
          maid2Denominator += pow(ratings[maid2]![customer]!, 2);
        }

        if (numerator == 0 || maid1Denominator == 0 || maid2Denominator == 0) {
          continue;
        }

        double similarity =
            numerator / (sqrt(maid1Denominator) * sqrt(maid2Denominator));
        similarityScores[maid1]![maid2] = similarity;
        similarityScores[maid2]![maid1] = similarity;
      }
    }

    for (var maid in ratings.keys) {
      double prediction = 0.0;
      double totalSimilarity = 0.0;

      for (var otherMaid in ratings.keys) {
        if (otherMaid == maid) {
          continue;
        }

        double similarity = similarityScores[maid]![otherMaid]!;
        double rating = ratings[otherMaid]![customerEmail]!;

        prediction += similarity * rating;
        totalSimilarity += similarity;
      }

      if (totalSimilarity > 0) {
        prediction /= totalSimilarity;
      }

      predictions[maid] = prediction;
    }
    return predictions;
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
                height: 800,
                child: FutureBuilder(
                  future: makeRecommendation(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> recommendedMaids = predictions.keys.toList()
                        ..sort((maid1, maid2) =>
                            predictions[maid2]!.compareTo(predictions[maid1]!))
                        ..take(5);

                      return ListView.builder(
                        itemCount: recommendedMaids.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'Recommended Maid: ${recommendedMaids[index]}, Prediction: ${predictions[recommendedMaids[index]]}'),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
