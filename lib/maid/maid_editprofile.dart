import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/gettextformfield.dart';
import 'package:freelance_maid_phase_1/geolocation/update_maid_location.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';
import 'package:google_fonts/google_fonts.dart';
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
  TextEditingController displaypassword = TextEditingController();
  TextEditingController displaycleaningtype = TextEditingController();
  TextEditingController displayrateperhour = TextEditingController();
  TextEditingController displayserviceoffered = TextEditingController();

  final _genderList = ["Male", "Female"];

  final _cleaningtypeList = [
    "Deep Cleaning",
    "Disinfection Services",
    "Gardening",
    "House Cleaning",
    "Office Cleaning",
    "Post Renovation"
  ];
  final _rateperhourList = [
    "50",
    "70",
    "100",
    "150",
    "170",
    "200",
    "250",
    "270",
    "300"
  ];
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

  bool _fname = true;
  bool _lname = true;
  bool _pnum = true;
  bool _email = true;
  bool _gender = true;
  bool _birthdate = true;
  bool _address = true;
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
          pnum = snapshot.data()!['phonenum'];
          gender = snapshot.data()!['gender'];
          birthdate = snapshot.data()!['birthdate'];
          image = snapshot.data()!['image'];
          address = snapshot.data()!['address'];
          cleaningtype = snapshot.data()!['cleaningtype'];
          rateperhour = snapshot.data()!['rateperhour'];
          serviceoffered = snapshot.data()!['serviceoffered'];
        });
        displayfname.text = fname!;
        displaylname.text = lname!;
        displaypnum.text = pnum!;
        displayimg.text = image!;
        displaygender.text = gender!;
        displaybirthdate.text = birthdate!;
        displaycleaningtype.text = cleaningtype!;
        displayrateperhour.text = rateperhour!;
        displayserviceoffered.text = serviceoffered!;
      }
    });
  }

  Future updateProfileData() async {
    setState(() {
      displayfname.text.isEmpty ? _fname = false : _fname = true;
      displaylname.text.isEmpty ? _lname = false : _lname = true;
      displaypnum.text.isEmpty ? _pnum = false : _pnum = true;
      displayimg.text.isEmpty ? _image = false : _image = true;
      displaygender.text.isEmpty ? _gender = false : _gender = true;
      displaybirthdate.text.isEmpty ? _birthdate = false : _birthdate = true;

      displaycleaningtype.text.isEmpty
          ? _cleaningtype = false
          : _cleaningtype = true;
      displayrateperhour.text.isEmpty
          ? _rateperhour = false
          : _rateperhour = true;
      displayserviceoffered.text.isEmpty
          ? _serviceoffered = false
          : _serviceoffered = true;
    });

    if (_image &&
        _fname &&
        _lname &&
        _pnum &&
        _gender &&
        _birthdate &&
        _cleaningtype &&
        _rateperhour &&
        _serviceoffered) {
      FirebaseFirestore.instance
          .collection("maid")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "maidfirstname": displayfname.text.trim(),
        "maidlastname": displaylname.text.trim(),
        "phonenum": displaypnum.text.trim(),
        "gender": displaygender.text.trim(),
        "birthdate": displaybirthdate.text.trim(),
        "image": displayimg.text.trim(),
        "cleaningtype": displaycleaningtype.text.trim(),
        "rateperhour": displayrateperhour.text.trim(),
        "serviceoffered": displayserviceoffered.text.trim(),
      }).then(
        (value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MaidProfile(),
          ),
        ),
      );
      SnackBar snackbar = const SnackBar(
        content: Text("Profile Updated!"),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
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
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 500,
                  padding: const EdgeInsets.all(20),
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
                        child: Text(
                          "Select Image",
                          style: GoogleFonts.heebo(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: displayfname,
                            decoration: InputDecoration(
                              hintText: "Update First Name",
                              errorText: _fname ? null : "First Name invalid",
                              labelText: 'First Name',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: displaylname,
                            decoration: InputDecoration(
                              hintText: "Update Last Name",
                              errorText: _lname ? null : "Last Name invalid",
                              labelText: 'Last Name',
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
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: displaypnum,
                            decoration: InputDecoration(
                              hintText: "Update Phone Number",
                              errorText: _pnum ? null : "Phone Number invalid",
                              labelText: 'Phone Number',
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
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Cleaning Type',
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
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                              labelText: 'Gender',
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
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                    labelText: 'Birth Date',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.deepPurple.shade200,
                                          width: 3.0),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
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
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                              labelText: 'Rate per 2 Hour',
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
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                              labelText: 'Service Offered',
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
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: updateProfileData,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shadowColor: Colors.cyanAccent),
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 500,
                  padding: const EdgeInsets.all(20),
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
                    children: [
                      Text("Click button below to update your location",
                          style: GoogleFonts.heebo(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          textAlign: TextAlign.center),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateMaidLocation(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(),
                        child: Text(
                          'Update My Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
