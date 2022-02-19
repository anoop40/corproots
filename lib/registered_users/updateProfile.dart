import 'dart:convert';

import 'package:corproots/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class updateProfile extends StatefulWidget {
  _updateProfile createState() => _updateProfile();
}

class _updateProfile extends State<updateProfile> {
  final _usernam = new TextEditingController();
  final _useremail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future updateUserToDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal =
        "${SettingsAllFle.finalURl}update-user-profile-with-name-and-email";

    var response_ur = await http.post(Uri.parse(serverUrlfinal), body: {
      "userid": prefs.getString('userId'),
      "userName": _usernam.text,
      "email": _useremail.text
    }, headers: {
      "Accept": "application/json"
    });
    print("From server : " + response_ur.body);
    var resultCon = json.decode(response_ur.body);
    if (resultCon[0]['status'].toString() == "success") {
      Navigator.pop(context, false);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Welcome(3),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Update your profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
        bottomNavigationBar: new Container(
          child: ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (_formKey.currentState!.validate()) {
                AlertDialog alert = AlertDialog(
                  content: new Row(
                    children: [
                      CircularProgressIndicator(),
                      Container(
                          margin: EdgeInsets.only(left: 7),
                          child: Text(" Please wait")),
                    ],
                  ),
                );
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
                await updateUserToDatabase();
              }
            },
            child: Text('UPDATE NOW'),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage("assets_files/update_your_name.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.00),
                child: Text(
                  "MY PROFILE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.00, left: 15.00, top: 15.00),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _usernam,
                        autofocus: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Your Name",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 7.0, horizontal: 9.0),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.00),
                        child: TextFormField(
                          controller: _useremail,
                          autofocus: false,
                          decoration: InputDecoration(
                            labelText: "Your Email",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 7.0, horizontal: 9.0),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
