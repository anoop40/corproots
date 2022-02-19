import 'package:corproots/staff/enquiryDetails/downloadsForms.dart';
import 'package:corproots/staff/typesOfForms.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../settingsAllFle.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Tasks extends StatefulWidget {
  _Tasks createState() => _Tasks();
}

class _Tasks extends State<Tasks> {
  var assignment_initial_step;
  late Future str;
  late Future history_str;
  var history;
  @override
  void initState() {
    super.initState();
    //getAllJobList();
    str = getData();
    history_str = getHistoryData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/getEnquiryDetails";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "enquiry_id": prefs.getString('enqyiryId'),
    });
    print("from server is : " + response.body);
    this.setState(() {
      assignment_initial_step = json.decode(response.body);
    });

    return "1";
  }

  Future getHistoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/getAssignmentTracking";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "job_cardId": prefs.getString('jobCardId'),
    });
    print("from server is : " + response.body);
    this.setState(() {
      history = json.decode(response.body);
    });

    return "1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            customerCallingStatus() {
              if (assignment_initial_step[0]['did_he_called_client'] == "Yes") {
                return Row(
                  children: <Widget>[
                    Icon(
                      Icons.check_box_outlined,
                      size: 16,
                      color: Colors.green,
                    ),
                    Text("Yes")
                  ],
                );
              } else {
                return Text("No");
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 15,
                                        left: 15,
                                      ),
                                      child: Text(
                                        "Job Card Details",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.01,
                                      left: 30.00,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                            "Customer calling status : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        child: customerCallingStatus(),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 30.00,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  child: Wrap(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "Comments : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        child: RichText(
                                          text: TextSpan(
                                            text: assignment_initial_step[0]
                                                ['comment'],
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 30.00,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "Updated on : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        child: Text(assignment_initial_step[0]
                                            ['update_on']),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.data_saver_on),
                            title: Text(assignment_initial_step[0]
                                ['enquiry_date_and_time']),
                            subtitle: Row(
                              children: <Widget>[
                                Text("Assigned staff : "),
                                Text(assignment_initial_step[0]
                                    ['assigned_employ']),
                              ],
                            ),
                            trailing: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                      future: history_str,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return RefreshIndicator(
                            onRefresh: getHistoryData,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: ListView.builder(
                                itemCount: history.length,
                                itemBuilder: (context, index) {
                                  final Map<String, dynamic> dataFinal =
                                      history[index];
                                  if (dataFinal['status'] == "success") {
                                    trailingIconFunction() {
                                      if (dataFinal[
                                              'user_form_fillup_status'] ==
                                          "client_submitted") {
                                        return Wrap(
                                          spacing: 12,
                                          children: <Widget>[
                                            Icon(
                                              Icons.download,
                                              color: Colors.blue,
                                              size: 25,
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 25,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Icon(
                                          Icons.pause,
                                          size: 19,
                                        );
                                      }
                                    }

                                    submissionStatusCalcu() {
                                      if (dataFinal[
                                              'user_form_fillup_status'] ==
                                          "client_submitted") {
                                        return Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 18,
                                            ),
                                            Text("Submitted")
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.pause,
                                              size: 18,
                                            ),
                                            Text("Waiting")
                                          ],
                                        );
                                      }
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          top: 15,
                                                          left: 15,
                                                        ),
                                                        child: Text(
                                                          "Job Card Details",
                                                          style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                        left: 30.00,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Customer Name : ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text(
                                                                    dataFinal[
                                                                        'customer_name']),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                        left: 30.00,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Customer Email : ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text(
                                                                    dataFinal[
                                                                        'email']),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                        left: 30.00,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Customer Mobile Number : ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text(
                                                                    dataFinal[
                                                                        'mobile_number']),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 30.00,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                              "Event : ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        Container(
                                                          child: Text(dataFinal[
                                                              'event']),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 30.00,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Submission Status : ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              submissionStatusCalcu()
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 30.00,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Enquiry Date & Time : ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(dataFinal[
                                                                  'date_and_time']),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 30.00,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                    child: Wrap(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10.00),
                                                          child: OutlinedButton(
                                                              onPressed: () {
                                                                final platform =
                                                                    Theme.of(
                                                                            context)
                                                                        .platform;
                                                                /*
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              downloadsForms(
                                                                                platform: platform,
                                                                                refferenceId: dataFinal['refference_id']
                                                                              )),
                                                                );

                                                                 */
                                                              },
                                                              child: Wrap(
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .download,
                                                                    color: Colors
                                                                        .pink,
                                                                  ),
                                                                  Text(
                                                                      'DOWNLOADS')
                                                                ],
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading:
                                                  Icon(Icons.data_saver_on),
                                              title: Text(dataFinal['event']),
                                              subtitle: Row(
                                                children: <Widget>[
                                                  Text(dataFinal[
                                                      'date_and_time']),
                                                ],
                                              ),
                                              trailing: trailingIconFunction(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.data_saver_on),
                                            title: Text("Nothing found"),
                                            subtitle: Row(
                                              children: <Widget>[
                                                Text("No data found"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(
                              top: 35.00,
                            ),
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                            left: 15,
                          ),
                          child: Text(
                            "Send form to client",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 45,
                        left: 25,
                        top: 15,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: typesOfForms(),
                    ),
                  ],
                ),
              );
            },
          );
        },
        label: const Text('NEW TASK'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
