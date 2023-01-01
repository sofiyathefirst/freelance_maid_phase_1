import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/gettextformfield.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_login.dart';
import 'package:freelance_maid_phase_1/database/auth.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  _RegisterPageState();

  final _formKey = new GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('customer');
  final _custEmail = TextEditingController();
  final _custFirstName = TextEditingController();
  final _custLastName = TextEditingController();
  final _custPassword = TextEditingController();
  final _custConfirmPassword = TextEditingController();

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
                'phonenum': 'XXX-XXXXXXX',
                'address': 'address',
                'postcode': 'postcode',
                'city': 'city',
                'state': 'state',
                'gender': 'gender',
                'birthdate': 'DD/MM/YYYY',
                'uid': value.user!.uid,
              }).catchError((e) {
                print(e);
              })
            })
        .then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustHomePage(),
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
                  Text(
                    '*Please update your profile information after Login at the top right side in your homepage',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
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
                              builder: (context) => CustLogin(),
                            ),
                          );
                        },
                        child: const Text('Sign In',
                            style:
                                TextStyle(color: Colors.green, fontSize: 20)),
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
