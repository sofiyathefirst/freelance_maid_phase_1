import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custreceipt.dart';

const TIME_SLOTS = [
  '8:00 am - 10:00 am',
  '12:00 pm - 2:00 pm',
  '4:00 pm - 6:00 pm',
  '8:00 pm - 10:00 pm'
];

class PickDate2 extends StatefulWidget {
  PickDate2({Key? key}) : super(key: key);

  @override
  State<PickDate2> createState() => _PickDate2State();
}

class _PickDate2State extends State<PickDate2> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  String selectedTime = '';
  String dates = '';
  final _bookdate = TextEditingController();

  CollectionReference bookingmaid =
      FirebaseFirestore.instance.collection('timeslott');
  Add(
    String date,
    String timeslot,
  ) {
    try {
      return bookingmaid.add({
        'bookingdate': dates,
        'timeslot': selectedTime,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _bookdate,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Colors.green.shade200, width: 3.0),
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.black,
                        ),
                        hintText: 'Enter your booking date',
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime
                                .now(), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2026));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            _bookdate.text =
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
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Pick Time Slot',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: TIME_SLOTS.length,
                  itemBuilder: ((context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTime = TIME_SLOTS.elementAt(index);
                        });
                      },
                      child: Card(
                        elevation: 10,
                        color: selectedTime == TIME_SLOTS.elementAt(index)
                            ? Colors.brown[50]
                            : Colors.white,
                        child: SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text('${TIME_SLOTS.elementAt(index)}'),
                            subtitle: Text('Available'),
                            leading: selectedTime == TIME_SLOTS.elementAt(index)
                                ? const Icon(Icons.check)
                                : null,
                          ),
                        ),
                      )))),
            ),
            ElevatedButton(
                onPressed: () {
                  print('This is booking date:' + _bookdate.text);
                  print('This is selected timeslot: ' + selectedTime);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orangeAccent),
                ),
                child: const Text(
                  'Book',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
