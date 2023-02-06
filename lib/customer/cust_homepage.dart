import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/geolocation/display_all_location.dart';

import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/deepcleaning.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/disinfection.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/gardening.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/housecleaning.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/officecleaning.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/postrenovation.dart';

class CustHomePage extends StatefulWidget {
  CustHomePage({Key? key}) : super(key: key);

  @override
  State<CustHomePage> createState() => _CustHomePageState();
}

/*class RecommendationService {
  final CollectionReference _reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  Future<Map<String, double>> getMaidRatings() async {
    //Step 1: Retrieve the data from the review collection in Firebase Firestore
    final querySnapshot = await _reviewsCollection.get();
    final documents = querySnapshot.docs;

    //Step2: Preprocess the data
    final Map<String, List<double>> maidRatings = {};
    for (var document in documents) {
      final maidEmail = document.get('maidemail');
      final rating = document.get('rating');
      if (!maidRatings.containsKey(maidEmail)) {
        maidRatings[maidEmail] = [rating];
      } else {
        maidRatings[maidEmail]?.add(rating);
      }
    }

    //Step 3: Calculate the average rating for each maid
    final Map<String, double> maidAverageRatings = {};
    for (var maid in maidRatings.keys) {
      final ratings = maidRatings[maid];
      final average = ratings!.reduce((a, b) => a + b) / ratings.length;
      maidAverageRatings[maid] = average;
    }

    return maidAverageRatings;
  }

  Future<List<String>> getRecommendations(String customerEmail) async {
    //Step 1: Retrieve the data from the review collection
    final querySnapshot = await _reviewsCollection.get();
    final documents = querySnapshot.docs;

    //Step 2: Preprocess the data
    final Map<String, List<double>> customerRatings = {};
    for (var document in documents) {
      final customer = document.get('custemail');
      final maid = document.get('maidemail');
      final rating = document.get('rating');
      if (customer == customerEmail) {
        if (!customerRatings.containsKey(maid)) {
          customerRatings[maid] = [rating];
        } else {
          customerRatings[maid]?.add(rating);
        }
      }
    }

    //Step 3: Calculate the average rating for the customer
    final customerAverageRatings = {};
    for (var maid in customerRatings.keys) {
      final ratings = customerRatings[maid];
      final average = ratings!.reduce((a, b) => a + b) / ratings.length;
      customerAverageRatings[maid] = average;
    }

    //Step 4: Find the ratings given by other customers
    //final querySnapshot = await _reviewsCollection.get();
    //final documents = querySnapshot.docs;
    final Map<String, List<double>> otherCustomerRatings = {};
    for (var document in documents) {
      final customer = document.get('custemail');
      final maid = document.get('maidemail');
      final rating = document.get('rating');
      if (customer != customerEmail) {
        if (!otherCustomerRatings.containsKey(customer)) {
          otherCustomerRatings[customer] = {
            maid: [rating]
          } as List<double>;
        } else if (!otherCustomerRatings[customer]!.contains(maid)) {
          otherCustomerRatings[customer]![maid] = [rating] as double;
        } else {
          otherCustomerRatings[customer]![maid].add(rating);
        }
      }
    }

    final Map<String, double> similarityScores = {};
    for (var otherCustomer in otherCustomerRatings.keys) {
      final otherCustomerRatingsForMaids = otherCustomerRatings[otherCustomer];
      for (var maid in otherCustomerRatingsForMaids.keys) {
        final ratings = otherCustomerRatingsForMaids[maid];
        final average = ratings.reduce((a, b) => a + b) / ratings.length;
        if (customerAverageRatings.containsKey(maid) &&
            customerAverageRatings[maid] != 0) {
          final customerAverage = customerAverageRatings[maid];
          final numerator = ratings
              .map((rating) => (rating - average) * (customerAverage - average))
              .reduce((a, b) => a + b);
          final denominator = sqrt(ratings
                  .map((rating) => pow(rating - average, 2))
                  .reduce((a, b) => a + b)) *
              sqrt(customerAverageRatings.keys
                      .map((k) => pow(customerAverageRatings[k] - average, 2))
                      .reduce((a, b) => a + b));
          similarityScores[maid] = numerator / denominator;
        }
      }
    }
  }
}*/

//start sini!!!
Future<double> getAverageStarRating(String maidEmail) async {
  double avgRating = 0.0;
  int count = 0;

  // Get a reference to the collection of reviews
  final reviewsRef = FirebaseFirestore.instance.collection('reviews');

  // Filter the reviews by the maid's ID
  final reviews =
      await reviewsRef.where('maidemail', isEqualTo: maidEmail).get();

  // Calculate the average star rating
  for (var review in reviews.docs) {
    avgRating += review.data()['starRating'];
    count++;
  }
  avgRating = avgRating / count;

  return avgRating;
}

Future<List> getRecommendations(String maidEmail) async {
  // Get the average star rating for the given maid
  final avgRating = await getAverageStarRating(maidEmail);

  // Get a reference to the collection of reviews
  final reviewsRef = FirebaseFirestore.instance.collection('reviews');

  // Find the other maids with similar average star ratings
  final recommendations = await reviewsRef
      .where('rating', isGreaterThanOrEqualTo: avgRating - 0.5)
      .where('rating', isLessThanOrEqualTo: avgRating + 0.5)
      .where('maidemail', isNotEqualTo: maidEmail)
      .get();

  // Extract the maid IDs from the recommendations
  final recommendationIds =
      recommendations.docs.map((review) => review.data()['maidId']).toList();

  return recommendationIds;
}

class _CustHomePageState extends State<CustHomePage> {
  final CollectionReference dataStream =
      FirebaseFirestore.instance.collection('maid');
  String selectedType = "housecleaning";

  void onChangePaketType(String type) {
    selectedType = type;
    setState(() {});
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
          icon: Icon(
            Icons.arrow_back_ios_new,
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
          "Home Page",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayAllLocation(),
                ),
              );
            },
          ),
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Choose Services"),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        onChangePaketType("housecleaning");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HouseCleaning()),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[350],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              image: const DecorationImage(
                                image: AssetImage('assets/image/indoor.png'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "House Cleaning",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black38,
                            ),
                            child: selectedType == "housecleaning"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.deepPurple[400],
                                    size: 30,
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        onChangePaketType("officecleaning");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OFficeCleaning()),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[350], //Color(0xffdfdeff),
                              image: const DecorationImage(
                                image: AssetImage('assets/image/outdoor.png'),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Office Cleaning",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black38,
                            ),
                            child: selectedType == "officecleaning"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.deepPurple[400],
                                    size: 30,
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        onChangePaketType("disinfection");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Disinfection()),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[350],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              image: const DecorationImage(
                                image: AssetImage('assets/image/indoor.png'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Disinfection",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black38,
                            ),
                            child: selectedType == "disinfection"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.deepPurple[400],
                                    size: 30,
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          onChangePaketType("garderning");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Gardening()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[350], //Color(0xffdfdeff),
                                image: const DecorationImage(
                                  image: AssetImage('assets/image/outdoor.png'),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Garderning",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black38,
                              ),
                              child: selectedType == "garderning"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.deepPurple[400],
                                      size: 30,
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          onChangePaketType("deepcleaning");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeepCleaning()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                image: const DecorationImage(
                                  image: AssetImage('assets/image/indoor.png'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Deep Cleaning",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black38,
                              ),
                              child: selectedType == "deepcleaning"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.deepPurple[400],
                                      size: 30,
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          onChangePaketType("postrenovation");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Postrenovation()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[350], //Color(0xffdfdeff),
                                image: const DecorationImage(
                                  image: AssetImage('assets/image/outdoor.png'),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Post Renovation",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black38,
                              ),
                              child: selectedType == "postrenovation"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.deepPurple[400],
                                      size: 30,
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
