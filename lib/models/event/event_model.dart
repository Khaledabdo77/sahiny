import 'dart:async';

import 'package:clock_app/models/event/event.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventModel extends GetxController {
  late SharedPreferences preferences;

  String eventName = 'Double Tap To Add Event\'s Name';
  String? date;

  @override
  onInit() async {
    preferences = await SharedPreferences.getInstance();
    if (date != null) {
      date = preferences.getString('datetime');
      setTimer(DateTime.parse(date!));
    } else {
      days = 0;
      sec = 0;
      min = 0;
      hours = 0;
    }

    eventName =
        preferences.getString('name') ?? 'Double Tap To Add Event\'s Name';
    getEvent();
    update();
  }

  setEventname(String name) {
    preferences.setString('name', name);
    eventName = name;
    update();
  }

  getEvent() {
    eventName =
        (preferences.getString('name')) ?? 'Double Tap To Add Event\'s Name';
    date = (preferences.getString('datetime')) ?? null;
    update();
  }

  var days = 0, sec = 0, min = 0, hours = 0;

  Duration duration = Duration(seconds: 1);
  Timer? timer;
  bool isOpen = false;
  Duration? difference;

  setTimer(DateTime value) {
    if (!isOpen) {
      isOpen = true;
      print('entered');
      print(value);
      preferences.setString(
          'datetime', value.toIso8601String().split('.').first);
      timer = Timer.periodic(duration, (time) {
        difference = value.difference(DateTime.now());
        var diff = difference.toString().split(':');
        if ((int.parse(diff[0]) >= 24)) {
          days = (int.parse(diff[0]) / 24).floor();
        } else {
          days = 0;
        }
        print(days);
        hours = days != 0
            ? (((int.parse(diff[0]))) - days * 24)
            : (int.parse(diff[0]));
        print(hours);
        min = int.parse(diff[1]);
        print(min);
        sec = double.parse(diff[2]).floor();
        print(sec);
        update();
      });
    } else {
      resetTimer();
      setTimer(value);
    }
  }

  void resetTimer() {
    (timer)!.cancel();
    isOpen = false;
    preferences.setString('name', 'Double Tap To Add Event\'s Name');
    preferences.setString('datetime', '');
    eventName = 'Double Tap To Add Event\'s Name';
    days = 0;
    hours = 0;
    min = 0;
    sec = 0;
    update();
  }

  List<int> weeksday = [DateTime.saturday, DateTime.friday];

  void toggle(bool button) {
    button = !button;
    update();
  }
}
