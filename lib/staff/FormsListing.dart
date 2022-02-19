import 'dart:core';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FormsListing extends StatefulWidget {
  @override
  _FormListing createState() => new _FormListing();
}

class _FormListing extends State<FormsListing> {
  late List formsSaved;
  late Future str;
  bool value = false;
  bool isChecked = false;
  bool _buttonStat = true;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  getData() async {
    var serverUrlfinal = "${SettingsAllFle.finalURl}/get-forms-list";

    var response = await http.post(Uri.parse(serverUrlfinal),
        headers: {"Accept": "application/json"});
    print("from server" + response.body);
    this.setState(() {
      formsSaved = json.decode(response.body) as List<dynamic>;
    });

    return "1";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getData();
  }

  var tmpArray = [];

  cancelButtonFun() {
    if (_buttonStat == true) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.25,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
      );
    } else {
      return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: formsSaved.map((hobby) {
                    return CheckboxListTile(
                        value: hobby["isChecked"],
                        title: Text(hobby["form_heading"]),
                        onChanged: (newValue) {
                          setState(() {
                            hobby["isChecked"] = newValue;
                          });
                        });
                  }).toList()),
              Container(
                margin: EdgeInsets.only(top: 15.00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    cancelButtonFun(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: RoundedLoadingButton(
                        borderRadius: 8,
                        child: Text(
                          'SEND',
                          style: TextStyle(color: Colors.white),
                        ),
                        controller: _btnController,
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var userId = prefs.getString('userId');
                          //var jobCardId = prefs.getString('jobCardId');
                          var enquiry_id  = prefs.getString('enquiry_id');
                          formsSaved.map((hobby) async {
                            if (hobby["isChecked"] == true) {
                              var serverUrlfinal =
                                  "${SettingsAllFle.finalURl}/send-form-to-client";

                              var response = await http
                                  .post(Uri.parse(serverUrlfinal), headers: {
                                "Accept": "application/json"
                              }, body: {
                                "staffId": userId,
                                "enquiry_id": enquiry_id,
                                "form_id": hobby["form_id"],
                              });
                              print("From server : " + response.body);
                              var responseSer = json.decode(response.body);
                              if (responseSer[0]['status'] == "success") {
                                _btnController.success();
                                Timer(Duration(seconds: 1), () {
                                  // _btnController.success();
                                  Navigator.pushNamed(context, 'userDashboard');
                                });
                              }
                              /*
                              print("Checked values is : " +

                                  hobby["form_id"]);

                               */
                            }
                            return Container();
                            return Container();
                          }).toList();

                          setState(() {
                            _buttonStat = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          } else {
            return Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: CircularProgressIndicator(),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text("Loading"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
