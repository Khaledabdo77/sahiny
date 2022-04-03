import 'package:flutter/material.dart';

class Alarm {
  int? id;
  String title;
  String dateTime;
  bool isActive;

  Alarm(
      {required this.title,
      required this.dateTime,
      required this.isActive,
      this.id});

  factory Alarm.fromMap(Map<String, dynamic> json) => Alarm(
      id: json['id'],
      dateTime: '${DateTime.parse(json['datetime'])}',
      title: json['title'],
      isActive: json['isActive'] == 1 ? true : false);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'datetime': dateTime,
        'isActive': isActive ? '1' : '0'
      };
}
