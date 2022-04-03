import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DigitalClock extends StatelessWidget {
  DateTime now = DateTime.now();
  TimeOfDay timenow = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    var dateformat = DateFormat('EEE, d MMM').format(now);
    var a = DateFormat('h:mm').format(now);
    var b = DateFormat('a').format(now);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$a',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: size.width / 13,
                  color: const Color(0xff707070),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  b,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: size.width / 22,
                    color: const Color(0x85707070),
                  ),
                ),
              )
            ],
          ),
          Text(
            dateformat,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: size.width / 22,
              color: const Color(0xff707070),
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
