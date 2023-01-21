import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking_status.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';
import 'package:freelance_maid_phase_1/geolocation/geolocation.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

const TIME_SLOTS = [
  '8:00 am - 10:00 am',
  '12:00 pm - 2:00 pm',
  '4:00 pm - 6:00 pm',
  '8:00 pm - 10:00 pm'
];

class Custbooking extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  const Custbooking({Key? key, this.data}) : super(key: key);

  @override
  State<Custbooking> createState() => _CustbookingState();
}

class _CustbookingState extends State<Custbooking> {
  final _formKey = GlobalKey<FormState>();
  final dropdownState = GlobalKey<FormFieldState>();
  DateTime date = DateTime.now();
  String selectedTime = '';
  final _bookdate = TextEditingController();

  //controller
  final TextEditingController bedrooms = TextEditingController();
  final TextEditingController bathrooms = TextEditingController();
  final TextEditingController office = TextEditingController();
  final TextEditingController kitchens = TextEditingController();
  final TextEditingController pantries = TextEditingController();
  final TextEditingController gardenarea = TextEditingController();

  //display bathrooms
  String? _bathrooms = "0";
  String? _bedrooms = "0";
  String? _office = "0";
  String? _kitchens = "0";
  String? _pantries = "0";
  String? _gardenarea = "0sqft";

  //dapat data drpd database
  late String maidfname = widget.data!.get('maidfirstname');
  late String maidlname = widget.data!.get('maidlastname');
  late String maiduid = widget.data!.get('uid');
  late String maidimage = widget.data!.get('image');
  late String maidpnum = widget.data!.get('phonenum');
  late String maidemail = widget.data!.get('maidemail');
  late String maidgender = widget.data!.get('gender');
  late String cleaningtype = widget.data!.get('cleaningtype');
  late String rateperhour = widget.data!.get('rateperhour');

  //data cust
  late String? fname = '';
  late String? lname = '';
  late String? pnum = '';
  late String? email = '';
  late String? gender = '';
  late String? image = '';
  File? imageXFile;
  var currentUser = FirebaseAuth.instance.currentUser?.uid;

  //data maid
  late String? bookdate = '';
  late String? timeslot = '';
  late String? maidsid = '';

  late int bathsum = 0;
  late int bedsum = 0;
  late int officesum = 0;
  late int kitchensum = 0;
  late int pantrysum = 0;
  late int gardensum = 0;
  late int totalpayment = 0;
  late int sum = 0;
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
        });
      }
    });
  }

  Future _getDataMaid() async {
    await FirebaseFirestore.instance
        .collection("bookmaids")
        .doc(maiduid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          bookdate = snapshot.data()!['bookingdate'];
          timeslot = snapshot.data()!['timeslot'];
          maidsid = snapshot.data()!['maiduid'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
    _getDataMaid();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference bookingmaid =
        FirebaseFirestore.instance.collection('bookmaids');
    Add(
        String maidfname,
        String maidlname,
        String maidimage,
        String maidpnum,
        String maidemail,
        String maidgender,
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
        String date,
        String time,
        int totalpayment,
        var uid,
        String maiduid) {
      try {
        return bookingmaid.add({
          'maidfirstname': maidfname,
          'maidlastname': maidlname,
          'maidimage': maidimage,
          'maidpnum': maidpnum,
          'maidemail': maidemail,
          'maidgender': maidgender,
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
          'bookingdate': date,
          'timeslot': selectedTime,
          'totalpayment': totalpayment,
          'custuid': uid,
          'maiduid': maiduid
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
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _bookdate,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                  color: Colors.green.shade200, width: 3.0),
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.black,
                            ),
                            hintText: 'Enter your booking date',
                            hintStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime
                                    .now(), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2026));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MMMM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                _bookdate.text =
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
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Pick Time Slot',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                if (maidsid == null) ...[
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                        itemCount: TIME_SLOTS.length,
                        itemBuilder: ((context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTime = TIME_SLOTS.elementAt(index);
                              });
                            },
                            child: Card(
                              elevation: 10,
                              color: selectedTime == TIME_SLOTS.elementAt(index)
                                  ? Colors.brown[50]
                                  : Colors.white,
                              child: SizedBox(
                                height: 60,
                                child: ListTile(
                                  title: Text('${TIME_SLOTS.elementAt(index)}'),
                                  subtitle: Text('Available'),
                                  leading: selectedTime ==
                                          TIME_SLOTS.elementAt(index)
                                      ? const Icon(Icons.check)
                                      : null,
                                ),
                              ),
                            )))),
                  ),
                ] else if (maidsid == maiduid) ...[
                  if (bookdate == _bookdate.text) ...[]
                ],
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                      itemCount: TIME_SLOTS.length,
                      itemBuilder: ((context, index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTime = TIME_SLOTS.elementAt(index);
                            });
                          },
                          child: Card(
                            elevation: 10,
                            color: selectedTime == TIME_SLOTS.elementAt(index)
                                ? Colors.brown[50]
                                : Colors.white,
                            child: SizedBox(
                              height: 60,
                              child: ListTile(
                                title: Text('${TIME_SLOTS.elementAt(index)}'),
                                subtitle: Text('Available'),
                                leading:
                                    selectedTime == TIME_SLOTS.elementAt(index)
                                        ? const Icon(Icons.check)
                                        : null,
                              ),
                            ),
                          )))),
                ),
              ],
            ),
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
                ] else if (type3 == cleaningtype) ...[
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
                ] else if (type5 == cleaningtype) ...[
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
                          });
                          int totbedroom = totalbedroom(bedrooms.text);
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
                const SizedBox(height: 15),
                Text(
                  'Total Payment: RM' + totalall().toString(),
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
                            _bookdate.text,
                            selectedTime,
                            totalpayment,
                            currentUser,
                            maiduid);
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
    return totalpayment = sum;
  }
}

/*FutureBuilder(
                    future: maidbook.get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Unsuccesful'),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final sm = snapshot.data!.docs;
                      return Column(
                        children: List.generate(
                          sm.length,
                          (i) {
                            final b = sm[i];
                            if (b.get('maiduid') == null) {
                              //if (b.get('bookingdate') == _bookdate.text) {
                              //var ListTimeSlot =
                              //b.get('timeslot') as List<String>;
                              return SizedBox(
                                height: 400,
                                child: ListView.builder(
                                  itemCount: TIME_SLOTS.length,
                                  itemBuilder: ((context, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedTime =
                                                TIME_SLOTS.elementAt(index);
                                          });
                                        },
                                        child: Card(
                                          elevation: 10,
                                          color: selectedTime ==
                                                  TIME_SLOTS.elementAt(index)
                                              ? Colors.brown[50]
                                              : Colors.white,
                                          child: SizedBox(
                                            height: 60,
                                            child: ListTile(
                                              title: Text(
                                                  '${TIME_SLOTS.elementAt(index)}'),
                                              subtitle: Text('Available'),
                                              leading: selectedTime ==
                                                      TIME_SLOTS
                                                          .elementAt(index)
                                                  ? const Icon(Icons.check)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              );
                              //} else {
                              /*return SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                      itemCount: TIME_SLOTS.length,
                                      itemBuilder: ((context, index) =>
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedTime = TIME_SLOTS
                                                      .elementAt(index);
                                                });
                                              },
                                              child: Card(
                                                elevation: 10,
                                                color: selectedTime ==
                                                        TIME_SLOTS
                                                            .elementAt(index)
                                                    ? Colors.brown[50]
                                                    : Colors.white,
                                                child: SizedBox(
                                                  height: 60,
                                                  child: ListTile(
                                                    title: Text(
                                                        '${TIME_SLOTS.elementAt(index)}'),
                                                    subtitle: Text('Available'),
                                                    leading: selectedTime ==
                                                            TIME_SLOTS
                                                                .elementAt(
                                                                    index)
                                                        ? const Icon(
                                                            Icons.check)
                                                        : null,
                                                  ),
                                                ),
                                              )))),
                                );
                              }*/
                            } /*else if (b.get('maiduid') != maiduid) {
                              return SizedBox(
                                height: 400,
                                child: ListView.builder(
                                    itemCount: TIME_SLOTS.length,
                                    itemBuilder: ((context, index) =>
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedTime =
                                                    TIME_SLOTS.elementAt(index);
                                              });
                                            },
                                            child: Card(
                                              elevation: 10,
                                              color: selectedTime ==
                                                      TIME_SLOTS
                                                          .elementAt(index)
                                                  ? Colors.brown[50]
                                                  : Colors.white,
                                              child: SizedBox(
                                                height: 60,
                                                child: ListTile(
                                                  title: Text(
                                                      '${TIME_SLOTS.elementAt(index)}'),
                                                  subtitle: Text('Available'),
                                                  leading: selectedTime ==
                                                          TIME_SLOTS
                                                              .elementAt(index)
                                                      ? const Icon(Icons.check)
                                                      : null,
                                                ),
                                              ),
                                            )))),
                              );
                            }*/
                            else {
                              return Column(
                                children: [],
                              );
                            }
                          },
                        ),
                      );
                    }),*/
