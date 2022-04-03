import 'dart:async';
import 'package:clock_app/models/alarm/alarm.dart';
import 'package:clock_app/models/alarm/main_model.dart';
import 'package:clock_app/notification/notification.dart';
import 'package:clock_app/pages/againPage.dart';
import 'package:clock_app/pages/alarmView.dart';
import 'package:clock_app/pages/stopwatchPage.dart';
import 'package:clock_app/pages/timerPage.dart';
import 'package:clock_app/widgets/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'dart.html';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _MobState createState() => _MobState();
}

class _MobState extends State<Home> {
  int currentPage = 0;
  late PageController controller;

  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    NotificationApi.init(initSchedled: true);
    controller = PageController(initialPage: currentPage, keepPage: true);
    Timer.periodic(Duration(seconds: 1), (time) {
      setState(() {
        timeOfDay = TimeOfDay.now();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetBuilder<Model>(
      builder: (model) => Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Time',
            style: TextStyle(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: context.theme.scaffoldBackgroundColor,
          centerTitle: true,
          elevation: 20,
          actions: [
            Container(
                padding: EdgeInsets.all(8),
                color: Theme.of(context).scaffoldBackgroundColor,
//              decoration: BoxDecoration(shape: BoxShape.circle),
                child: IconButton(
                  color: Colors.black,
                  onPressed: () async {
                    Get.to(() => AlarmView());
                    // await model.deletedata();
                  },
                  icon: Icon(Icons.menu),
                ))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: PageView(
                controller: controller,
                pageSnapping: true,
                onPageChanged: (i) {
                  setState(() {
                    currentPage = i;
                  });
                },
                children: [
                  AlarmPage(timeOfDay),
                  AgainPage(),
                  SWatchPage(),
                  TimerPage()
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 2.4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildContainer(0, Icon(Icons.alarm_add)),
                      buildContainer(1, Icon(Icons.alarm)),
                      buildContainer(2, Icon(Icons.timelapse)),
                      buildContainer(3, Icon(Icons.timer_3)),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AddButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    currentPage: currentPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Container buildContainer(int i, Icon icon) {
    return Container(
        width: 50,
        height: 50,
        decoration: currentPage == i
            ? BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              )
            : BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
        child: IconButton(
            onPressed: () {
              controller.animateToPage(i,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut);
              currentPage = i;
              setState(() {});
            },
            icon: icon));
  }
}

enum variables {
  str,
  stp,
  rep,
}

class AddButton extends StatelessWidget {
  Widget? icon;
  Function? fun;

  String alarmTitle = '';

  AddButton({required this.icon, this.fun, required this.currentPage});

  DateTime _alarmTime = DateTime.now();

  late TimeOfDay selectedTime;

  late DateTime selectedDateTime;

  int currentPage = 0;
  String? word;
  TextEditingController _textFieldController = TextEditingController();

  int? stp, str, rep = 0;

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('What is your Lucky Number'),
            content: TextField(
              onChanged: (s) {
                print(s);
                word = s;
              },
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(hintText: "Enter your number"),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('Submit'),
                onPressed: () {
                  TimerWidget(color: Colors.blue, num: int.parse(word!));
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0x6e000000).withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
//      child: Material(
//        elevation: 10,

      child: GetBuilder<Model>(
          builder: (model) => ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).scaffoldBackgroundColor)),
                onPressed: () {
                  String _alarmTimeString =
                      DateFormat.jm().format(DateTime.now());
                  showModalBottomSheet(
                    isScrollControlled: true,
                    useRootNavigator: true,
                    context: context,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return Container(
                            height: context.height / 1.5,
                            padding: const EdgeInsets.all(32),
                            child: currentPage == 0
                                ? Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          selectedTime = (await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ))!;

                                          if (selectedTime != null) {
                                            final now = DateTime.now();
                                            selectedDateTime = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                selectedTime.hour,
                                                selectedTime.minute);
                                            setModalState(() {
                                              _alarmTimeString = DateFormat.jm()
                                                  .format(selectedDateTime);
                                              AlarmView(date: selectedTime);
                                              print(
                                                  'your clock is ${selectedTime.hour} : ${selectedTime.minute}');
                                            });
                                          }
                                        },
                                        child: Text(
                                          _alarmTimeString,
                                          style: TextStyle(fontSize: 32),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        onChanged: (s) {
                                          print(s);
                                          alarmTitle = s;
                                        },
                                        controller: _textFieldController,
                                        textInputAction: TextInputAction.go,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                            hintText: "Enter Title"),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ListTile(
                                        title: Text('Sound'),
                                        trailing: Icon(Icons.arrow_forward_ios),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      // buildRepeat(context, model),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      // new TextButton(
                                      //     child: new Text('notify'),
                                      //     onPressed: () async {
                                      //       NotificationApi.showNotification(
                                      //           id: 8,
                                      //           title: 'lkl',
                                      //           body: 'fjhgjf',
                                      //           dateTime: DateTime.now(),
                                      //           payload: 'jjj');
                                      //       print('done');
                                      //     }),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      FloatingActionButton.extended(
                                        onPressed: () async {
                                          print('object3');
                                          DateTime scheduleAlarmDateTime;
                                          if (selectedDateTime
                                              .isAfter(DateTime.now()))
                                            scheduleAlarmDateTime = _alarmTime;
                                          else
                                            scheduleAlarmDateTime = _alarmTime
                                                .add(Duration(days: 1));
                                          var alarm = Alarm(
                                              title: alarmTitle,
                                              dateTime: selectedDateTime
                                                  .toIso8601String()
                                                  .split('.')
                                                  .first,
                                              isActive: true);
                                          model.insertAlarm(alarm);
                                          print(
                                              alarm.dateTime.split('.').first);
                                          NotificationApi.showNotification(
                                              id: 8,
                                              title: 'lkl',
                                              body: 'fjhgjf',
                                              dateTime: selectedDateTime,
                                              payload: 'jjj');
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.alarm),
                                        label: Text('Save'),
                                      )
                                    ],
                                  )
                                : ListView(
                                    // mainAxisAlignment:
                                    // MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(child: Text('stops')),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (v) {
                                                stp = int.parse(v);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(child: Text('start')),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (v) {
                                                str = int.parse(v);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(child: Text('repeat')),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (v) {
                                                rep = int.parse(v);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            print('$stp , $str , $rep');
                                            // model.stops = stp!;
                                            // model.starts = str!;
                                            // model.repeats = rep!;
                                            model.setNumbers(
                                                repeat: rep,
                                                start: str,
                                                stop: stp);
                                            Get.back();
                                          },
                                          child: Text('start'))
                                      // Expanded(
                                      //   child: ListTile(
                                      //     leading: Text('start = '),
                                      //     trailing: TextFormField(
                                      //       onChanged: (v) {},
                                      //     ),
                                      //   ),
                                      // ),
                                      // Expanded(
                                      //   child: ListTile(
                                      //     leading: Text('repeat = '),
                                      //     trailing: TextFormField(
                                      //       onChanged: (v) {},
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                          );
                        },
                      );
                    },
                  ).then((value) {
                    print(value);
//                    model.addAlarm(value);
//                    model.allalarms();
                  });
                  // scheduleAlarm();
                },
                child: icon,
              )),
//      ),
    );
  }

  // ListTile buildRepeat(BuildContext context, Model model) {
  //   return ListTile(
  //     title: Text('Repeat'),
  //     trailing: Icon(Icons.arrow_forward_ios),
  //     onTap: () {
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return StatefulBuilder(
  //               builder: (ctc, setState) => Dialog(
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20.0)),
  //                 //this right here
  //                 child: Container(
  //                   height: 400,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(12.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Wrap(
  //                           spacing: 5,
  //                           children: [
  //                             TextButton(
  //                               style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       Color(0xFF1BC0C5))),
  //                               onPressed: () {
  //
  //                               },
  //                               child: Text(
  //                                 'S',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ),
  //                             TextButton(
  //                               style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       Color(0xFF1BC0C5))),
  //                               onPressed: () {},
  //                               child: Text(
  //                                 'S',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ),
  //                             TextButton(
  //                               style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       Color(0xFF1BC0C5))),
  //                               onPressed: () {},
  //                               child: Text(
  //                                 'S',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ),
  //                             TextButton(
  //                               style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       Color(0xFF1BC0C5))),
  //                               onPressed: () {},
  //                               child: Text(
  //                                 'S',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ),
  //                             TextButton(
  //                               style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       Color(0xFF1BC0C5))),
  //                               onPressed: () {},
  //                               child: Text(
  //                                 'S',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ),
  //                             TextButton(
  //                               style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       Color(0xFF1BC0C5))),
  //                               onPressed: () {},
  //                               child: Text(
  //                                 'S',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ),
  //                             TextButton(
  //                               style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                       Color(0xFF1BC0C5))),
  //                               onPressed: () {},
  //                               child: Text(
  //                                 'S',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 20,
  //                         ),
  //                         FlatButton(
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10)),
  //                           onPressed: () {},
  //                           child: Text(
  //                             "Save",
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                           color: const Color(0xFF1BC0C5),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           });
  //     },
  //   );
  // }
}
