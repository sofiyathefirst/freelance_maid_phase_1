import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_register.dart';

import '../common method/gettextformfield.dart';

class MaidLogin extends StatefulWidget {
  MaidLogin({Key? key}) : super(key: key);

  @override
  State<MaidLogin> createState() => _MaidLoginState();
}

class _MaidLoginState extends State<MaidLogin> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  bool _isObsecure3 = true;
  bool visible = false;
  final _maidemail = TextEditingController();
  final _maidpassword = TextEditingController();

  @override
  void dispose() {
    _maidemail.dispose();
    _maidpassword.dispose();

    super.dispose();
  }

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: _maidemail.text.trim(),
          password: _maidpassword.text.trim(),
        )
        .then((user) => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MaidHomePage())))
        .catchError((e) {
      print(e);
    });
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
                'Sign in',
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
                hintName: 'Email',
                icon: Icons.person,
                inputType: TextInputType.emailAddress,
                validator: _requiredValidator,
              ),
              getTextFormField(
                controller: _maidpassword,
                hintName: 'Password',
                icon: Icons.lock,
                isObscureText: true,
                validator: _requiredValidator,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: signIn,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not registered yet?',
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
                          builder: (context) => RegisterMaid(),
                        ),
                      );
                    },
                    child: const Text('Sign Up',
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
}
