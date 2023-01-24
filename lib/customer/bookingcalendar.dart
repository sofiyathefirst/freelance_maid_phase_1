import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/BookSlotModel.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

enum TimeSlotEnum { Eightam, Elevenam, Twopm, Fivepm }

class BookSlot extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;
  BookSlot({Key? key, this.data}) : super(key: key);

  @override
  State<BookSlot> createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot> {
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

  late String maiduid = widget.data!.get('maiduid');
  late String bookdate = widget.data!.get('bookingdate');
  late String timeslot = widget.data!.get('timeslot');

  //fetch data from database
  CollectionReference cf = FirebaseFirestore.instance.collection("bookslot");
  List<SlotModel> list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 800,
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
                    Row(
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
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            print('Your Time Slot: $ts');
                            print('Day Choosen: ${formattedDate}');
                          });
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
