import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';

class MaidEditProfile extends StatefulWidget {
  MaidEditProfile({Key? key}) : super(key: key);

  @override
  State<MaidEditProfile> createState() => _MaidEditProfileState();
}

class _MaidEditProfileState extends State<MaidEditProfile> {
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
  String? cleaningtype = '';
  String? rateperhour = '';
  String? serviceoffered = '';
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
  TextEditingController displaycleaningtype = TextEditingController();
  TextEditingController displayrateperhour = TextEditingController();
  TextEditingController displayserviceoffered = TextEditingController();
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
  final _rateperhourList = ["50.00", "70.00", "100.00", "150.00", "170.00"];
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
  String? _selectedrate = "50.00";
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
        _cleaningtype &&
        _rateperhour &&
        _serviceoffered &&
        _password) {
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
        "address": displayaddress.text.trim(),
        "postcode": displaypostcode.text.trim(),
        "city": displaycity.text.trim(),
        "state": displaystate.text.trim(),
        "cleaningtype": displaycleaningtype.text.trim(),
        "rateperhour": displayrateperhour.text.trim(),
        "serviceoffered": displayserviceoffered.text.trim(),
        "password": displaypassword.text.trim()
      }).then(
        (value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MaidProfile(),
          ),
        ),
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
                        "Cleaning Type",
                        style: TextStyle(color: Colors.black),
                      ),
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
                        "Rate per Hour",
                        style: TextStyle(color: Colors.black),
                      ),
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
                        "Service Offered",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    DropdownButtonFormField(
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
      ),
    );
  }
}
