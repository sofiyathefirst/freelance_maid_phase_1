import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';

import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_receipt.dart';
import 'package:freelance_maid_phase_1/maid/maid_review.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

enum ProductTypeEnum { Accept, Decline }

class UpdateBooking extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  UpdateBooking({Key? key, this.data}) : super(key: key);

  @override
  State<UpdateBooking> createState() => _UpdateBookingState();
}

class _UpdateBookingState extends State<UpdateBooking> {
  ProductTypeEnum? _productTypeEnum;
  final GlobalKey<FormState> _abcKey = GlobalKey<FormState>();

  late String maiduid = widget.data!.get('maiduid');
  late String custuid = widget.data!.get('custuid');
  late String maidfname = widget.data!.get('maidfirstname');
  late String maidlname = widget.data!.get('maidlastname');
  late String maidpnum = widget.data!.get('maidpnum');
  late String maidimage = widget.data!.get('maidimage');
  late String maidemail = widget.data!.get('maidemail');
  late String maidgender = widget.data!.get('maidgender');
  late String custfname = widget.data!.get('custfirstname');
  late String custlname = widget.data!.get('cuslastname');
  late String custimage = widget.data!.get('custimage');
  late String custpnum = widget.data!.get('custpnum');
  late String custemail = widget.data!.get('custemail');
  late String custgender = widget.data!.get('custgender');
  late String bedroom = widget.data!.get('bedroom');
  late String bathroom = widget.data!.get('bathroom');
  late String kitchen = widget.data!.get('kitchen');
  late String pantry = widget.data!.get('pantry');
  late String office = widget.data!.get('office');
  late String garden = widget.data!.get('garden');
  late String date = widget.data!.get('bookdate');
  late String timeslot = widget.data!.get('timeslot');
  late String totalpayment = widget.data!.get('totalpayment');
  late String cleaningtype = widget.data!.get('cleaningtype');
  late String status = widget.data!.get('status');
  late double latitude = widget.data!.get('custlatitude');
  late double longitude = widget.data!.get('custlongitude');
  late String? address = widget.data!.get('custaddress');
  late double? mlatitude = widget.data!.get('maidlatitude');
  late double? mlongitude = widget.data!.get('maidlongitude');
  late String? maddress = widget.data!.get('maidaddress');
  bool isLoading = false;

  TextEditingController displaystatus = TextEditingController();

  String? _selectedstatus = "I am fully booked";
  final _declineList = [
    "I am fully booked",
    "I will be away on that date",
    "I have other appointment",
    "Other Reason"
  ];

  @override
  void initState() {
    super.initState();
    updateBookStatus();
  }

  Future updateBookStatus() async {
    final qs = await FirebaseFirestore.instance
        .collection("bookmaids")
        .where("maiduid", isEqualTo: maiduid)
        .where("bookdate", isEqualTo: date)
        .where("timeslot", isEqualTo: timeslot)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    qs.docs.forEach((element) {
      batch.update(element.reference, {
        "status": displaystatus.text.trim(),
        'custfirstname': custfname,
        'cuslastname': custlname,
        'custpnum': custpnum,
        'custgender': custgender,
        'custemail': custemail,
        'custuid': custuid,
        'custimage': custimage,
        'maidfirstname': maidfname,
        'maidlastname': maidlname,
        'maidpnum': maidpnum,
        'maidgender': maidgender,
        'maidemail': maidemail,
        'maiduid': maiduid,
        'maidimage': maidimage,
        'bedroom': bedroom,
        'bathroom': bathroom,
        'kitchen': kitchen,
        'pantry': pantry,
        'office': office,
        'garden': garden,
        'bookdate': date,
        'timeslot': timeslot,
        'cleaningtype': cleaningtype,
        'totalpayment': totalpayment,
        'custlatitude': latitude,
        'custlongitude': longitude,
        'custaddress': address,
        'maidlatitude': mlatitude,
        'maidlongitude': mlongitude,
        'maidaddress': maddress
      });
    });
    await batch.commit();
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
            builder: (context) => MaidReceipt(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Maidreview(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaidProfile(),
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
                  builder: (context) => MaidHomePage(),
                ),
              );
            },
          ),
          title: const Text(
            "Booking Status",
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Book",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.reviews_rounded),
              label: "Review",
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Booking Date: $date',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Time Start: $timeslot',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Total Payment: RM $totalpayment',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile<ProductTypeEnum>(
                            contentPadding: const EdgeInsets.all(0.0),
                            value: ProductTypeEnum.Accept,
                            groupValue: _productTypeEnum,
                            dense: true,
                            title: Text(ProductTypeEnum.Accept.name),
                            onChanged: (val) {
                              setState(() {
                                _productTypeEnum = val;
                                displaystatus.text =
                                    ProductTypeEnum.Accept.name;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile<ProductTypeEnum>(
                            contentPadding: const EdgeInsets.all(0.0),
                            value: ProductTypeEnum.Decline,
                            groupValue: _productTypeEnum,
                            dense: true,
                            title: Text(ProductTypeEnum.Decline.name),
                            onChanged: (val) {
                              setState(() {
                                _productTypeEnum = val;
                                displaystatus.text =
                                    ProductTypeEnum.Decline.name;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (displaystatus.text == "Decline") ...[
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: 'Reason of Decline',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            value: _selectedstatus,
                            items: _declineList
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedstatus = val as String;
                                displaystatus.text =
                                    ProductTypeEnum.Decline.name +
                                        '\t' +
                                        _selectedstatus!;
                              });
                            },
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          updateBookStatus();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MaidReceipt(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.orangeAccent),
                        ),
                        child: const Text(
                          'Update Status',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
