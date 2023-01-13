import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/geolocation/geolocation.dart';
import 'package:freelance_maid_phase_1/geolocation/maidgeolocation.dart';
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
  late String custaddress = widget.data!.get('custaddress');
  late String custpostcode = widget.data!.get('custpostcode');
  late String custcity = widget.data!.get('custcity');
  late String custstate = widget.data!.get('custstate');
  late String maidstate = widget.data!.get('maidstate');
  late String bedroom = widget.data!.get('bedrooms');
  late String bathroom = widget.data!.get('bathrooms');
  late String kitchen = widget.data!.get('kitchen');
  late String pantry = widget.data!.get('pantry');
  late String office = widget.data!.get('office');
  late String garden = widget.data!.get('garden');
  late String date = widget.data!.get('bookingdate');
  late String timestart = widget.data!.get('timestart');
  late String timeend = widget.data!.get('timeend');
  late String hour = widget.data!.get('hour');
  late int totalpayment = widget.data!.get('totalpayment');
  late String cleaningtype = widget.data!.get('cleaningtype');
  late String rateperhour = widget.data!.get('rateperhour');
  late String status = '';

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
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference bookingstatus =
        FirebaseFirestore.instance.collection('bookstatus');
    Add(
        String maidfname,
        String maidlname,
        String maidimage,
        String maidpnum,
        String maidemail,
        String maidgender,
        String maidstate,
        String cleaningtype,
        String bathrooms,
        String bedrooms,
        String kitchen,
        String pantry,
        String office,
        String garden,
        String rateperhour,
        String fname,
        String lname,
        String custimage,
        String pnum,
        String email,
        String gender,
        String date,
        String timestart,
        String timeend,
        String hour,
        int totalpayment,
        String status) {
      try {
        return bookingstatus.add({
          'maidfirstname': maidfname,
          'maidlastname': maidlname,
          'maidimage': maidimage,
          'maidpnum': maidpnum,
          'maidemail': maidemail,
          'maidgender': maidgender,
          'maidstate': maidstate,
          'cleaningtype': cleaningtype,
          'bathrooms': bathrooms,
          'bedrooms': bedrooms,
          'kitchen': kitchen,
          'pantry': pantry,
          'office': office,
          'garden': garden,
          'rateperhour': rateperhour,
          'custfirstname': fname,
          'cuslastname': lname,
          'custimage': custimage,
          'custpnum': pnum,
          'custemail': email,
          'custgender': gender,
          'bookingdate': date,
          'timestart': timestart,
          'timeend': timeend,
          'hour': hour,
          'totalpayment': totalpayment,
          'status': status,
        }).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking Status Updated!'),
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
              icon: Icon(Icons.location_on),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaidGeolocation(),
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
                    builder: (context) => MaidProfile(),
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
                    builder: (context) => MaidReceipt(),
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
                    builder: (context) => Maidreview(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      'Time Start: $timestart',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Time End: $timeend',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Hour: $hour',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Rate per hour: RM $rateperhour',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: Text(
                              "Reason of Decline",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownButtonFormField(
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
                          Add(
                            maidfname,
                            maidlname,
                            maidimage,
                            maidpnum,
                            maidemail,
                            maidgender,
                            maidstate,
                            cleaningtype,
                            bathroom,
                            bedroom,
                            kitchen,
                            pantry,
                            office,
                            garden,
                            rateperhour,
                            custfname,
                            custlname,
                            custimage,
                            custpnum,
                            custemail,
                            custgender,
                            date,
                            timestart,
                            timeend,
                            hour,
                            totalpayment,
                            displaystatus.text,
                          );
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
