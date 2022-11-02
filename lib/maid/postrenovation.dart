import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Postrenovation extends StatefulWidget {
  Postrenovation({Key? key}) : super(key: key);

  @override
  State<Postrenovation> createState() => _PostrenovationState();
}

class _PostrenovationState extends State<Postrenovation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Post Renovation",
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
                  builder: (context) => CustProfile(),
                ),
              );
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        tabBackgroundColor: Colors.grey.shade400,
        gap: 8,
        tabs: [
          GButton(icon: Icons.home_rounded, text: "Home"),
          GButton(icon: Icons.receipt_rounded, text: "Receipt"),
          GButton(icon: Icons.book_online_rounded, text: "Booking"),
          GButton(icon: Icons.reviews_rounded, text: "Review"),
        ],
      ),
    );
  }
}
