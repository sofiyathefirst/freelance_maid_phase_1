import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/gettextformfield.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_login.dart';

class MaidUpdate extends StatefulWidget {
  MaidUpdate({Key? key}) : super(key: key);

  @override
  State<MaidUpdate> createState() => _MaidUpdateState();
}

class _MaidUpdateState extends State<MaidUpdate> {
  final _maidEmail = TextEditingController();
  final _maidPassword = TextEditingController();
  final _maidConfirmPassword = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool _email = true;
  bool _pass = true;
  bool _isObscure = true;
  bool _isObscure2 = true;

  updateEmailPass() async {
    try {
      await currentUser!.updateEmail(_maidEmail.text);
      await currentUser!.updatePassword(_maidPassword.text);
      updateProfile();
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MaidLogin(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(" Your email and password updated. Please login again!"),
          backgroundColor: Colors.amberAccent,
        ),
      );
    } catch (error) {}
  }

  Future updateProfile() async {
    setState(() {
      _maidEmail.text.isEmpty ? _email = false : _email = true;
      _maidPassword.text.isEmpty ? _pass = false : _pass = true;
    });

    if (_email && _pass) {
      FirebaseFirestore.instance
          .collection("maid")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "maidemail": _maidEmail.text.trim(),
        "password": _maidPassword.text.trim()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                builder: (context) => MaidHomePage(),
              ),
            );
          },
        ),
        title: const Text(
          "Update Email & Password",
          style: TextStyle(
            color: Colors.black,
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
              getTextFormField2(
                controller: _maidEmail,
                hintName: 'Email',
                icon: Icons.email,
                inputType: TextInputType.emailAddress,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  controller: _maidPassword,
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
                          _isObscure ? Icons.visibility_off : Icons.visibility,
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
                  controller: _maidConfirmPassword,
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
                          _isObscure2 ? Icons.visibility_off : Icons.visibility,
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
              Center(
                child: ElevatedButton(
                  onPressed: updateEmailPass,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  ),
                  child: Text(
                    'Update',
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

    if (_maidPassword.text != _maidConfirmPassword) {
      return 'Password did not match';
    }
    return null;
  }
}
