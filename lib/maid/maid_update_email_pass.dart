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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
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
              getTextFormField2(
                controller: _maidEmail,
                hintName: 'Email',
                icon: Icons.email,
                inputType: TextInputType.emailAddress,
              ),
              getTextFormField2(
                controller: _maidPassword,
                hintName: 'Password',
                icon: Icons.lock,
                isObscureText: true,
              ),
              getTextFormField(
                controller: _maidConfirmPassword,
                hintName: 'Confirm Password',
                icon: Icons.lock,
                isObscureText: true,
                validator: _confirmPasswordValidator,
              ),
              const SizedBox(
                height: 25,
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
