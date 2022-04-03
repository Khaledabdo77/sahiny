import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaylodPage extends StatelessWidget {
  String payload;

  PaylodPage(this.payload);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // centerTitle: true,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Container(
          child: Text(
            payload,
            style: TextStyle(fontSize: 48),
          ),
        ),
      ),
    ));
  }
}
