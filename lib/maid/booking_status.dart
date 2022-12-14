import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_receipt.dart';
import 'package:freelance_maid_phase_1/maid/maid_review.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../customer/cust_booking.dart';
import '../customer/cust_review.dart';
import '../customer/custreceipt.dart';

enum ProductTypeEnum { Accept, Decline }

class UpdateBooking extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  UpdateBooking({Key? key, this.data}) : super(key: key);

  @override
  State<UpdateBooking> createState() => _UpdateBookingState();
}

class _UpdateBookingState extends State<UpdateBooking> {
  ProductTypeEnum? _productTypeEnum;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();

  late String maidfname = widget.data!.get('maidfirstname');
  late String maidlname = widget.data!.get('maidlastname');
  late String maidpnum = widget.data!.get('maidpnum');
  late String maidemail = widget.data!.get('maidemail');
  late String maidgender = widget.data!.get('maidgender');
  late String custfname = widget.data!.get('custfirstname');
  late String custlname = widget.data!.get('cuslastname');
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
        FirebaseFirestore.instance.collection('bookingstatus');
    Add(
        String maidfname,
        String maidlname,
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
        String pnum,
        String email,
        String gender,
        String address,
        String city,
        String postcode,
        String state,
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
          'custpnum': pnum,
          'custemail': email,
          'custgender': gender,
          'custaddress': address,
          'custcity': city,
          'custpostcode': postcode,
          'custstate': state,
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
                  builder: (context) => CustHomePage(),
                ),
              );
            },
          ),
          title: const Text(
            "Booking",
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
                    builder: (context) => MaidHomePage(),
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
                      children: [
                        RadioListTile<ProductTypeEnum>(
                          contentPadding: const EdgeInsets.all(0.0),
                          value: ProductTypeEnum.Accept,
                          groupValue: _productTypeEnum,
                          dense: true,
                          title: Text(ProductTypeEnum.Accept.name),
                          onChanged: (val) {
                            setState(() {
                              _productTypeEnum = val;
                              status = ProductTypeEnum.Accept.name;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        RadioListTile<ProductTypeEnum>(
                          contentPadding: const EdgeInsets.all(0.0),
                          value: ProductTypeEnum.Decline,
                          groupValue: _productTypeEnum,
                          dense: true,
                          title: Text(ProductTypeEnum.Decline.name),
                          onChanged: (val) {
                            setState(() {
                              _productTypeEnum = val;
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
                                        status = ProductTypeEnum.Decline.name +
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
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(
                              () {},
                            );
                            Add(
                              maidfname,
                              maidlname,
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
                              custpnum,
                              custemail,
                              custgender,
                              custaddress,
                              custcity,
                              custpostcode,
                              custstate,
                              date,
                              timestart,
                              timeend,
                              hour,
                              totalpayment,
                              status,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MaidReceipt(),
                              ),
                            );
                          }
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
