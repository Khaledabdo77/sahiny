import 'dart:async';

import 'package:clock_app/models/alarm/main_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Model>(
        builder: (model) => Container(
              child: Row(
                children: [
                  // Expanded(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       RaisedButton(
                  //         child: Text('aa'),
                  //         onPressed: () => _displayDialog(context),
                  //       ),
                  //       RaisedButton(
                  //         child: Text('bb'),
                  //         onPressed: () {},
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        TimerWidget(
                          color: Colors.redAccent,
                          num: model.stops,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TimerWidget(
                            color: Colors.greenAccent, num: model.starts),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}

class TimerWidget extends StatelessWidget {
  Color? color;
  int? num;

  TimerWidget({this.color, this.num});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<Model>(
        builder: (model) => InkResponse(
          // onTap: () {
          //   print('tapped');
          // },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text('$num',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: num == null ? 30 : 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
