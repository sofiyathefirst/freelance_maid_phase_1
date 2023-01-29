import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/BookSlotModel.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/deepcleaning.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BookSlot extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  BookSlot({Key? key, this.data}) : super(key: key);

  @override
  State<BookSlot> createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot> {
  //date
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? formattedDate;
  String? ts = '';

  //get maid uid from previous page
  late String muid = widget.data!.get('uid');

  //fetch data from database
  final CollectionReference booktimeslot = FirebaseFirestore.instance
      .collection('maid')
      .doc()
      .collection('bookslot');

  //timeslot list
  List<String> timeSlots = [
    '8:00 am - 10:00 am',
    '12:00 pm - 2:00 pm',
    '4:00 pm - 6:00 pm',
    '8:00 pm - 10:00 pm'
  ];

  //get customer uid
  String? custuid = FirebaseAuth.instance.currentUser!.uid;

  //get selectedtimeslot
  String selectedTime = '';

  //store the list of available slots
  List<String> avs = [];

  Future<void> checkAvailability(List<String> timeSlots) async {
    // Get the timeslots from Firestore
    List<String> availableSlots = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('maid')
        .doc(muid)
        .collection('bookslot')
        .where('bookdate', isEqualTo: formattedDate)
        .get();

    final List<DocumentSnapshot> documents = snapshot.docs;

    //clear the list before check the new date
    availableSlots.clear();

    // Iterate through the list of timeslots
    for (int i = 0; i < timeSlots.length; i++) {
      bool isAvailable = true;
      for (final DocumentSnapshot doc in documents) {
        if (doc.get('timeslot') == timeSlots[i]) {
          // If the timeslot is  equal to the selected time, set isAvailable to false
          isAvailable = false;
          break;
        }
      }
      //if isAvailable is true, add the timselots into available list
      if (isAvailable) {
        availableSlots.add(timeSlots[i]);
      }
    }

    //set the availableSlots to avs
    setState(() {
      avs = availableSlots;
    });
  }

  @override
  void initState() {
    super.initState();
    checkAvailability(timeSlots);
  }

  @override
  Widget build(BuildContext context) {
    //add bookingslot to database
    CollectionReference bookslot = FirebaseFirestore.instance
        .collection('maid')
        .doc(muid)
        .collection('bookslot');
    Add(
      String maiduid,
      String timeslot,
      String bookdate,
      String custuid,
    ) {
      try {
        return bookslot.add({
          'maiduid': maiduid,
          'timeslot': timeslot,
          'bookdate': bookdate,
          'custuid': custuid,
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: 700,
          child: Column(
            children: [
              //display calendar here
              _tableCalendar(),

              //function
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: avs.length,
                  itemBuilder: ((context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTime = avs[index];
                          });
                        },
                        child: Card(
                          elevation: 10,
                          color: selectedTime == avs[index]
                              ? Colors.brown[50]
                              : Colors.white,
                          child: SizedBox(
                            height: 60,
                            child: ListTile(
                              title: Text(avs[index]),
                              subtitle: Text('Available'),
                              leading: selectedTime == avs[index]
                                  ? const Icon(Icons.check)
                                  : null,
                            ),
                          ),
                        ),
                      )),
                ),
              ),

              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      print('Your Time Slot: $selectedTime');
                      print('Day Choosen: ${formattedDate}');
                    });
                    Add(muid, selectedTime, formattedDate.toString(),
                        custuid ?? "null");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Custbooking(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orangeAccent),
                  ),
                  child: const Text(
                    'Book Slot',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2025, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
          todayDecoration:
              BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
          defaultTextStyle: TextStyle(color: Colors.black)),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          formattedDate = DateFormat('MM/dd/yyyy').format(_currentDay);
          _focusDay = focusedDay;
          _dateSelected = true;
          checkAvailability(timeSlots);
        });
      }),
    );
  }
}

/*Row(
                      children: [
                        Expanded(
                          child: RadioListTile<TimeSlotEnum>(
                            value: TimeSlotEnum.Eightam,
                            title: Text('8:00AM'),
                            groupValue: _timeSlotEnum,
                            onChanged: (value) {
                              setState(() {
                                _timeSlotEnum = value;
                              });

                              ts = _timeSlotEnum.toString();
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<TimeSlotEnum>(
                            value: TimeSlotEnum.Elevenam,
                            title: Text('11:00AM'),
                            groupValue: _timeSlotEnum,
                            onChanged: (value) {
                              setState(() {
                                _timeSlotEnum = value;
                              });

                              ts = _timeSlotEnum.toString();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<TimeSlotEnum>(
                            value: TimeSlotEnum.Twopm,
                            title: Text('2:00PM'),
                            groupValue: _timeSlotEnum,
                            onChanged: (value) {
                              setState(() {
                                _timeSlotEnum = value;
                              });

                              ts = _timeSlotEnum.toString();
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<TimeSlotEnum>(
                            value: TimeSlotEnum.Fivepm,
                            title: Text('5:00PM'),
                            groupValue: _timeSlotEnum,
                            onChanged: (value) {
                              setState(() {
                                _timeSlotEnum = value;
                              });
                              ts = _timeSlotEnum.toString();
                            },
                          ),
                        ),
                      ],
                    ),*/

/* SizedBox(
                                        height: 400,
                                        child: ListView.builder(
                                          itemCount: TIME_SLOT.length,
                                          itemBuilder: ((context, index) =>
                                              GestureDetector(
                                                onTap: slot.get('timeslot') ==
                                                        TIME_SLOT
                                                            .elementAt(index)
                                                    ? null
                                                    : () {
                                                        setState(() {
                                                          selectedTime =
                                                              TIME_SLOT
                                                                  .elementAt(
                                                                      index);
                                                        });
                                                      },
                                                child: Card(
                                                  elevation: 10,
                                                  color: slot.get('timeslot') ==
                                                          TIME_SLOT
                                                              .elementAt(index)
                                                      ? Colors.white10
                                                      : selectedTime ==
                                                              TIME_SLOT
                                                                  .elementAt(
                                                                      index)
                                                          ? Colors.brown[50]
                                                          : Colors.white,
                                                  child: SizedBox(
                                                    height: 60,
                                                    child: ListTile(
                                                      title: Text(
                                                          '${TIME_DURATION.elementAt(index)}'),
                                                      subtitle: Text(slot.get(
                                                                  'timeslot') ==
                                                              TIME_SLOT
                                                                  .elementAt(
                                                                      index)
                                                          ? 'Full'
                                                          : 'Available'),
                                                      leading: selectedTime ==
                                                              TIME_SLOT
                                                                  .elementAt(
                                                                      index)
                                                          ? const Icon(
                                                              Icons.check)
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),*/
