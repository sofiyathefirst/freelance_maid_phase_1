import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class getTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData icon;
  bool isObscureText;
  TextInputType inputType;
  bool isEnable;
  FormFieldValidator<String>? validator;

  getTextFormField({
    required this.controller,
    required this.hintName,
    required this.icon,
    this.isObscureText = false,
    this.inputType = TextInputType.text,
    this.isEnable = true,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        keyboardType: inputType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.deepPurple, width: 3.0),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hintName,
          hintStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}

class getTextFormField2 extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData icon;
  bool isObscureText;
  TextInputType inputType;
  bool isEnable;

  getTextFormField2({
    required this.controller,
    required this.hintName,
    required this.icon,
    this.isObscureText = false,
    this.inputType = TextInputType.text,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        keyboardType: inputType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.deepPurple, width: 3.0),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hintName,
          hintStyle: TextStyle(color: Colors.black),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
