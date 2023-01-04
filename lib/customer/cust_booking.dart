import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking_status.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_review.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';
import 'package:freelance_maid_phase_1/geolocation/geolocation.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

class Custbooking extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  const Custbooking({Key? key, this.data}) : super(key: key);

  @override
  State<Custbooking> createState() => _CustbookingState();
}

class _CustbookingState extends State<Custbooking> {
  final _formKey = GlobalKey<FormState>();
  final dropdownState = GlobalKey<FormFieldState>();

  final TextEditingController date = TextEditingController();
  final TextEditingController timestart = TextEditingController();
  final TextEditingController timeend = TextEditingController();
  final TextEditingController hour = TextEditingController();
  final TextEditingController bedrooms = TextEditingController();
  final TextEditingController bathrooms = TextEditingController();
  final TextEditingController office = TextEditingController();
  final TextEditingController kitchens = TextEditingController();
  final TextEditingController pantries = TextEditingController();
  final TextEditingController gardenarea = TextEditingController();
  String? _bathrooms;
  String? _bedrooms;
  String? _office;
  String? _kitchens;
  String? _pantries;
  String? _gardenarea;

  late String maidfname = widget.data!.get('maidfirstname');
  late String maidlname = widget.data!.get('maidlastname');
  late String maidimage = widget.data!.get('image');
  late String maidpnum = widget.data!.get('phonenum');
  late String maidemail = widget.data!.get('maidemail');
  late String maidgender = widget.data!.get('gender');
  late String maidstate = widget.data!.get('state');
  late String cleaningtype = widget.data!.get('cleaningtype');
  late String rateperhour = widget.data!.get('rateperhour');

  late String? fname = '';
  late String? lname = '';
  late String? pnum = '';
  late String? email = '';
  late String? gender = '';
  late String? address = '';
  late String? city = '';
  late String? postcode = '';
  late String? state = '';
  late String? image = '';
  File? imageXFile;

  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  late int bathsum = 0;
  late int bedsum = 0;
  late int officesum = 0;
  late int kitchensum = 0;
  late int pantrysum = 0;
  late int gardensum = 0;
  late int totalpayment = 0;
  String type1 = "Deep Cleaning";
  String type2 = "Disinfection Services";
  String type3 = "Gardening";
  String type4 = "House Cleaning";
  String type5 = "Office Cleaning";
  String type6 = "Post Renovation";

  final List<String> _bathroomslist = ["0", "1", "2", "3", "4"];
  final List<String> _bedroomslist = ["0", "1", "2", "3", "4", "5", "6"];
  final List<String> _officelist = ["0", "1", "2", "3", "4"];
  final List<String> _kitchenslist = ["0", "1", "2", "3", "4"];
  final List<String> _pantrieslist = ["0", "1", "2", "3", "4"];
  final List<String> _gardenarealist = [
    "0sqft",
    "100sqft",
    "150sqft",
    "200sqft",
    "250sqft",
    "300sqft",
    "350sqft",
    "400sqft",
    "450sqft",
    "500sqft",
    "550sqft"
  ];
  String? _selectedbathroom = "0";
  String? _selectedbedroom = "0";
  String? _selectedoffice = "0";
  String? _selectedkitchen = "0";
  String? _selectedpantries = "0";
  String? _selectedgarden = "0sqft";

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("customer")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          fname = snapshot.data()!['custfirstname'];
          lname = snapshot.data()!['custlastname'];
          email = snapshot.data()!['custemail'];
          pnum = snapshot.data()!['phonenum'];
          gender = snapshot.data()!['gender'];
          image = snapshot.data()!['image'];
          address = snapshot.data()!['address'];
          city = snapshot.data()!['city'];
          postcode = snapshot.data()!['postcode'];
          state = snapshot.data()!['state'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference bookingmaid =
        FirebaseFirestore.instance.collection('bookingmaids');
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
        String image,
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
        var uid) {
      try {
        return bookingmaid.add({
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
          'custimage': image,
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
          'uid': uid,
        }).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking Succesful'),
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
            icon: Icon(Icons.location_on),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Geolocation(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 15),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.green[200],
                    backgroundImage: imageXFile == null
                        ? NetworkImage(maidimage)
                        : Image.file(imageXFile!).image,
                    radius: 65,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Maid Name: $maidfname\t$maidlname',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Maid Phone Number: $maidpnum',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Maid Gender:' + maidgender,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Maid Email:' + maidemail,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Maid State:' + maidstate,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: Colors.green[200],
                      backgroundImage: imageXFile == null
                          ? NetworkImage(image!)
                          : Image.file(imageXFile!).image,
                      radius: 65,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Cust Name: $fname\t$lname',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Cust Phone Number: $pnum',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Cust Email: $email',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Cust Gender: $gender',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Cust Address: $address',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Cust State: $state',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Cust Postcode: $postcode',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Cust City: $city',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                if (type1 == cleaningtype) ...[
                  Text(
                    'Cleaning Type: $cleaningtype',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bedrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbedroom,
                        items: _bedroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbedroom = val as String;
                            bedrooms.text = _selectedbedroom!;
                            totalbedroom(bedrooms.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bathrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbathroom,
                        items: _bathroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbathroom = val as String;
                            bathrooms.text = _selectedbathroom!;
                            totalbathroom(bathrooms.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Kitchens",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedkitchen,
                        items: _kitchenslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedkitchen = val as String;
                            kitchens.text = _selectedkitchen!;
                            totalkitchen(kitchens.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Pantry",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedpantries,
                        items: _pantrieslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedpantries = val as String;
                            pantries.text = _selectedpantries!;
                            totalpantries(pantries.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Office",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedoffice,
                        items: _officelist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedoffice = val as String;
                            office.text = _selectedoffice!;
                            totaloffice(office.text);
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
                  const SizedBox(height: 15),
                  Text(
                    'Garden Area: $_selectedgarden',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                ] else if (type2 == cleaningtype) ...[
                  Text(
                    'Cleaning Type: $cleaningtype',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bedrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbedroom,
                        items: _bedroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbedroom = val as String;
                            bedrooms.text = _selectedbedroom!;
                            totalbedroom(bedrooms.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bathrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbathroom,
                        items: _bathroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbathroom = val as String;
                            bathrooms.text = _selectedbathroom!;
                            totalbathroom(bathrooms.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Kitchens",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedkitchen,
                        items: _kitchenslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedkitchen = val as String;
                            kitchens.text = _selectedkitchen!;
                            totalkitchen(kitchens.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Pantry",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedpantries,
                        items: _pantrieslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedpantries = val as String;
                            pantries.text = _selectedpantries!;
                            totalpantries(pantries.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Office",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedoffice,
                        items: _officelist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedoffice = val as String;
                            office.text = _selectedoffice!;
                            totaloffice(office.text);
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
                  const SizedBox(height: 15),
                  Text(
                    'Garden Area: $_selectedgarden',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                ] else if (type3 == cleaningtype) ...[
                  Text(
                    'Cleaning Type: $cleaningtype',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Bedroom:' + _selectedbedroom!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Bathroom:' + _selectedbathroom!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Kitchen:' + _selectedkitchen!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Pantry:' + _selectedpantries!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Office: ' + _selectedoffice!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Garden Area",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedgarden,
                        items: _gardenarealist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedgarden = val as String;
                            gardenarea.text = _selectedgarden!;
                            totalgarden(gardenarea.text);
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
                  const SizedBox(height: 15),
                ] else if (type4 == cleaningtype) ...[
                  Text(
                    'Cleaning Type: $cleaningtype',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bedrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbedroom,
                        items: _bedroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbedroom = val as String;
                            bedrooms.text = _selectedbedroom!;
                            totalbedroom(bedrooms.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bathrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbathroom,
                        items: _bathroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbathroom = val as String;
                            bathrooms.text = _selectedbathroom!;
                            totalbathroom(bathrooms.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Kitchens",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedkitchen,
                        items: _kitchenslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedkitchen = val as String;
                            kitchens.text = _selectedkitchen!;
                            totalkitchen(kitchens.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Pantry",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedpantries,
                        items: _pantrieslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedpantries = val as String;
                            pantries.text = _selectedpantries!;
                            totalpantries(pantries.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Office",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedoffice,
                        items: _officelist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedoffice = val as String;
                            office.text = _selectedoffice!;
                            totaloffice(office.text);
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
                  const SizedBox(height: 15),
                  Text(
                    'Garden Area: $_selectedgarden',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                ] else if (type5 == cleaningtype) ...[
                  Text(
                    'Cleaning Type: $cleaningtype',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Bedroom:' + _selectedbedroom!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bathrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbathroom,
                        items: _bathroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbathroom = val as String;
                            bathrooms.text = _selectedbathroom!;
                            totalbathroom(bathrooms.text);
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
                  const SizedBox(height: 15),
                  Text(
                    'Kitchen: ' + _selectedkitchen!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Pantry",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedpantries,
                        items: _pantrieslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedpantries = val as String;
                            pantries.text = _selectedpantries!;
                            totalpantries(pantries.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Office",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedoffice,
                        items: _officelist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedoffice = val as String;
                            office.text = _selectedoffice!;
                            totaloffice(office.text);
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
                  const SizedBox(height: 15),
                  Text(
                    'Garden Area: $_selectedgarden',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                ] else if (type6 == cleaningtype) ...[
                  Text(
                    'Cleaning Type: $cleaningtype',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bedrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbedroom,
                        items: _bedroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbedroom = val as String;
                            bedrooms.text = _selectedbedroom!;
                            totalbedroom(bedrooms.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Bathrooms",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedbathroom,
                        items: _bathroomslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedbathroom = val as String;
                            bathrooms.text = _selectedbathroom!;
                            totalbathroom(bathrooms.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Kitchens",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedkitchen,
                        items: _kitchenslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedkitchen = val as String;
                            kitchens.text = _selectedkitchen!;
                            totalkitchen(kitchens.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Pantry",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedpantries,
                        items: _pantrieslist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedpantries = val as String;
                            pantries.text = _selectedpantries!;
                            totalpantries(pantries.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Total Office",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedoffice,
                        items: _officelist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedoffice = val as String;
                            office.text = _selectedoffice!;
                            totaloffice(office.text);
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
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Garden Area",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedgarden,
                        items: _gardenarealist
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedgarden = val as String;
                            gardenarea.text = _selectedgarden!;
                            totalgarden(gardenarea.text);
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
                  const SizedBox(height: 15),
                ],
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    ' Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: date,
                        decoration: InputDecoration(
                          hintText: 'Enter your date',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime
                                  .now(), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2025));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              date.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: timestart,
                  decoration: InputDecoration(
                    hintText: 'Enter time start',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: timeend,
                  decoration: InputDecoration(
                    hintText: 'Enter time end',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: hour,
                  decoration: InputDecoration(
                    hintText: 'Enter duration (hour)',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 15),
                Text(
                  'Total Payment: RM $totalall',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
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
                          maidimage,
                          maidpnum,
                          maidemail,
                          maidgender,
                          maidstate,
                          cleaningtype,
                          bathrooms.text,
                          bedrooms.text,
                          kitchens.text,
                          pantries.text,
                          office.text,
                          gardenarea.text,
                          rateperhour,
                          fname ?? "null",
                          lname ?? "null",
                          image ?? "null",
                          pnum ?? "null",
                          email ?? "null",
                          gender ?? "null",
                          address ?? "null",
                          city ?? "null",
                          postcode ?? "null",
                          state ?? "null",
                          date.text,
                          timestart.text,
                          timeend.text,
                          hour.text,
                          totalpayment,
                          currentUser,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Receipt(),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orangeAccent),
                    ),
                    child: const Text(
                      'Book',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  totalbathroom(String bathrooms) {
    if (bathrooms == "0") {
      bathsum = 0;
    } else if (bathrooms == "1") {
      bathsum = 30;
    } else if (bathrooms == "2") {
      bathsum = 60;
    } else if (bathrooms == "3") {
      bathsum = 90;
    } else if (bathrooms == "4") {
      bathsum = 120;
    }
    return bathsum;
  }

  totalbedroom(String bedrooms) {
    if (bedrooms == "0") {
      bedsum = 0;
    } else if (bedrooms == "1") {
      bedsum = 30;
    } else if (bedrooms == "2") {
      bedsum = 60;
    } else if (bedrooms == "3") {
      bedsum = 90;
    } else if (bedrooms == "4") {
      bedsum = 120;
    } else if (bedrooms == "5") {
      bedsum = 150;
    } else if (bedrooms == "6") {
      bedsum = 180;
    }
    return bedsum;
  }

  totalkitchen(String kitchens) {
    if (kitchens == "0") {
      kitchensum = 0;
    } else if (kitchens == "1") {
      kitchensum = 50;
    } else if (kitchens == "2") {
      kitchensum = 100;
    } else if (kitchens == "3") {
      kitchensum = 150;
    } else if (kitchens == "4") {
      kitchensum = 200;
    }
    return kitchensum;
  }

  totalpantries(String pantries) {
    if (pantries == "0") {
      pantrysum = 0;
    } else if (pantries == "1") {
      pantrysum = 40;
    } else if (pantries == "2") {
      pantrysum = 80;
    } else if (pantries == "3") {
      pantrysum = 120;
    } else if (pantries == "4") {
      pantrysum = 160;
    }
    return pantrysum;
  }

  totaloffice(String office) {
    if (office == "0") {
      officesum = 0;
    } else if (office == "1") {
      officesum = 50;
    } else if (office == "2") {
      officesum = 100;
    } else if (office == "3") {
      officesum = 150;
    } else if (office == "4") {
      officesum = 200;
    }
    return officesum;
  }

  totalgarden(String gardenarea) {
    if (gardenarea == "0sqft") {
      gardensum = 0;
    } else if (gardenarea == "100sqft") {
      gardensum = 30;
    } else if (gardenarea == "150sqft") {
      gardensum = 45;
    } else if (gardenarea == "200sqft") {
      gardensum = 60;
    } else if (gardenarea == "250sqft") {
      gardensum = 75;
    } else if (gardenarea == "300sqft") {
      gardensum = 90;
    } else if (gardenarea == "350sqft") {
      gardensum = 105;
    } else if (gardenarea == "400sqft") {
      gardensum = 120;
    } else if (gardenarea == "450sqft") {
      gardensum = 135;
    } else if (gardenarea == "500sqft") {
      gardensum = 150;
    } else if (gardenarea == "550sqft") {
      gardensum = 165;
    }
    return gardensum;
  }

  totalall() {
    return totalpayment = totalbathroom(bathrooms.text) +
        totalbedroom(bedrooms.text) +
        totalkitchen(kitchens.text) +
        totaloffice(office.text) +
        totalgarden(gardenarea.text) +
        totalpantries(pantries.text) +
        (int.parse(rateperhour.toString()) * int.parse(hour.toString()));
  }
}


 /*_calculation(String hour, String bathrooms, String bedrooms, String kitchens,
      String pantries, String office, String gardenarea) {
    setState(
      () {
        if (bathrooms == "0" ||
            bedrooms == "0" ||
            office == "0" ||
            kitchens == "0" ||
            pantries == "0" ||
            gardenarea == "0sqft") {
          sum = 0;
        } else if (bathrooms == "1" || bedrooms == "1") {
          sum = 30;
        } else if (bathrooms == "2" || bedrooms == "2") {
          sum = 60;
        } else if (bathrooms == "3" || bedrooms == "3") {
          sum = 90;
        } else if (bathrooms == "4" || bedrooms == "4") {
          sum = 120;
        } else if (bedrooms == "5") {
          sum = 150;
        } else if (bedrooms == "6") {
          sum = 180;
        } else if (kitchens == "1") {
          sum = 50;
        } else if (kitchens == "2") {
          sum = 100;
        } else if (kitchens == "3") {
          sum = 150;
        } else if (kitchens == "4") {
          sum = 200;
        } else if (pantries == "1") {
          sum = 40;
        } else if (pantries == "2") {
          sum = 80;
        } else if (pantries == "3") {
          sum = 120;
        } else if (pantries == "4") {
          sum = 160;
        } else if (gardenarea == "100sqft") {
          sum = 30;
        } else if (gardenarea == "150sqft") {
          sum = 45;
        } else if (gardenarea == "200sqft") {
          sum = 60;
        } else if (gardenarea == "250sqft") {
          sum = 75;
        } else if (gardenarea == "300sqft") {
          sum = 90;
        } else if (gardenarea == "350sqft") {
          sum = 105;
        } else if (gardenarea == "400sqft") {
          sum = 120;
        } else if (gardenarea == "450sqft") {
          sum = 135;
        } else if (gardenarea == "500sqft") {
          sum = 150;
        } else if (gardenarea == "550sqft") {
          sum = 165;
        }
        totalpayment = sum +
            (int.parse(rateperhour.toString()) * int.parse(hour.toString()));
      },
    );
    return totalpayment;
  }*/
