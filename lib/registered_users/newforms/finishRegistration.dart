import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:flutter/widgets.dart';

import '../../settingsAllFle.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class finishRegistration extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final Form_assigned_to_clint_table_id;
  finishRegistration(this.Form_assigned_to_clint_table_id);
  _finishRegistration createState() => _finishRegistration();
}

class _finishRegistration extends State<finishRegistration> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  late Future str;
  updateRecord() async {
    var serverUrlfinal = "${SettingsAllFle.finalURl}updateAssignmentStatus";

    var response_ur = await http.post(Uri.parse(serverUrlfinal), body: {
      "form_assigned_to_clint_table_id": widget.Form_assigned_to_clint_table_id,
    }, headers: {
      "Accept": "application/json"
    });
    print(response_ur.body);
    //var resultCon = json.decode(response_ur.body);
    return true;
  }

  @override
  void initState() {
    super.initState();
    str = updateRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Completed"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child:
                        Image(image: AssetImage('assets_files/complted.jpg')),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Icon(
                      Icons.check_box_rounded,
                      color: Colors.green,
                      size: 40.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.00),
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Text(
                        "You are successfully submitted documents. Our executive will call you back .."),
                  ),
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "userDashboard");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      icon: Icon(Icons.home, size: 18),
                      label: Text("HOME"),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
