import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const TIME_SLOT = [
  '8:00 am - 10:00 am',
  '12:00 pm - 2:00 pm',
  '4:00 pm - 6:00 pm',
  '8:00 pm - 10:00 pm'
];

class PickDateTime extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  PickDateTime({Key? key, this.data}) : super(key: key);

  @override
  State<PickDateTime> createState() => _PickDateTimeState();
}

class _PickDateTimeState extends State<PickDateTime> {
  final booktimeslot = FirebaseFirestore.instance.collection('bookingmaids');
  late String maiduid = widget.data!.get('uid');
  DateTime date = DateTime.now();
  String selectedTime = '';
  String? bookingdate = '';
  String? bookingtime = '';

  /* Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("bookingmaids")
        .doc()
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          bookingdate = snapshot.data()!['bookingdate'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.brown[500],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '${DateFormat.MMMM().format(date)}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            Text(
                              '${date.year}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => SizedBox(
                          height: 250,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            backgroundColor: Colors.white,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (value) {
                              if (value != null && value != date)
                                setState(() {
                                  date = value;
                                });
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: booktimeslot.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unsuccesful'),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final snapd = snapshot.data!.docs;
                  return Column(
                    children: List.generate(
                      snapd.length,
                      (i) {
                        final bb = snapd[i];
                        return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 160,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: TIME_SLOT.length,
                          itemBuilder: (context, index) {
                            /*for (int i = 0; i < TIME_SLOT.length; i++)
                           {
                            if(bb.get('maiduid') == maiduid) {
                              if(TIME_SLOT.elementAt(index) != )
                            }
                           
                          }*/
                            return ElevatedButton(
                              onPressed: () {
                                selectedTime = TIME_SLOT.elementAt(index);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(10),
                                fixedSize: Size(100, 50),
                                primary: Colors.brown[100],
                                onPrimary: Colors.black,
                                elevation: 15,
                              ),
                              child: Text(
                                '${TIME_SLOT.elementAt(index)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

/*style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green; //<-- SEE HERE
                        return null; // Defer to the widget's default.
                      },
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.brown[100]),
                        
                  ),*/
