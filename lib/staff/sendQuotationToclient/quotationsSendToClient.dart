import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../settingsAllFle.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../quotationDetails.dart';

class quotationsSendToClient extends StatefulWidget {
  _quotationsSendToClient createState() => _quotationsSendToClient();
}

class _quotationsSendToClient extends State<quotationsSendToClient> {
  late List history;
  late Future str;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/client-send-quotations";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "clientId": prefs.getString('fetchingUsersId'),
    });
    //print("From server is : " + response.body);
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
        title: Text("Quotations"),
      ),
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: getData,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.00),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> dataFinal = history[index];
                        //print("Client review statsu " + dataFinal['client_review_status']);
                        clientReviewedStatus() {
                          if (dataFinal['client_review_status'] == "0") {
                            return Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 13.00,
                                  height: 13.00,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text("Waiting for review"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'pdfViewer',
                                        arguments: {
                                          "fileName": dataFinal['file_name']
                                        });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.00),
                                        child: FaIcon(
                                          FontAwesomeIcons.filePdf,
                                          size: 17,
                                          color: Colors.red[300],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.00),
                                        child: Text(
                                          "View Quotation",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: <Widget>[
                                Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text("Client reviewed"),
                                )
                              ],
                            );
                          }
                        }

                        if (dataFinal['status'] == "success") {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    isScrollControlled: true,
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
                                                    "QUOTATION DETAILS",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: quotationDetails(
                                                dataFinal['quotation_id'],
                                                dataFinal['send_date_and_time'],
                                                dataFinal['file_name'],
                                                dataFinal[
                                                    'client_review_status'],
                                                dataFinal['customerPhone']
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                leading: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.pink,
                                ),
                                title: Text(
                                  StringUtils.capitalize(
                                      dataFinal['send_date_and_time']),
                                ),
                                subtitle: Wrap(
                                  children: <Widget>[
                                    clientReviewedStatus(),
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
                              child: Text("No quotations found"),
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
