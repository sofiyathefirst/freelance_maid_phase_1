import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/maid/maid_profilepage.dart';

class MaidHomePage extends StatefulWidget {
  MaidHomePage({Key? key}) : super(key: key);

  @override
  State<MaidHomePage> createState() => _MaidHomePageState();
}

class _MaidHomePageState extends State<MaidHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Home Page",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MaidProfile(),
                ),
              );
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
