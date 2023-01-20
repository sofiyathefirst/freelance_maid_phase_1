import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  DateTime date = DateTime.now();
  String selectedTime = '';

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
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              width: 250,
                            ),
                            Text(
                              '${date.day}' +
                                  '\t' +
                                  '${DateFormat.MMMM().format(date)}' +
                                  '\t' +
                                  '${date.year}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                          height: 270,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            backgroundColor: Colors.white,
                            minimumDate: DateTime.now(),
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
          ],
        ),
      ),
    );
  }
}
