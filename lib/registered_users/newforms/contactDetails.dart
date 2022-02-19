import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../settingsAllFle.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class contactDetails extends StatefulWidget {
  _contactDetails createState() => _contactDetails();
}

class _contactDetails extends State<contactDetails> {
  final _mobileNumber = TextEditingController();
  final _email = TextEditingController();
  bool _stat = false;
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  basicFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _mobileNumber.text = prefs.getString('mobile_number')!;
      if (prefs.getString('email') != "not_found") {
        _email.text = prefs.getString('email')!;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    basicFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update contact details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Image(
                    image: AssetImage('assets_files/contact_details.png')),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(top: 15.00),
                child: Text(
                  "Contact Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(top: 15.00),
                child: TextField(
                  controller: _mobileNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contact Number',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(top: 15.00),
                child: TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: RoundedLoadingButton(
            width: MediaQuery.of(context).size.width,
            curve: Curves.fastOutSlowIn,
            child: Text("NEXT"),
            controller: _btnController1,
            borderRadius: 4,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (_email.text == "" || _mobileNumber.text == "") {
                _btnController1.reset();
                final snackBar = SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text('Some fields are missing'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                if (_email.text != prefs.getString('email')) {
                  prefs.setString('email', _email.text);
                  var serverUrlfinal =
                      "${SettingsAllFle.finalURl}updateUserEmail";

                  var response_ur =
                      await http.post(Uri.parse(serverUrlfinal), body: {
                    "userId": prefs.getString('userId'),
                    "email": _email.text,
                  }, headers: {
                    "Accept": "application/json"
                  });
                  var resultCon = json.decode(response_ur.body);
                  // print(response_ur.body);
                  if (resultCon[0]['status'] == "success") {
                    Navigator.pushNamed(context, 'pan-card-upload');
                  }
                } else {
                  Navigator.pushNamed(context, 'pan-card-upload');
                }
              }
            }),
      ),
    );
  }
}
