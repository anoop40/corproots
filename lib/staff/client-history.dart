import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Client_history extends StatefulWidget {
  _Client_history createState() => _Client_history();
}

class _Client_history extends State<Client_history> {
  late Future str;
  late List history;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/client-history";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "clientId": prefs.getString('fetchingUsersId'),
    });
    print("From server is : " + response.body);
    this.setState(() {
      history = json.decode(response.body) as List<dynamic>;
    });

    return "1";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Client History"),
      ),
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: getData,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.00),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.87,
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> dataFinal = history[index];
                        staffUpdationNotes() {
                          if (dataFinal['staff_updation_notes'] != null) {
                            return Text(dataFinal['staff_updation_notes']);
                          } else {
                            return Text("Waiting");
                          }
                        }

                        customerUpdationNotes() {
                          if (dataFinal['customer_updation_notes'] != null) {
                            return Text(dataFinal['customer_updation_notes']);
                          } else {
                            return Text("Waiting");
                          }
                        }

                        extraNotes() {
                          if (dataFinal['notes'] != null) {
                            return Text(dataFinal['notes']);
                          } else {
                            return Text("Nil");
                          }
                        }

                        if (dataFinal['status'] == "success") {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.calendar_today,
                                  color: Colors.pink,
                                ),
                                title: Text(
                                  "Generated on : " +
                                      StringUtils.capitalize(
                                          dataFinal['updated_on']),
                                ),
                                subtitle: Wrap(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.00),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.verified_user,
                                                size: 15.00,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 3.00),
                                                child: Text(
                                                  "Staff updation notes : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.00),
                                          child: Row(
                                            children: <Widget>[
                                              staffUpdationNotes(),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.00),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.verified_user,
                                                size: 15.00,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 3.00),
                                                child: Text(
                                                    "Customer updation notes : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.00),
                                          child: Row(
                                            children: <Widget>[
                                              customerUpdationNotes(),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.00),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.note,
                                                size: 15.00,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 3.00),
                                                child: Text("Extra notes : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.00),
                                          child: Row(
                                            children: <Widget>[
                                              extraNotes(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.4),
                            child: Center(
                              child: Text("History Not Found"),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
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
