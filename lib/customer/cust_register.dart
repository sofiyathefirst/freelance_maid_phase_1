import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/gettextformfield.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_login.dart';
import 'package:freelance_maid_phase_1/database/auth.dart';
import 'package:freelance_maid_phase_1/geolocation/get_location.dart';
import 'package:freelance_maid_phase_1/geolocation/try_maps.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  _RegisterPageState();

  final _formKey = new GlobalKey<FormState>();
  CollectionReference ref = FirebaseFirestore.instance.collection('customer');
  final _custEmail = TextEditingController();
  final _custFirstName = TextEditingController();
  final _custLastName = TextEditingController();
  final _custgender = TextEditingController();
  final _custphonenum = TextEditingController();
  final _custPassword = TextEditingController();
  final _custConfirmPassword = TextEditingController();
  final _custbirthdate = TextEditingController();
  String? _selectedgender = "Male";
  final _genderList = ["Male", "Female"];
  bool _isObscure = true;
  bool _isObscure2 = true;

  bool showProgress = false;

  Future signUp() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: _custEmail.text.trim(),
          password: _custPassword.text.trim(),
        )
        .then((value) => {
              FirebaseFirestore.instance
                  .collection('customer')
                  .doc(value.user!.uid)
                  .set({
                'custemail': _custEmail.text.trim(),
                'custfirstname': _custFirstName.text.trim(),
                'custlastname': _custLastName.text.trim(),
                'password': _custPassword.text.trim(),
                'image':
                    'https://firebasestorage.googleapis.com/v0/b/freelancemaid-8de13.appspot.com/o/dummyprofile.jpg?alt=media&token=86896df5-3e37-471e-9845-2f97ec3427ab',
                'phonenum': _custphonenum.text.trim(),
                'gender': _custgender.text.trim(),
                'birthdate': _custbirthdate.text.trim(),
                'uid': value.user!.uid,
              }).catchError((e) {
                print(e);
                SnackBar snackbar = SnackBar(content: Text(e));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              })
            })
        .then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserLocation(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Sign Up',
                      style: GoogleFonts.heebo(
                        textStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Please Fill In All Field',
                      style: GoogleFonts.heebo(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  getTextFormField(
                    controller: _custEmail,
                    hintName: 'Email',
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    validator: _requiredValidator,
                  ),
                  getTextFormField(
                    controller: _custFirstName,
                    hintName: 'First Name',
                    icon: Icons.person,
                    inputType: TextInputType.name,
                    validator: _requiredValidator,
                  ),
                  getTextFormField(
                    controller: _custLastName,
                    hintName: 'Last Name',
                    icon: Icons.person,
                    inputType: TextInputType.name,
                    validator: _requiredValidator,
                  ),
                  getTextFormField(
                    controller: _custphonenum,
                    hintName: 'Phone Number',
                    icon: Icons.phone,
                    inputType: TextInputType.phone,
                    validator: _requiredValidator,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
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
                              _custgender.text = _selectedgender!;
                            });
                          },
                          style: GoogleFonts.heebo(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Choose Gender',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black),
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
                            controller: _custbirthdate,
                            decoration: InputDecoration(
                              labelText: 'Enter Birth Date',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black),
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
                                      1950), //DateTime.now() - not to allow to choose before today.
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
                                  _custbirthdate.text =
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _custPassword,
                      obscureText: _isObscure,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 3.0),
                        ),
                        prefixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: _requiredValidator,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _custConfirmPassword,
                      obscureText: _isObscure2,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 3.0),
                        ),
                        prefixIcon: IconButton(
                            icon: Icon(
                              _isObscure2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure2 = !_isObscure2;
                              });
                            }),
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: _confirmPasswordValidator,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        shadowColor: Colors.cyanAccent),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.heebo(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already registered',
                          style: GoogleFonts.heebo(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustLogin(),
                            ),
                          );
                        },
                        child: Text('Sign In',
                            style: GoogleFonts.heebo(
                              textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent[400],
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }

  String? _requiredValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? _custconfirmPassword) {
    if (_custconfirmPassword == null || _custconfirmPassword.trim().isEmpty) {
      return 'This field is required';
    }

    if (_custPassword.text != _custConfirmPassword) {
      return 'Password did not match';
    }
    return null;
  }
}
