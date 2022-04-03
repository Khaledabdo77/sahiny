import 'package:clock_app/models/event/event_model.dart';
import 'package:clock_app/widgets/clock.dart';
import 'package:clock_app/widgets/digital.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlarmPage extends StatelessWidget {
  TimeOfDay t;

  AlarmPage(this.t);
  double size = 10;

  double size1 = 10;

  var now = DateTime.now();
  String time = '';
  Duration? difference;
  var diff;

//   @override
//   void initState() {
//     time = widget.t.period == DayPeriod.am ? 'A M' : 'P M';
//
//     super.initState();
// //    initializing();
//   }

  String eventName = '_';

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventModel>(
        init: EventModel(),
        builder: (eventModel) => Column(children: [
              SizedBox(
                height: 30,
              ),
              Expanded(child: DigitalClock()),
              Container(
                height: 150,
                width: 150,
                child: ClockView(),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x4d000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now,
                      lastDate: now.add(Duration(days: 366)),
                      initialDatePickerMode: DatePickerMode.day,
                    ).then((date) {
                      print(date);
                      if (date != null) eventModel.setTimer(date);
                    });
                  },
                  onDoubleTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text('Select name of event'),
                            content: TextField(
                              onChanged: (value) {
                                eventName = value;
                              },
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    eventModel.setEventname(eventName);
                                    Get.back();
                                  },
                                  child: Text('Save'))
                            ],
                          );
                        });
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          eventModel.eventName,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff707070),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TimeLeft(
                              size1: size1,
                              size: size,
                              num: '${eventModel.days}',
                              time: 'Days',
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TimeLeft(
                              size1: size1,
                              size: size,
                              num: '${eventModel.hours}',
                              time: 'Hours',
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TimeLeft(
                              size1: size1,
                              size: size,
                              num: '${eventModel.min}',
                              time: 'Mins',
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TimeLeft(
                              size1: size1,
                              size: size,
                              num: '${eventModel.sec}',
                              time: 'Secs',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          maintainAnimation: true,
                          maintainSize: true,
                          maintainState: true,
                          visible: eventModel.isOpen,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)))),
                            onPressed: () {
                              eventModel.resetTimer();
                            },
                            child: Text('Cancel'),
                          ),
                        ),
                      ]),
                ),
              )
            ]));
  }
}

class TimeLeft extends StatelessWidget {
  const TimeLeft(
      {@required this.size1,
      @required this.size,
      @required this.num,
      @required this.time});

  final double? size1;
  final double? size;
  final String? num;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          (num)!,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 15,
            color: const Color(0xff707070),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          (time)!,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 15,
            color: const Color(0xff707070),
          ),
        ),
      ],
    );
  }
}
