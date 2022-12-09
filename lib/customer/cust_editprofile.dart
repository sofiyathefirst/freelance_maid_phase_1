import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';

class CustEditProfile extends StatefulWidget {
  CustEditProfile({Key? key}) : super(key: key);

  @override
  State<CustEditProfile> createState() => _CustEditProfileState();
}

class _CustEditProfileState extends State<CustEditProfile> {
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
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
  File? imageXFile;
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
          birthdate = snapshot.data()!['birthdate'];
          image = snapshot.data()!['image'];
          address = snapshot.data()!['address'];
          city = snapshot.data()!['city'];
          postcode = snapshot.data()!['postcode'];
          state = snapshot.data()!['state'];
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
        displaypassword.text = password!;
      }
    });
  }

  Future updateProfileData() async {
    setState(() {
      displayfname.text.isEmpty ? _fname = false : _fname = true;
      displaylname.text.isEmpty ? _lname = false : _lname = true;
      displaypnum.text.isEmpty ? _pnum = false : _pnum = true;
      displayemail.text.isEmpty ? _email = false : _email = true;
      displaygender.text.isEmpty ? _gender = false : _gender = true;
      displaybirthdate.text.isEmpty ? _birthdate = false : _birthdate = true;
      displayaddress.text.isEmpty ? _address = false : _address = true;
      displaypostcode.text.isEmpty ? _postcode = false : _postcode = true;
      displaycity.text.isEmpty ? _city = false : _city = true;
      displaystate.text.isEmpty ? _state = false : _state = true;
      displaypassword.text.isEmpty ? _password = false : _password = true;
    });

    if (_fname &&
        _lname &&
        _pnum &&
        _email &&
        _gender &&
        _birthdate &&
        _address &&
        _postcode &&
        _city &&
        _state &&
        _password) {
      FirebaseFirestore.instance
          .collection("customer")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "custfirstname": displayfname.text.trim(),
        "custlastname": displaylname.text.trim(),
        "custemail": displayemail.text.trim(),
        "phonenum": displaypnum.text.trim(),
        "gender": displaygender.text.trim(),
        "birthdate": displaybirthdate.text.trim(),
        "address": displayaddress.text.trim(),
        "postcode": displaypostcode.text.trim(),
        "city": displaycity.text.trim(),
        "state": displaystate.text.trim(),
        "password": displaypassword.text.trim()
      }).then(
        (value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustProfile(),
          ),
        ),
      );
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "First Name",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displayfname,
                    decoration: InputDecoration(
                        hintText: "Update First Name",
                        errorText: _fname ? null : "First Name invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Last Name",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displaylname,
                    decoration: InputDecoration(
                        hintText: "Update Last Name",
                        errorText: _lname ? null : "Last Name invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Phone Number",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displaypnum,
                    decoration: InputDecoration(
                        hintText: "Update Phone Number",
                        errorText: _pnum ? null : "Phone Number invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Email",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displayemail,
                    decoration: InputDecoration(
                        hintText: "Update Email",
                        errorText: _email ? null : "Email invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Gender",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displaygender,
                    decoration: InputDecoration(
                        hintText: "Update Gender",
                        errorText: _gender ? null : "Gender invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Birth Date",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displaybirthdate,
                    decoration: InputDecoration(
                        hintText: "Update Birthdate",
                        errorText: _birthdate ? null : "Birthdate invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Address",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displayaddress,
                    decoration: InputDecoration(
                        hintText: "Update Address",
                        errorText: _address ? null : "Address invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Postcode",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displaypostcode,
                    decoration: InputDecoration(
                        hintText: "Update Postcode",
                        errorText: _postcode ? null : "Postcode invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "City",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displaycity,
                    decoration: InputDecoration(
                        hintText: "Update City",
                        errorText: _city ? null : "City invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "State",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displaystate,
                    decoration: InputDecoration(
                        hintText: "Update State",
                        errorText: _state ? null : "State invalid"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Password",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextField(
                    controller: displaypassword,
                    decoration: InputDecoration(
                        hintText: "Update Password",
                        errorText: _password ? null : "Password invalid"),
                  ),
                ],
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
    );
  }
}
