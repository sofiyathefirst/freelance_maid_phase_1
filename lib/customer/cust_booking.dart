import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/customer/review_page.dart';

import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Custbooking extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  const Custbooking({Key? key, this.data}) : super(key: key);

  @override
  State<Custbooking> createState() => _CustbookingState();
}

class _CustbookingState extends State<Custbooking> {
  final _formKey = GlobalKey<FormState>();
  final dropdownState = GlobalKey<FormFieldState>();
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? formattedDate;
  String? ts = '';
  String selectedTime = '';

  final CollectionReference booktimeslot =
      FirebaseFirestore.instance.collection('bookmaids');

  //timeslot list
  List<String> timeSlots = [
    '8:00 am - 10:00 am',
    '10:30 am - 12:30 pm',
    '1:30 pm - 3:30 pm',
    '4:00 pm - 6:00 pm'
  ];

  List<String> avs = [];

  Future<void> checkAvailability(List<String> timeSlots) async {
    // Get the timeslots from Firestore
    List<String> availableSlots = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookmaids')
        .where('maiduid', isEqualTo: maiduid)
        .where('bookdate', isEqualTo: formattedDate)
        .get();

    final List<DocumentSnapshot> documents = snapshot.docs;
    // Iterate through the list of timeslots
    availableSlots.clear();
    for (int i = 0; i < timeSlots.length; i++) {
      bool isAvailable = true;
      for (final DocumentSnapshot doc in documents) {
        if (doc.get('timeslot') == timeSlots[i]) {
          // If the timeslot is not equal to the selected time, add it to the available slots list
          isAvailable = false;
          break;
        }
      }
      if (isAvailable) {
        availableSlots.add(timeSlots[i]);
      }
    }

    setState(() {
      avs = availableSlots;
    });
  }

  //controller
  final TextEditingController bedrooms = TextEditingController();
  final TextEditingController bathrooms = TextEditingController();
  final TextEditingController office = TextEditingController();
  final TextEditingController kitchens = TextEditingController();
  final TextEditingController pantries = TextEditingController();
  final TextEditingController gardenarea = TextEditingController();

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

  //data cust location
  late double? latitude = 0;
  late double? longitude = 0;
  late String? address = '';

  //data maid location
  late double? mlatitude = 0;
  late double? mlongitude = 0;
  late String? maddress = '';

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
  String _status = "No Status";

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

  //gett customer location from database
  Future _getLocFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("custlocation")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          latitude = snapshot.data()!['latitude'];
          longitude = snapshot.data()!['longitude'];
          address = snapshot.data()!['Address'];
        });
      }
    });
  }

  //get maid location from
  Future _getMaidLocFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("location")
        .doc(maiduid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          mlatitude = snapshot.data()!['latitude'];
          mlongitude = snapshot.data()!['longitude'];
          maddress = snapshot.data()!['Address'];
        });
      }
    });
  }

  //add data to database
  Future addBooking() async {
    FirebaseFirestore.instance.collection('bookmaids').doc().set({
      'maidfirstname': maidfname,
      'maidlastname': maidlname,
      'maidimage': maidimage,
      'maidpnum': maidpnum,
      'maidemail': maidemail,
      'maidgender': maidgender,
      'cleaningtype': cleaningtype,
      'bathroom': bathrooms.text.trim(),
      'bedroom': bedrooms.text.trim(),
      'kitchen': kitchens.text.trim(),
      'pantry': pantries.text.trim(),
      'office': office.text.trim(),
      'garden': gardenarea.text.trim(),
      'custfirstname': fname,
      'cuslastname': lname,
      'custimage': image,
      'custpnum': pnum,
      'custemail': email,
      'custgender': gender,
      'bookdate': formattedDate,
      'timeslot': selectedTime,
      'totalpayment': rateperhour,
      'status': _status,
      'custuid': currentUser,
      'maiduid': maiduid,
      'custlatitude': latitude,
      'custlongitude': longitude,
      'custaddress': address,
      'maidlatitude': mlatitude,
      'maidlongitude': mlongitude,
      'maidaddress': maddress
    }).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Receipt(),
        ),
      ),
    );
    SnackBar snackbar = const SnackBar(
      content: Text("Booking Successful!"),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
    _getLocFromDatabase();
    _getMaidLocFromDatabase();
    checkAvailability(timeSlots);
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
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
          "Booking",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
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
        dragStartBehavior: DragStartBehavior.down,
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 500,
                padding: const EdgeInsets.all(15),
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
                  children: [
                    Text(
                      'Select Date',
                      style: GoogleFonts.heebo(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _tableCalendar(),
                    SizedBox(height: 10),
                    Text(
                      'Select Time Slot',
                      style: GoogleFonts.heebo(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: avs.length,
                        itemBuilder: ((context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTime = avs[index];
                                });
                              },
                              child: Card(
                                elevation: 10,
                                color: selectedTime == avs[index]
                                    ? Colors.green[100]
                                    : Colors.white,
                                child: SizedBox(
                                  height: 60,
                                  child: ListTile(
                                    title: Text(avs[index]),
                                    subtitle: Text('Available'),
                                    leading: selectedTime == avs[index]
                                        ? const Icon(Icons.check)
                                        : null,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 500,
                padding: const EdgeInsets.all(5),
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
                    children: [
                      Text(
                        "Maid's Information",
                        style: GoogleFonts.heebo(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image(
                              image: NetworkImage(maidimage),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              const SizedBox(height: 15),
                              Text('Maid Name: \n$maidfname\t$maidlname',
                                  style: GoogleFonts.heebo(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 15),
                              Text('Maid Phone Number: \n$maidpnum',
                                  style: GoogleFonts.heebo(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 15),
                              Text('Maid Gender: $maidgender',
                                  style: GoogleFonts.heebo(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 15),
                              Text('Maid Email: \n$maidemail',
                                  style: GoogleFonts.heebo(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 15),
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 500,
                padding: const EdgeInsets.all(10),
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
                  children: [
                    SizedBox(height: 10),
                    Text(
                        "Select total number of every area stated below same as number in your house",
                        style: GoogleFonts.heebo(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 15,
                    ),
                    if (type1 == cleaningtype) ...[
                      Text(
                        'Cleaning Type: $cleaningtype',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bedroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bathroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Kitchen',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (type2 == cleaningtype) ...[
                      Text(
                        'Cleaning Type: $cleaningtype',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bedroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bathroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Kitchen',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (type3 == cleaningtype) ...[
                      Text(
                        'Cleaning Type: $cleaningtype',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 220,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Garden',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (type4 == cleaningtype) ...[
                      Text(
                        'Cleaning Type: $cleaningtype',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bedroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bathroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Kitchen',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (type5 == cleaningtype) ...[
                      Text(
                        'Cleaning Type: $cleaningtype',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bathroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Office',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Pantry',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (type6 == cleaningtype) ...[
                      Text(
                        'Cleaning Type: $cleaningtype',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bedroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Bathroom',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Kitchen',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 100,
                            height: 55,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Garden Area',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade200,
                                      width: 3.0),
                                ),
                              ),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'For Customer Review:\n1. Every house cleaning will include living room\n    or any area inside the house\n' +
                          '2. Every cleaning process only will be held for 2\n     hours per booking slot\n3. Maid will bring their own cleaning supplies\n' +
                          '4. Customer can call maid if they did not arrived\n     15 minutes before booking time\n 5. Customer need to do payment directly with\n      maid after the maid finished their job',
                      style: GoogleFonts.heebo(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Total Payment: ${rateperhour}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: addBooking,
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.cyanAccent,
                      backgroundColor: Colors.green),
                  child: const Text(
                    'Book',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  totalall() {
    return totalpayment;
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2025, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
          todayDecoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          defaultTextStyle: TextStyle(color: Colors.black),
          disabledTextStyle: TextStyle(color: Colors.red),
          outsideTextStyle: TextStyle(color: Colors.brown),
          holidayTextStyle: TextStyle(color: Colors.black87)),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          formattedDate = DateFormat('MM/dd/yyyy').format(_currentDay);
          _focusDay = focusedDay;
          _dateSelected = true;
          checkAvailability(timeSlots);
        });
      }),
    );
  }
}
