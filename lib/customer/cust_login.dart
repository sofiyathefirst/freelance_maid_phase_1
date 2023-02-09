import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/gettextformfield.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_register.dart';
import 'package:google_fonts/google_fonts.dart';

class CustLogin extends StatefulWidget {
  CustLogin({Key? key}) : super(key: key);

  @override
  State<CustLogin> createState() => _CustLoginState();
}

class _CustLoginState extends State<CustLogin> {
  final _custEmail = TextEditingController();
  final _custPassword = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _custEmail.dispose();
    _custPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future signIn() async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _custEmail.text.trim(),
            password: _custPassword.text.trim(),
          )
          .then((user) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CustHomePage())))
          .catchError((e) {
        print(e);
      });
    }

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
              Text('Sign in',
                  style: GoogleFonts.heebo(
                    textStyle: TextStyle(
                      fontSize: 40,
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
                icon: Icons.person,
                inputType: TextInputType.emailAddress,
                validator: _requiredValidator,
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    shadowColor: Colors.cyanAccent),
                child: Text('Sign in',
                    style: GoogleFonts.heebo(
                      textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
                onPressed: signIn,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New User?',
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
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text('Sign Up',
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
