import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/outdoorpage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../maid/indoorpage.dart';

class CustHomePage extends StatefulWidget {
  CustHomePage({Key? key}) : super(key: key);

  @override
  State<CustHomePage> createState() => _CustHomePageState();
}

class _CustHomePageState extends State<CustHomePage> {
  String selectedType = "indoor";

  void onChangePaketType(String type) {
    selectedType = type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        gap: 8,
        tabs: [
          GButton(icon: Icons.home_rounded, text: "Home"),
          GButton(icon: Icons.receipt_rounded, text: "Receipt"),
          GButton(icon: Icons.book_online_rounded, text: "Booking"),
          GButton(icon: Icons.reviews_rounded, text: "Review"),
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
                    InkWell(
                      onTap: () {
                        onChangePaketType("indoor");
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
                            "Indoor",
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
                            child: selectedType == "indoor"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.pink[400],
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
                        onChangePaketType("outdoor");
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
                            "Outdoor",
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
                            child: selectedType == "outdoor"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.pink[400],
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
                        onChangePaketType("housecleaning");
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
                                    color: Colors.pink[400],
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
                                    color: Colors.pink[400],
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
                                    color: Colors.pink[400],
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
                        onChangePaketType("garderning");
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
                                    color: Colors.pink[400],
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
                                    color: Colors.pink[400],
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
                                    color: Colors.pink[400],
                                    size: 30,
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Recommended"),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
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
                          "Maid recommendation kat sini. Contoh: \n\nGambar \n\nNama:" +
                              "\nNombor Phone:" +
                              "\nRatings:" +
                              "\n\nButton View"),
                    ),
                    SizedBox(
                      width: 20,
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
                          "Maid recommendation kat sini. Contoh: \n\nGambar \n\nNama:" +
                              "\nNombor Phone:" +
                              "\nRatings:" +
                              "\n\nButton View"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
