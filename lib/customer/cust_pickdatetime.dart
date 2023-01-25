import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../common method/BookSlotModel.dart';

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
  CollectionReference booktimeslot =
      FirebaseFirestore.instance.collection('bookslot');
  late String maiduid = widget.data!.get('uid');
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? formattedDate;
  String selectedTime = '';
  bool isFetching = false;
  //List<SlotModel> list;

  /*Future<List<UserTask>> getUserTaskList() async {

    QuerySnapshot qShot = 
      await FirebaseFirestore.instance.collection('userTasks').get();

    return qShot.docs.map(
      (doc) => UserTask(
            doc.data['id'],
            doc.data['Description'],
            )
    ).toList();
  }*/

  /*Future<List<SlotsModel>> getTimeSlot() async {
    List<SlotsModel> list;
    var result = new List<SlotModel>.empty(growable: true);
    var bookingRef = FirebaseFirestore.instance.collection('bookslot');
    QuerySnapshot snapshot = await bookingRef.get();
    snapshot.docs.forEach((element) {
      SlotsModel slotModel = SlotModel(
        
      );
    });
    return result;
  }*/

  Future _getDataFromDatabase() async {
    List<SlotModel> list;
    FirebaseFirestore.instance.collection("bookslot").get().then(
      (value) {
        value.docs.forEach(
          (doc) {
            print(doc.data());
          },
        );
      },
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _tableCalendar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            ),
            Text(
              'Pick Time Slot',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: TIME_SLOT.length,
                  itemBuilder: ((context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTime = TIME_SLOT.elementAt(index);
                        });
                        _getDataFromDatabase();
                      },
                      child: Card(
                        elevation: 10,
                        color: selectedTime == TIME_SLOT.elementAt(index)
                            ? Colors.brown[50]
                            : Colors.white,
                        child: SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text('${TIME_SLOT.elementAt(index)}'),
                            subtitle: Text('Available'),
                            leading: selectedTime == TIME_SLOT.elementAt(index)
                                ? const Icon(Icons.check)
                                : null,
                          ),
                        ),
                      )))),
            ),
          ],
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
