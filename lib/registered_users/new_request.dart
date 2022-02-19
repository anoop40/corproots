import 'package:flutter/material.dart';

class new_request extends StatefulWidget {
  _new_request createState() => _new_request();
}

class _new_request extends State<new_request> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Text("Welcome My Requests"),
        ),
      ),
    );
  }
}
