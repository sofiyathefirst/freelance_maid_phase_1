import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/BookSlotModel.dart';
import 'package:freelance_maid_phase_1/customer/cust_booking.dart';
import 'package:freelance_maid_phase_1/type%20of%20services/deepcleaning.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

enum TimeSlotEnum { Eightam, Elevenam, Twopm, Fivepm }

const TIME_SLOT = [
  'TimeSlotEnum.Eightam',
  'TimeSlotEnum.Elevenam',
  'TimeSlotEnum.Twopm',
  'TimeSlotEnum.Fivepm'
];

const TIME_DURATION = [
  '8:00 am - 10:00 am',
  '12:00 pm - 2:00 pm',
  '4:00 pm - 6:00 pm',
  '8:00 pm - 10:00 pm'
];

class BookSlot extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  BookSlot({Key? key, this.data}) : super(key: key);

  @override
  State<BookSlot> createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot> {
  final _formKey = GlobalKey<FormState>();
  //date
  TimeSlotEnum? _timeSlotEnum;
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? formattedDate;
  String? ts = '';

  late String muid = widget.data!.get('uid');

  //fetch data from database
  final bs = FirebaseFirestore.instance
      .collection('maid')
      .doc()
      .collection("bookslot");
  final CollectionReference booktimeslot = FirebaseFirestore.instance
      .collection('maid')
      .doc()
      .collection('bookslot');

  //List<SlotModel> list = [];
  final _slotList = [
    'TimeSlotEnum.Eightam',
    'TimeSlotEnum.Elevenam',
    'TimeSlotEnum.Twopm',
    'TimeSlotEnum.Fivepm'
  ];
  String slot1 = 'TimeSlotEnum.Eightam';
  String slot2 = 'TimeSlotEnum.Elevenam';
  String slot3 = 'TimeSlotEnum.Twopm';
  String slot4 = 'TimeSlotEnum.Fivepm';
  String uslot1 = '';
  String uslot2 = '';
  String uslot3 = '';
  String uslot4 = '';
  String? custuid = FirebaseAuth.instance.currentUser!.uid;

  late Future<QuerySnapshot> _futureData;
  List<Map> _bookslotItems = [];
  String selectedTime = '';

  List<Map> parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List<Map> listItems = listDocs
        .map((e) => {
              'maiduid': e['maiduid'],
              'custuid': e['custuid'],
              'bookdate': e['bookdate'],
              'timeslot': e['timeslot'],
            })
        .toList();
    return listItems;
  }

  @override
  void initState() {
    super.initState();
    _futureData = booktimeslot.get();
    _futureData.then((value) {
      setState(() {
        _bookslotItems = parseData(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference bookslot = FirebaseFirestore.instance
        .collection('maid')
        .doc(muid)
        .collection('bookslot');
    Add(String maiduid, String timeslot, String bookdate, String custuid) {
      try {
        return bookslot.add({
          'maiduid': maiduid,
          'timeslot': timeslot,
          'bookdate': bookdate,
          'custuid': custuid
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
          height: 1000,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    //display calendar here
                    _tableCalendar(),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                    ),
                    //start sini !!!
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('maid')
                            .doc(muid)
                            .collection('bookslot')
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(''),
                              ),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final snapd = snapshot.data!.docs;
                          return Column(
                            children: List.generate(
                              snapd.length,
                              (i) {
                                final slot = snapd[i];

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        if (slot.get('timeslot') != slot1) ...[
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
                                        ],
                                        if (slot.get('timeslot') != slot2) ...[
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
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        if (slot.get('timeslot') != slot3) ...[
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
                                        ],
                                        if (slot.get('timeslot') != slot4) ...[
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
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }),

                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            print('Your Time Slot: $ts');
                            print('Day Choosen: ${formattedDate}');
                          });
                          Add(muid, ts.toString(), formattedDate.toString(),
                              custuid ?? "null");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeepCleaning(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.orangeAccent),
                        ),
                        child: const Text(
                          'Book Slot',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
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
      ),
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
