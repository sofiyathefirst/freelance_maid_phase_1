import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking_status.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_review.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';
import 'package:freelance_maid_phase_1/geolocation/geolocation.dart';
import 'package:freelance_maid_phase_1/geolocation/try_maps.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/deepcleaning.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/disinfection.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/gardening.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/housecleaning.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/officecleaning.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/postrenovation.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustHomePage extends StatefulWidget {
  CustHomePage({Key? key}) : super(key: key);

  @override
  State<CustHomePage> createState() => _CustHomePageState();
}

class _CustHomePageState extends State<CustHomePage> {
  final CollectionReference dataStream =
      FirebaseFirestore.instance.collection('maid');
  String selectedType = "housecleaning";

  void onChangePaketType(String type) {
    selectedType = type;
    setState(() {});
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
          "Home Page",
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
                  builder: (context) => Maps(),
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
                              color: Colors.black,
                            ),
                            child: selectedType == "housecleaning"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.teal[400],
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
                              color: Colors.black,
                            ),
                            child: selectedType == "officecleaning"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.teal[400],
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
                              color: Colors.black,
                            ),
                            child: selectedType == "disinfection"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.teal[400],
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
                                color: Colors.black,
                              ),
                              child: selectedType == "garderning"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.teal[400],
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
                                color: Colors.black,
                              ),
                              child: selectedType == "deepcleaning"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.teal[400],
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
                                color: Colors.black,
                              ),
                              child: selectedType == "postrenovation"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.teal[400],
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
