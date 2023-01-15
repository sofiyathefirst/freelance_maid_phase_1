import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/gettextformfield.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_login.dart';
import 'package:freelance_maid_phase_1/database/auth.dart';
import 'package:freelance_maid_phase_1/geolocation/try_maps.dart';
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
              })
            })
        .then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Maps(),
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
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
                              _custgender.text = _selectedgender!;
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
                  getTextFormField(
                    controller: _custPassword,
                    hintName: 'Password',
                    icon: Icons.lock,
                    isObscureText: true,
                    validator: _requiredValidator,
                  ),
                  getTextFormField(
                    controller: _custConfirmPassword,
                    hintName: 'Confirm Password',
                    icon: Icons.lock,
                    isObscureText: true,
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
                              builder: (context) => CustLogin(),
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
