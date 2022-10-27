import 'package:flutter/material.dart';

class RegisterMaid extends StatefulWidget {
  RegisterMaid({Key? key}) : super(key: key);

  @override
  State<RegisterMaid> createState() => _RegisterMaidState();
}

class _RegisterMaidState extends State<RegisterMaid> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController secname = TextEditingController();
  final TextEditingController certid = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  bool showProgress = false;
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                            hintText: 'First name',
                            prefixIcon: const Icon(Icons.person),
                            prefixIconColor: Colors.white,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {},
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: secname,
                          decoration: InputDecoration(
                            hintText: 'Last name',
                            prefixIcon: const Icon(Icons.person),
                            prefixIconColor: Colors.white,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {},
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: mobile,
                          decoration: InputDecoration(
                            hintText: 'Phone number',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {},
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: certid,
                          decoration: InputDecoration(
                            hintText: 'Certificate ID',
                            prefixIcon:
                                const Icon(Icons.chrome_reader_mode_rounded),
                            prefixIconColor: Colors.white,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {},
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: confirmpassController,
                          obscureText: _isObscure2,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                                icon: Icon(_isObscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            hintText: 'Confirm password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (confirmpassController.text !=
                                _passwordController.text) {
                              return "Password did not match";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Checkbox(
                          checkColor: Colors.greenAccent,
                          value: this.valuefirst,
                          onChanged: (bool? value) {
                            setState(() {
                              valuefirst = value!;
                            });
                          },
                        ),
                        Text(
                          'By clicking this checkbox I am aware with the terms and policy',
                          style: TextStyle(fontSize: 17.0, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showProgress = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          ),
                          child: const Text(
                            'Sign up',
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
                            const Text('Already registered?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                            TextButton(
                              onPressed: () {
                                const CircularProgressIndicator();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterMaid(),
                                  ),
                                );
                              },
                              child: const Text('Sign in',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }
}
