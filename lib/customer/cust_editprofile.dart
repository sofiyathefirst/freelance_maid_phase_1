import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CustEditProfile extends StatefulWidget {
  CustEditProfile({Key? key}) : super(key: key);

  @override
  State<CustEditProfile> createState() => _CustEditProfileState();
}

class _CustEditProfileState extends State<CustEditProfile> {
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
  String imageName = '';
  String? password = '';
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
  String? _selectedgender = "Male";
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
          pnum = snapshot.data()!['phonenum'];
          gender = snapshot.data()!['gender'];
          birthdate = snapshot.data()!['birthdate'];
          image = snapshot.data()!['image'];
          address = snapshot.data()!['address'];
          city = snapshot.data()!['city'];
          postcode = snapshot.data()!['postcode'];
          state = snapshot.data()!['state'];
        });
        displayfname.text = fname!;
        displaylname.text = lname!;
        displaypnum.text = pnum!;
        displayimg.text = image!;
        displaygender.text = gender!;
        displaybirthdate.text = birthdate!;
        displayaddress.text = address!;
        displaycity.text = city!;
        displaypostcode.text = postcode!;
        displaystate.text = state!;
      }
    });
  }

  Future updateProfileData() async {
    setState(() {
      displayfname.text.isEmpty ? _fname = false : _fname = true;
      displaylname.text.isEmpty ? _lname = false : _lname = true;
      displaypnum.text.isEmpty ? _pnum = false : _pnum = true;
      displaygender.text.isEmpty ? _gender = false : _gender = true;
      displaybirthdate.text.isEmpty ? _birthdate = false : _birthdate = true;
      displayimg.text.isEmpty ? _image = false : _image = true;
      displayaddress.text.isEmpty ? _address = false : _address = true;
      displaypostcode.text.isEmpty ? _postcode = false : _postcode = true;
      displaycity.text.isEmpty ? _city = false : _city = true;
      displaystate.text.isEmpty ? _state = false : _state = true;
    });

    if (_image &&
        _fname &&
        _lname &&
        _pnum &&
        _gender &&
        _birthdate &&
        _address &&
        _postcode &&
        _city &&
        _state) {
      FirebaseFirestore.instance
          .collection("customer")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "custfirstname": displayfname.text.trim(),
        "custlastname": displaylname.text.trim(),
        "phonenum": displaypnum.text.trim(),
        "gender": displaygender.text.trim(),
        "birthdate": displaybirthdate.text.trim(),
        "image": displayimg.text.trim(),
        "address": displayaddress.text.trim(),
        "postcode": displaypostcode.text.trim(),
        "city": displaycity.text.trim(),
        "state": displaystate.text.trim(),
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
              imageName == "" ? Container() : Text("${imageName}"),
              OutlinedButton(
                  onPressed: () {
                    imagePicker();
                  },
                  child: Text("Select Image")),
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: displaybirthdate,
                          decoration: InputDecoration(
                            hintText: 'Update Birthdate',
                            errorText: _birthdate ? null : "Birthdate invalid",
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
                                firstDate: DateTime(
                                    1900), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2025));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
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
