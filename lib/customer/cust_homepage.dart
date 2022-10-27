import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/outdoorpage.dart';
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Choose cleaning service",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    onChangePaketType("indoor");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.40,
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
                InkWell(
                  onTap: () {
                    onChangePaketType("outdoor");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.43,
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
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    onChangePaketType("housecleaning");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.40,
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
                InkWell(
                  onTap: () {
                    onChangePaketType("officecleaning");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.43,
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
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    onChangePaketType("disinfection");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.40,
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
                InkWell(
                  onTap: () {
                    onChangePaketType("garderning");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.43,
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
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    onChangePaketType("deepcleaning");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.40,
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
                InkWell(
                  onTap: () {
                    onChangePaketType("postrenovation");
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width * 0.43,
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column extraWidget(String name, bool isSelected) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[350],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: isSelected == true
                  ? Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.pink[400],
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
