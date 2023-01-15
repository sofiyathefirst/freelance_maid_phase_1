import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_login.dart';
import 'package:intl/intl.dart';

import '../common method/gettextformfield.dart';

class RegisterMaid extends StatefulWidget {
  RegisterMaid({Key? key}) : super(key: key);

  @override
  State<RegisterMaid> createState() => _RegisterMaidState();
}

class _RegisterMaidState extends State<RegisterMaid> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference ref = FirebaseFirestore.instance.collection('maid');
  final _maidfname = TextEditingController();
  final _maidlname = TextEditingController();
  final _maidaddress = TextEditingController();
  final _maidcity = TextEditingController();
  final _maidstate = TextEditingController();
  final _maidpostcode = TextEditingController();
  final _maidbirthdate = TextEditingController();
  final _maidgender = TextEditingController();
  final _password = TextEditingController();
  final _confirmpass = TextEditingController();
  final _maidemail = TextEditingController();
  final _maidpnum = TextEditingController();
  String? _selectedgender = "Male";
  String? _selectedpostcode = "75000";
  String? _selectedcity = "Alor Gajah";
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

  bool showProgress = false;

  Future signUp() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: _maidemail.text.trim(),
          password: _password.text.trim(),
        )
        .then((value) => {
              FirebaseFirestore.instance
                  .collection('maid')
                  .doc(value.user!.uid)
                  .set({
                'maidemail': _maidemail.text.trim(),
                'maidfirstname': _maidfname.text.trim(),
                'maidlastname': _maidlname.text.trim(),
                'password': _password.text.trim(),
                'image':
                    'https://firebasestorage.googleapis.com/v0/b/freelancemaid-8de13.appspot.com/o/dummyprofile.jpg?alt=media&token=86896df5-3e37-471e-9845-2f97ec3427ab',
                'phonenum': _maidpnum.text.trim(),
                'address': _maidaddress.text.trim(),
                'postcode': _maidpostcode.text.trim(),
                'city': _maidcity.text.trim(),
                'state': _maidstate.text.trim(),
                'gender': _maidgender.text.trim(),
                'cleaningtype': 'cleaningtype',
                'birthdate': _maidbirthdate.text.trim(),
                'rateperhour': 'RM50',
                'serviceoffered': 'choose',
                'uid': value.user!.uid
              }).catchError((e) {
                print(e);
              })
            })
        .then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MaidHomePage(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
              Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/Logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                'Maid Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              getTextFormField(
                controller: _maidemail,
                hintName: 'Maid Email',
                icon: Icons.email,
                inputType: TextInputType.emailAddress,
                validator: _requiredValidator,
              ),
              getTextFormField(
                controller: _maidfname,
                hintName: 'First Name',
                icon: Icons.person,
                inputType: TextInputType.name,
                validator: _requiredValidator,
              ),
              getTextFormField(
                controller: _maidlname,
                hintName: 'Last Name',
                icon: Icons.person,
                inputType: TextInputType.name,
                validator: _requiredValidator,
              ),
              getTextFormField(
                controller: _maidpnum,
                hintName: 'Phone Number',
                icon: Icons.phone,
                inputType: TextInputType.phone,
                validator: _requiredValidator,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "Gender",
                        style: TextStyle(
                            color: Colors.white,
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
                          _maidgender.text = _selectedgender!;
                        });
                      },
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Colors.green.shade200, width: 3.0),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        hintText: 'Gender',
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _maidbirthdate,
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
                          hintText: 'Enter your birthdate',
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
                              firstDate: DateTime(
                                  1900), //DateTime.now() - not to allow to choose before today.
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
                              _maidbirthdate.text =
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
              getTextFormField(
                controller: _maidaddress,
                hintName: 'Address',
                icon: Icons.home,
                inputType: TextInputType.name,
                validator: _requiredValidator,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "Postcode",
                        style: TextStyle(
                            color: Colors.white,
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
                          _maidpostcode.text = _selectedpostcode!;
                        });
                      },
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Colors.green.shade200, width: 3.0),
                        ),
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        hintText: "Enter Postcode",
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "City",
                        style: TextStyle(
                            color: Colors.white,
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
                          _maidcity.text = _selectedcity!;
                        });
                      },
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Colors.green.shade200, width: 3.0),
                        ),
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.black,
                        ),
                        hintText: 'Enter City',
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              getTextFormField(
                controller: _maidstate,
                hintName: 'State',
                icon: Icons.location_on,
                inputType: TextInputType.name,
                validator: _requiredValidator,
              ),
              getTextFormField(
                controller: _password,
                hintName: 'Password',
                icon: Icons.lock,
                isObscureText: true,
                inputType: TextInputType.name,
                validator: _requiredValidator,
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
                height: 20,
              ),
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already registered',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaidLogin(),
                        ),
                      );
                    },
                    child: const Text('Sign In',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? _maidconfirmPassword) {
    if (_maidconfirmPassword == null || _maidconfirmPassword.trim().isEmpty) {
      return 'This field is required';
    }

    if (_password.text != _confirmpass) {
      return 'Password did not match';
    }
    return null;
  }
}
