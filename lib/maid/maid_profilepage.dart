import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/geolocation/update_maid_location.dart';
import 'package:freelance_maid_phase_1/maid/maid_editprofile.dart';
import 'package:freelance_maid_phase_1/maid/maid_homepage.dart';
import 'package:freelance_maid_phase_1/maid/maid_update_email_pass.dart';
import 'package:freelance_maid_phase_1/splash_screen_2.dart';

class MaidProfile extends StatefulWidget {
  MaidProfile({Key? key}) : super(key: key);

  @override
  State<MaidProfile> createState() => _MaidProfileState();
}

class _MaidProfileState extends State<MaidProfile> {
  String? fname = '';
  String? lname = '';
  String? pnum = '';
  String? email = '';
  String? password = '';
  String? gender = '';
  String? birthdate = '';
  String? address = '';
  String? image = '';
  String? cleaningtype = '';
  String? rateperhour;
  String? serviceoffered = '';
  File? imageXFile;

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("maid")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          fname = snapshot.data()!['maidfirstname'];
          lname = snapshot.data()!['maidlastname'];
          email = snapshot.data()!['maidemail'];
          pnum = snapshot.data()!['phonenum'];
          gender = snapshot.data()!['gender'];
          birthdate = snapshot.data()!['birthdate'];
          image = snapshot.data()!['image'];
          cleaningtype = snapshot.data()!['cleaningtype'];
          rateperhour = snapshot.data()!['rateperhour'];
          serviceoffered = snapshot.data()!['serviceoffered'];
          password = snapshot.data()!['password'];
        });
      }
    });
  }

  Future _delete() async {
    await FirebaseFirestore.instance
        .collection("maid")
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

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MaidHomePage(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateMaidLocation(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            ),
            child: Text(
              'Update Location',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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
                        backgroundColor: Colors.green[200],
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
                      Text(
                        fname! + '\t' + lname!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: Colors.black,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        pnum!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      Text(
                        email!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.cleaning_services_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        cleaningtype!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.cleaning_services_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          serviceoffered!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.cleaning_services_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        rateperhour!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.accessibility,
                        color: Colors.black,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        gender!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      Text(
                        birthdate!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  /*SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.house,
                        color: Colors.black,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        address!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),*/
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MaidEditProfile(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: _delete,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          ),
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MaidUpdate(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          ),
                          child: Text(
                            'Update Email \n & Password',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SplashScreen2(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
