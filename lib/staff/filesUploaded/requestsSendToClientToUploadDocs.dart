import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../settingsAllFle.dart';

class RequestsSendToClientToUploadDocs extends StatefulWidget {
  _RequestsSendToClientToUploadDocs createState() =>
      _RequestsSendToClientToUploadDocs();
}

class _RequestsSendToClientToUploadDocs
    extends State<RequestsSendToClientToUploadDocs> {
  late Future str;
  late List _requests;
  var _documentUpdatedLower;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal =
        "${SettingsAllFle.finalURl}/load-requests-fileuploads-posted";

    var response = await http.post(Uri.parse(serverUrlfinal),
        headers: {"Accept": "application/json"},
        body: {"customer_id": prefs.getString('fetchingUsersId')});
    print("PEnding JObs : " + response.body);
    this.setState(() {
      _requests = json.decode(response.body) as List<dynamic>;
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
    return FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: getData,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> dataFinal = _requests[index];
                      titleText() {
                        if (dataFinal['upload_status'] == "not_uploaded") {
                          return Row(
                            children: <Widget>[
                              SizedBox(
                                width: 13.00,
                                height: 13.00,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 6.00),
                                child: Text("Waiting to upload"),
                              )
                            ],
                          );
                        } else {
                          return Row(
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                size: 19.00,
                                color: Colors.green,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2.00),
                                child: Text("Uploaded"),
                              )
                            ],
                          );
                        }
                      }

                      subtitleTextGoesHere() {
                        if (dataFinal['upload_status'] == "not_uploaded") {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 6,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range_outlined,
                                  size: 19.00,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.00),
                                  child: Text("Req Date : "),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.00),
                                  child: Text(dataFinal[
                                  'request_generate_date_and_time']),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 6,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range_outlined,
                                  size: 19.00,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.00),
                                  child: Text("Submtd Date : "),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.00),
                                  child: Text(
                                      dataFinal['submitted_date_and_time']),
                                )
                              ],
                            ),
                          );
                        }
                      }

                      if (dataFinal['status'].toString() == "success") {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: ListTile(
                                onTap: () async {
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
                                                top: 15.00,
                                              ),
                                              child: const Text(
                                                'REQUEST STATUS',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                            Divider(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.01),
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: Text(
                                                        "Current Status : "),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 7.0),
                                                    child: titleText(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.02),
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: Text(
                                                        "Request Generated on : "),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 7.0),
                                                    child: Text(dataFinal[
                                                    'request_generate_date_and_time']),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.02),
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: Text(
                                                        "Submitted on  : "),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 7.0),
                                                    child: titleText(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.02,
                                                bottom: 15.00,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 15.0,
                                                    ),
                                                    child: Text(
                                                        "Message to client : "),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 7.0),
                                                    child: Wrap(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.62,
                                                          child: Text(dataFinal[
                                                          'custom_message']),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.05,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10.00),
                                                    child: InputChip(
                                                      onPressed: () async {

                                                        final url =
                                                            "tel:${dataFinal['customer_mob_number']}";
                                                        if (await canLaunch(url) != null) {
                                                          await launch(url);
                                                        } else {
                                                          throw 'Could not launch $url';
                                                        }
                                                      },
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                        Colors.orange[400],
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .phone,
                                                          size: 13,
                                                        ),
                                                      ),
                                                      label: const Text(
                                                          'Call client'),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10.00),
                                                    child: InputChip(
                                                      onPressed: () async {
                                                        await launch(
                                                            "https://wa.me/+91${dataFinal['customer_mob_number']}?text=Hello");
                                                      },
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                        Colors.green[300],
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .whatsapp,
                                                          size: 13,
                                                        ),
                                                      ),
                                                      label: const Text(
                                                          'Whats app'),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10.00),
                                                    child: InputChip(
                                                      onPressed: () async {

                                                      },
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                        Colors.pink[300],
                                                        child: Icon(
                                                          Icons.notifications_outlined,
                                                          size: 13,
                                                        ),
                                                      ),
                                                      label: const Text(
                                                          'Push msg'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                leading: Icon(Icons.question_answer_outlined),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[],
                                ),
                                title: SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.8,
                                  child: titleText(),
                                ),
                                subtitle: subtitleTextGoesHere(),
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
                            child: Text("No requests found"),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
