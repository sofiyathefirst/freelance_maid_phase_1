import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelance_maid_phase_1/common%20method/utils.dart';
import 'package:intl/intl.dart';

class PickDateTime extends StatefulWidget {
  PickDateTime({Key? key}) : super(key: key);

  @override
  State<PickDateTime> createState() => _PickDateTimeState();
}

class _PickDateTimeState extends State<PickDateTime> {
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
            GridView.builder(
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: TIME_SLOT.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    selectedTime = TIME_SLOT.elementAt(index);
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green; //<-- SEE HERE
                        return null; // Defer to the widget's default.
                      },
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.brown[100]),
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
            ),
          ],
        ),
      ),
    );
  }
}
