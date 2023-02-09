import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_editprofile.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_update_email_pass.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:freelance_maid_phase_1/geolocation/update_cust_location.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';
import 'package:google_fonts/google_fonts.dart';

class CustProfile extends StatefulWidget {
  CustProfile({Key? key}) : super(key: key);

  @override
  State<CustProfile> createState() => _CustProfileState();
}

class _CustProfileState extends State<CustProfile> {
  String? fname = '';
  String? lname = '';
  String? pnum = '';
  String? email = '';
  String? password = '';
  String? gender = '';
  String? birthdate = '';
  String? image = '';
  String? uid = '';
  File? imageXFile;

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("customer")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          fname = snapshot.data()!['custfirstname'];
          lname = snapshot.data()!['custlastname'];
          email = snapshot.data()!['custemail'];
          pnum = snapshot.data()!['phonenum'];
          gender = snapshot.data()!['gender'];
          birthdate = snapshot.data()!['birthdate'];
          image = snapshot.data()!['image'];
          password = snapshot.data()!['password'];
          uid = snapshot.data()!['uid'];
        });
      }
    });
  }

  Future _delete() async {
    await FirebaseFirestore.instance
        .collection("customer")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete()
        .then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen2(),
            ),
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Delete Succesful'),
      ),
    );
  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustHomePage(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Receipt(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustProfile(),
          ),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CustHomePage(),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashScreen2(),
                ),
              );
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Book",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 500,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          backgroundImage: imageXFile == null
                              ? NetworkImage(image!)
                              : Image.file(imageXFile!).image,
                          radius: 65,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Text(fname! + '\t' + lname!,
                            style: GoogleFonts.heebo(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Text(pnum!,
                            style: GoogleFonts.heebo(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.alternate_email,
                          color: Colors.black,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Text(email!,
                            style: GoogleFonts.heebo(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.male,
                          color: Colors.black,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Text(gender!,
                            style: GoogleFonts.heebo(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Text(birthdate!,
                            style: GoogleFonts.heebo(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 500,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Click button below to edit your profile",
                        style: GoogleFonts.heebo(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustEditProfile(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Click button below to update your Email & Password",
                        style: GoogleFonts.heebo(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustUpdate(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(),
                      child: Text(
                        'Update Email & Password',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                //height: 500,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Are you sure you want to delete your account?",
                        style: GoogleFonts.heebo(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: _delete,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
