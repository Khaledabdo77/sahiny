import 'dart:async';
import 'package:clock_app/models/alarm/main_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
        () => Get.off(() => Main(), curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Center(
                  // heightFactor: MediaQuery.of(context).size.height / 9,
                  child: Text(
                'Schedule Planner',
                style: TextStyle(fontSize: 30),
              )),
            ),
            Expanded(
              flex: 2,
              child: RiveAnimation.asset(
                'assets/file.riv',
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ));
  }
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: Model(),
      builder: (model) => Home(),
    );
  }
}
