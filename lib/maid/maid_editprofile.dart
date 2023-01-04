import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/gettextformfield.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MaidEditProfile extends StatefulWidget {
  MaidEditProfile({Key? key}) : super(key: key);

  @override
  State<MaidEditProfile> createState() => _MaidEditProfileState();
}

class _MaidEditProfileState extends State<MaidEditProfile> {
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  FirebaseStorage storageRef = FirebaseStorage.instance;
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? fname = '';
  String? lname = '';
  String? pnum = '';
  String? email = '';
  String? gender = '';
  String? birthdate = '';
  String? address = '';
  String? city = '';
  String? postcode = '';
  String? state = '';
  String? image = '';
  String? password = '';
  String? cleaningtype = '';
  String? rateperhour;
  String? serviceoffered = '';
  String imageName = '';
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  TextEditingController displayfname = TextEditingController();
  TextEditingController displaylname = TextEditingController();
  TextEditingController displaypnum = TextEditingController();
  TextEditingController displayimg = TextEditingController();
  TextEditingController displayemail = TextEditingController();
  TextEditingController displaygender = TextEditingController();
  TextEditingController displaybirthdate = TextEditingController();
  TextEditingController displayaddress = TextEditingController();
  TextEditingController displaycity = TextEditingController();
  TextEditingController displaypostcode = TextEditingController();
  TextEditingController displaystate = TextEditingController();
  TextEditingController displaypassword = TextEditingController();
  TextEditingController displaycleaningtype = TextEditingController();
  TextEditingController displayrateperhour = TextEditingController();
  TextEditingController displayserviceoffered = TextEditingController();
  TextEditingController _confirmpass = TextEditingController();

  final _genderList = ["Male", "Female"];
  final _postcodeList = [
    "75000",
    "75050",
    "75100",
    "75150",
    "75200",
    "75250",
    "75260",
    "75300",
    "75350",
    "75400",
    "75430",
    "75450",
    "75460",
    "76300",
    "76400",
    "76450",
    "77200"
  ];
  final _cityList = [
    "Alor Gajah",
    "Asahan",
    "Ayer Keroh",
    "Bemban",
    "Durian Tunggal",
    "Jasin",
    "Kem Trendak",
    "Kuala Sungai Baru",
    "Lubok China",
    "Masjid Tanah",
    "Melaka",
    "Merlimau",
    "Selandar",
    "Sungai Rambai",
    "Sungai Udang",
    "Tanjong Kling"
  ];
  final _cleaningtypeList = [
    "Deep Cleaning",
    "Disinfection Services",
    "Gardening",
    "House Cleaning",
    "Office Cleaning",
    "Post Renovation"
  ];
  final _rateperhourList = ["50", "70", "100", "150", "170"];
  final _serviceofferedList = [
    "Deep Cleaning: Whole house cleaning under furniture, vacuuming and cleaning upholstery, scrubbing walls, polishing furniture, organizing",
    "Disinfection Services: Sanitizing whole house or office area",
    "Gardening: Mowing, Pruning, Fertilizing",
    "House Cleaning: Whole house cleaning, mopping, vacuuming, dusting, polishing adn sweeping",
    "Office Cleaning: Whole office cleaning, mopping, dusting, polishing, sanitizing and waste removal",
    "Post Renovation: Whole renovation area cleaning, mopping, dusting, polishing, sanitizing, organizing"
  ];
  String? _selectedgender = "Male";
  String? _selectedservice =
      "Deep Cleaning: Whole house cleaning under furniture, vacuuming and cleaning upholstery, scrubbing walls, polishing furniture, organizing";
  String? _selectedVal = "Deep Cleaning";
  String? _selectedrate = "50";
  String? _selectedpostcode = "75000";
  String? _selectedcity = "Alor Gajah";
  bool _fname = true;
  bool _lname = true;
  bool _pnum = true;
  bool _email = true;
  bool _gender = true;
  bool _birthdate = true;
  bool _address = true;
  bool _city = true;
  bool _postcode = true;
  bool _state = true;
  bool _image = true;
  bool _password = true;
  bool _cleaningtype = true;
  bool _rateperhour = true;
  bool _serviceoffered = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("maid")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          fname = snapshot.data()!['maidfirstname'];
          lname = snapshot.data()!['maidlastname'];
          email = snapshot.data()!['maidemail'];
          pnum = snapshot.data()!['phonenum'];
          gender = snapshot.data()!['gender'];
          birthdate = snapshot.data()!['birthdate'];
          image = snapshot.data()!['image'];
          address = snapshot.data()!['address'];
          city = snapshot.data()!['city'];
          postcode = snapshot.data()!['postcode'];
          state = snapshot.data()!['state'];
          cleaningtype = snapshot.data()!['cleaningtype'];
          rateperhour = snapshot.data()!['rateperhour'];
          serviceoffered = snapshot.data()!['serviceoffered'];
          password = snapshot.data()!['password'];
        });
        displayfname.text = fname!;
        displaylname.text = lname!;
        displaypnum.text = pnum!;
        displayimg.text = image!;
        displayemail.text = email!;
        displaygender.text = gender!;
        displaybirthdate.text = birthdate!;
        displayaddress.text = address!;
        displaycity.text = city!;
        displaypostcode.text = postcode!;
        displaystate.text = state!;
        displaycleaningtype.text = cleaningtype!;
        displayrateperhour.text = rateperhour!;
        displayserviceoffered.text = serviceoffered!;
        displaypassword.text = password!;
      }
    });
  }

  Future updateProfileData() async {
    setState(() {
      displayfname.text.isEmpty ? _fname = false : _fname = true;
      displaylname.text.isEmpty ? _lname = false : _lname = true;
      displaypnum.text.isEmpty ? _pnum = false : _pnum = true;
      displayimg.text.isEmpty ? _image = false : _image = true;
      displayemail.text.isEmpty ? _email = false : _email = true;
      displaygender.text.isEmpty ? _gender = false : _gender = true;
      displaybirthdate.text.isEmpty ? _birthdate = false : _birthdate = true;
      displayaddress.text.isEmpty ? _address = false : _address = true;
      displaypostcode.text.isEmpty ? _postcode = false : _postcode = true;
      displaycity.text.isEmpty ? _city = false : _city = true;
      displaystate.text.isEmpty ? _state = false : _state = true;
      displaycleaningtype.text.isEmpty
          ? _cleaningtype = false
          : _cleaningtype = true;
      displayrateperhour.text.isEmpty
          ? _rateperhour = false
          : _rateperhour = true;
      displayserviceoffered.text.isEmpty
          ? _serviceoffered = false
          : _serviceoffered = true;
      displaypassword.text.isEmpty ? _password = false : _password = true;
    });

    if (_image &&
        _fname &&
        _lname &&
        _pnum &&
        _email &&
        _gender &&
        _birthdate &&
        _address &&
        _postcode &&
        _city &&
        _state &&
        _cleaningtype &&
        _rateperhour &&
        _serviceoffered &&
        _password) {
      await FirebaseAuth.instance.currentUser!
          .updateEmail(
            displayemail.text.trim(),
          )
          .then((value) => {
                FirebaseFirestore.instance
                    .collection("maid")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  "maidfirstname": displayfname.text.trim(),
                  "maidlastname": displaylname.text.trim(),
                  "maidemail": displayemail.text.trim(),
                  "phonenum": displaypnum.text.trim(),
                  "gender": displaygender.text.trim(),
                  "birthdate": displaybirthdate.text.trim(),
                  "image": displayimg.text.trim(),
                  "address": displayaddress.text.trim(),
                  "postcode": displaypostcode.text.trim(),
                  "city": displaycity.text.trim(),
                  "state": displaystate.text.trim(),
                  "cleaningtype": displaycleaningtype.text.trim(),
                  "rateperhour": displayrateperhour.text.trim(),
                  "serviceoffered": displayserviceoffered.text.trim(),
                  "password": displaypassword.text.trim()
                })
              })
          .then(
            (value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MaidProfile(),
              ),
            ),
          );
      await FirebaseAuth.instance.currentUser!.updatePassword(
        displaypassword.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update Successful!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MaidProfile(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 65.0,
                  backgroundImage: NetworkImage(image!),
                ),
                const SizedBox(
                  height: 20,
                ),
                imageName == "" ? Container() : Text("${imageName}"),
                OutlinedButton(
                    onPressed: () {
                      imagePicker();
                    },
                    child: Text("Select Image")),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "First Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: displayfname,
                        decoration: InputDecoration(
                          hintText: "Update First Name",
                          errorText: _fname ? null : "First Name invalid",
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
                            Icons.person,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Last Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: displaylname,
                        decoration: InputDecoration(
                          hintText: "Update Last Name",
                          errorText: _lname ? null : "Last Name invalid",
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
                            Icons.person,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Phone Number",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: displaypnum,
                        decoration: InputDecoration(
                          hintText: "Update Phone Number",
                          errorText: _pnum ? null : "Phone Number invalid",
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
                            Icons.phone,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: displayemail,
                        decoration: InputDecoration(
                          hintText: "Update Email",
                          errorText: _email ? null : "Email invalid",
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
                            Icons.email,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Cleaning Type",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        value: _selectedVal,
                        items: _cleaningtypeList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedVal = val as String;
                            displaycleaningtype.text = _selectedVal!;
                          });
                        },
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                            Icons.cleaning_services_rounded,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        value: _selectedgender,
                        items: _genderList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedgender = val as String;
                            displaygender.text = _selectedgender!;
                          });
                        },
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                            Icons.person,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Birth Date",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: displaybirthdate,
                              decoration: InputDecoration(
                                hintText: 'Update Birthdate',
                                errorText:
                                    _birthdate ? null : "Birthdate invalid",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                prefixIcon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.black,
                                ),
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
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(1900),
                                    firstDate: DateTime(
                                        1900), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2025));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement

                                  setState(() {
                                    displaybirthdate.text =
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
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Address",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: displayaddress,
                        decoration: InputDecoration(
                          hintText: "Update Address",
                          errorText: _address ? null : "Address invalid",
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
                            Icons.home,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Postcode",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        value: _selectedpostcode,
                        items: _postcodeList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedpostcode = val as String;
                            displaypostcode.text = _selectedpostcode!;
                          });
                        },
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                            Icons.location_on,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "City",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        value: _selectedcity,
                        items: _cityList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedcity = val as String;
                            displaycity.text = _selectedcity!;
                          });
                        },
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                            Icons.location_city_outlined,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "State",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: displaystate,
                        decoration: InputDecoration(
                          hintText: "Update State",
                          errorText: _state ? null : "State invalid",
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
                            Icons.location_on,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Rate per Hour",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        value: _selectedrate,
                        items: _rateperhourList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedrate = val as String;
                            displayrateperhour.text = _selectedrate!;
                          });
                        },
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                            Icons.monetization_on,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Service Offered",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        isExpanded: true,
                        value: _selectedservice,
                        items: _serviceofferedList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedservice = val as String;
                            displayserviceoffered.text = _selectedservice!;
                          });
                        },
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                            Icons.cleaning_services_rounded,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: displaypassword,
                        decoration: InputDecoration(
                          hintText: "Update Password",
                          errorText: _password ? null : "Password invalid",
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
                            Icons.lock,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                getTextFormField(
                  controller: _confirmpass,
                  hintName: 'Confirm Password',
                  icon: Icons.lock,
                  isObscureText: true,
                  inputType: TextInputType.name,
                  validator: _confirmPasswordValidator,
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: updateProfileData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _confirmPasswordValidator(String? _maidconfirmPassword) {
    if (_maidconfirmPassword == null || _maidconfirmPassword.trim().isEmpty) {
      return 'This field is required';
    }

    if (displaypassword.text != _confirmpass) {
      return 'Password did not match';
    }
    return null;
  }

  imagePicker() async {
    final XFile? images = await _picker.pickImage(source: ImageSource.gallery);
    if (images != null) {
      setState(() {
        imagePath = images;
        imageName = images.name.toString();
      });
    }

    var uniqueKey = firestoreRef.collection('customer').doc();
    String uploadFileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference =
        storageRef.ref().child('customer').child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath!.path));

    uploadTask.snapshotEvents.listen((event) {
      print(event.bytesTransferred.toString() +
          "\t" +
          event.totalBytes.toString());
    });

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

      if (uploadPath.isNotEmpty) {
        displayimg.text = uploadPath;
      } else {}
    });
  }
}
