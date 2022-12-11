import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/customer/cust_homepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_profilepage.dart';
import 'package:freelance_maid_phase_1/customer/cust_review.dart';
import 'package:freelance_maid_phase_1/customer/custreceipt.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

class Custbooking extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  const Custbooking({Key? key, this.data}) : super(key: key);

  @override
  State<Custbooking> createState() => _CustbookingState();
}

class _CustbookingState extends State<Custbooking> {
  final _formKey = GlobalKey<FormState>();
  final dropdownState = GlobalKey<FormFieldState>();

  final TextEditingController date = TextEditingController();
  final TextEditingController timestart = TextEditingController();
  final TextEditingController timeend = TextEditingController();
  final TextEditingController hour = TextEditingController();

  late String maidfname = widget.data!.get('maidfirstname');
  late String maidlname = widget.data!.get('maidlastname');
  late String maidpnum = widget.data!.get('phonenum');
  late String maidemail = widget.data!.get('maidemail');
  late String maidgender = widget.data!.get('gender');
  late String maidstate = widget.data!.get('state');

  late String? fname = '';
  late String? lname = '';
  late String? pnum = '';
  late String? email = '';
  late String? gender = '';
  late String? address = '';
  late String? city = '';
  late String? postcode = '';
  late String? state = '';
  //String? image = '';
  var currentUser = FirebaseAuth.instance.currentUser?.uid;

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
          //image = snapshot.data()!['image'];
          address = snapshot.data()!['address'];
          city = snapshot.data()!['city'];
          postcode = snapshot.data()!['postcode'];
          state = snapshot.data()!['state'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference bookingmaid =
        FirebaseFirestore.instance.collection('bookingmaid');
    Add(
        String maidfname,
        String maidlname,
        String maidpnum,
        String maidemail,
        String maidgender,
        String maidstate,
        String fname,
        String lname,
        String pnum,
        String email,
        String gender,
        String address,
        String city,
        String postcode,
        String state,
        String date,
        String timestart,
        String timeend,
        String hour,
        var uid) {
      try {
        return bookingmaid.add({
          'maidfirstname': maidfname,
          'maidlastname': maidlname,
          'maidpnum': maidpnum,
          'maidemail': maidemail,
          'maidgender': maidgender,
          'maidstate': maidstate,
          'custfirstname': fname,
          'cuslastname': lname,
          'custpnum': pnum,
          'custemail': email,
          'custgender': gender,
          'custaddress': address,
          'custcity': city,
          'custpostcode': postcode,
          'custstate': state,
          'bookingdate': date,
          'timestart': timestart,
          'timeend': timeend,
          'hour': hour,
          'uid': uid,
        }).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking Succesful'),
            ),
          ),
        );
      } on FirebaseException catch (e) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.code),
        ));
      }
    }

    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustHomePage(),
              ),
            );
          },
        ),
        title: const Text(
          "Booking",
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
        gap: 2,
        tabs: [
          GButton(
            icon: Icons.home_rounded,
            text: "Home",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CustHomePage(),
                ),
              );
            },
          ),
          GButton(
            icon: Icons.receipt_rounded,
            text: "Receipt",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Receipt(),
                ),
              );
            },
          ),
          GButton(
            icon: Icons.book_online_rounded,
            text: "Booking",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Custbooking(),
                ),
              );
            },
          ),
          GButton(
            icon: Icons.reviews_rounded,
            text: "Review",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Review(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Maid Name: $maidfname\t$maidlname',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Maid Phone Number: $maidpnum',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Maid Gender:' + maidgender,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Maid Email:' + maidemail,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Maid State:' + maidstate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Cust Name: $fname\t$lname',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Cust Phone Number: $pnum',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Cust Email: $email',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Cust Gender: $gender',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Cust Address: $address',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Cust State: $state',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Cust Postcode: $postcode',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Cust City: $city',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      ' Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: date,
                          decoration: InputDecoration(
                            hintText: 'Enter your date',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime
                                    .now(), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2025));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                date.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: timestart,
                    decoration: InputDecoration(
                      hintText: 'Enter time start',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: timeend,
                    decoration: InputDecoration(
                      hintText: 'Enter time end',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: hour,
                    decoration: InputDecoration(
                      hintText: 'Enter duration (hour)',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(
                            () {},
                          );
                          Add(
                              maidfname,
                              maidlname,
                              maidpnum,
                              maidemail,
                              maidgender,
                              maidstate,
                              fname ?? "null",
                              lname ?? "null",
                              pnum ?? "null",
                              email ?? "null",
                              gender ?? "null",
                              address ?? "null",
                              city ?? "null",
                              postcode ?? "null",
                              state ?? "null",
                              date.text,
                              timestart.text,
                              timeend.text,
                              hour.text,
                              currentUser);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Receipt(),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orangeAccent),
                      ),
                      child: const Text(
                        'Book',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
