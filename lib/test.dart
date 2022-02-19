import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class myRequests extends StatefulWidget {
  _myRequests createState() => _myRequests();
}

class _myRequests extends State<myRequests> {
  late Future str;
  late List myRequests;

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "${SettingsAllFle.finalURl}list-my-enquiries-user";
    print("User ID is : " + prefs.getString('userId').toString());
    var response = await http.post(Uri.parse(serverUrlfinal),
        body: {'userId': prefs.getString('userId')},
        headers: {"Accept": "application/json"});
    print("My enquiries listing " + response.body);
    this.setState(() {
      myRequests = json.decode(response.body) as List<dynamic>;
    });
    return "true";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.94,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: FutureBuilder(
          future: str,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: myRequests.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> dataFinal =
                        myRequests[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(dataFinal['enquiry_category']),
                              subtitle: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      dataFinal['enquiry_date_and_time'],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Icon(
                                      Icons.alarm_sharp,
                                      size: 15,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Text(
                                          dataFinal['enquiry_process_status'])),
                                ],
                              ),
                              trailing: Icon(Icons.navigate_next),
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.01,
                                              bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.01,
                                            ),
                                            child: Container(
                                              child: Text(
                                                'Enquiry status',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.95,
                                              margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.02),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.01,
                                            ),
                                            child: Container(
                                              child: Text(
                                                'Enquiry generated on : ${dataFinal['enquiry_date_and_time']}',
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.95,
                                              margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.02),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.01,
                                            ),
                                            child: Container(
                                              child: Text(
                                                'Current Status : ${dataFinal['enquiry_process_status']}',
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.95,
                                              margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.02),
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: const Text('Close'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            Divider(),
                          ],
                        );
                      },
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
      ),
    );
  }
}
