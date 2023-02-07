import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/gettextformfield.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_login.dart';

class CustUpdate extends StatefulWidget {
  CustUpdate({Key? key}) : super(key: key);

  @override
  State<CustUpdate> createState() => _CustUpdateState();
}

class _CustUpdateState extends State<CustUpdate> {
  final _custEmail = TextEditingController();
  final _custPassword = TextEditingController();
  final _custConfirmPassword = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool _email = true;
  bool _pass = true;

  updateEmailPass() async {
    try {
      await currentUser!.updateEmail(_custEmail.text);
      await currentUser!.updatePassword(_custPassword.text);
      updateProfile();
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CustLogin(),
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
      _custEmail.text.isEmpty ? _email = false : _email = true;
      _custPassword.text.isEmpty ? _pass = false : _pass = true;
    });

    if (_email && _pass) {
      FirebaseFirestore.instance
          .collection("customer")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "custemail": _custEmail.text.trim(),
        "password": _custPassword.text.trim()
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
                builder: (context) => CustHomePage(),
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
                controller: _custEmail,
                hintName: 'Email',
                icon: Icons.email,
                inputType: TextInputType.emailAddress,
              ),
              getTextFormField2(
                controller: _custPassword,
                hintName: 'Password',
                icon: Icons.lock,
                isObscureText: true,
              ),
              getTextFormField(
                controller: _custConfirmPassword,
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
