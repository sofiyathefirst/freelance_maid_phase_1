import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_login.dart';

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
  final _certid = TextEditingController();
  final _password = TextEditingController();
  final _confirmpass = TextEditingController();
  final _maidemail = TextEditingController();
  final _maidpnum = TextEditingController();
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
                'maidid': _certid.text.trim(),
                'password': _password.text.trim(),
                'image': 'image',
                'phonenum': _maidpnum.text.trim(),
                'address': 'address',
                'postcode': 'postcode',
                'city': 'city',
                'state': 'state',
                'gender': 'gender',
                'birthdate': 'DD/MM/YYYY',
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
      backgroundColor: Colors.grey.shade600,
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
                controller: _certid,
                hintName: 'Cert Id',
                icon: Icons.person,
                inputType: TextInputType.name,
                validator: _requiredValidator,
              ),
              getTextFormField(
                controller: _maidemail,
                hintName: 'Maid Email',
                icon: Icons.email,
                inputType: TextInputType.name,
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
                inputType: TextInputType.name,
                validator: _requiredValidator,
              ),
              getTextFormField(
                controller: _password,
                hintName: 'Password',
                icon: Icons.lock,
                inputType: TextInputType.name,
                validator: _requiredValidator,
              ),
              getTextFormField(
                controller: _confirmpass,
                hintName: 'Confirm Password',
                icon: Icons.person,
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
                      style: TextStyle(color: Colors.white, fontSize: 20)),
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
                        style: TextStyle(color: Colors.green, fontSize: 20)),
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

  String? _confirmPasswordValidator(String? _custconfirmPassword) {
    if (_custconfirmPassword == null || _custconfirmPassword.trim().isEmpty) {
      return 'This field is required';
    }

    if (_password.text != _confirmpass) {
      return 'Password did not match';
    }
    return null;
  }
}
