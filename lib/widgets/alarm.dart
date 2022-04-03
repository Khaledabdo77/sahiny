import 'package:clock_app/constant/constant.dart';
import 'package:clock_app/models/alarm/alarm.dart';
import 'package:clock_app/models/alarm/main_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AlarmView extends StatefulWidget {
  TimeOfDay? date;

  AlarmView({this.date});

  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  @override
  void initState() {
    widget.date = TimeOfDay.now();
    print('${(widget.date)!.hour}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Model>(
      builder: (value) => Scaffold(
        appBar: AppBar(
          // title: Text(
          //   'Alarms',
          //   style: TextStyle(
          //       fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
          // ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              // style: ButtonStyle(
              // backgroundColor:
              //     MaterialStateProperty.all<Color>(Colors.black)),
              onPressed: () async {
                Get.dialog(AlertDialog(
                  title: Text('Delete Every thing ?'),
                  content: Text('Delete ?'),
                  backgroundColor: Colors.orange,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('cancel'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await value.deleteDataBase();
                          Get.back();
                        },
                        child: Text('Delete')),
                  ],
                ));
              },
              icon: Icon(
                Icons.delete_forever,
                color: Colors.black,
              ),
            ),
          ],
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: value.allalarms(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        print(snapshot.data);
                        Alarm alarm = snapshot.data[index];
                        DateTime dateTime = DateTime.parse(alarm.dateTime);
                        String selectedTimeString =
                            DateFormat.jm().format(dateTime);

                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(0, 10),
                                  blurRadius: 10,
                                  spreadRadius: 1)
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    alarm.title,
                                    style: TextStyle(
                                        color: alarm.isActive
                                            ? Colors.orangeAccent
                                            : Colors.grey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    selectedTimeString,
                                    style: TextStyle(
                                        color: alarm.isActive
                                            ? Colors.blue
                                            : Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Switch(
                                    value: alarm.isActive,
                                    activeColor: Colors.green,
                                    activeTrackColor:
                                        Colors.orange.withOpacity(0.1),
                                    inactiveTrackColor:
                                        Colors.red.withOpacity(0.1),
                                    inactiveThumbColor: Colors.red,
                                    onChanged: (val) {
                                      print(alarm.id);
                                      value.toggle(index, alarm);
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await value.deletedata((alarm.id)!);
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red)
                            ],
                          ),
                        );
                      },
                      itemCount: snapshot.data.length,
                    );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
