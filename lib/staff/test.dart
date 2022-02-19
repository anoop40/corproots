import 'dart:async';
import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:corproots/admin/assign_staff_for_lead.dart';
import 'package:corproots/registered_users/EnquiryDetails.dart';
import 'package:corproots/staff/jobCardDetails.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../settingsAllFle.dart';

class MyJobs extends StatefulWidget {
  _MyJobs createState() => _MyJobs();
}

class _MyJobs extends State<MyJobs> {
  late Future str;
  late List myJobs;
  var colorScheme;
  var font_color;

  @override
  void initState() {
    super.initState();
    //getAllJobList();
    str = getData();
  }

  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 =
  RoundedLoadingButtonController();

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-my-enquiries";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "userId": prefs.getString('userId'),
    });
    print(response.body);
    this.setState(() {
      myJobs = json.decode(response.body) as List<dynamic>;
    });

    return "1";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: getData,
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: ListView.builder(
                      itemCount: myJobs.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> dataFinal = myJobs[index];

                        if (dataFinal['enquiry_attend_status_staff']
                            .toString() ==
                            "not_viewed") {
                          colorScheme = Colors.red[400];
                          font_color = Colors.white;
                        } else {
                          //colorScheme = Colors.white;
                          font_color = Colors.black;
                        }
                        if (dataFinal['status'] == "success") {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Ink(
                                color: colorScheme,
                                child: ListTile(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    prefs.setString(
                                        'enquiry_id', dataFinal['enquiry_id']);

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
                                                      "JOB CARD DETAILS",
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
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width,
                                                child: jobcardDetails(
                                                    dataFinal['enquiry_id']),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        child: IconButton(
                                          iconSize: 20,
                                          icon: new Icon(
                                            Icons.phone_in_talk,
                                            color: font_color,
                                          ),
                                          highlightColor: Colors.pink,
                                          onPressed: () async {
                                            final url =
                                                "tel:${dataFinal['mobile_number']}";
                                            if (await canLaunch(url) != null) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: IconButton(
                                            iconSize: 18,
                                            icon: FaIcon(
                                              FontAwesomeIcons.userCheck,
                                              color: Colors.black,
                                            ),
                                            highlightColor: Colors.pink,
                                            onPressed: () async {
                                              SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                              prefs.setString('enqyiryId',
                                                  dataFinal['enquiry_id']);
                                              prefs.setString('jobCardId',
                                                  dataFinal['job_card_id']);

                                              Navigator.pushNamed(
                                                  context, "jobCardDetails");
                                            }),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    StringUtils.capitalize(
                                        dataFinal['userName']),
                                    style: TextStyle(
                                      color: font_color,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 10.00),
                                        child: Icon(
                                          Icons.date_range_sharp,
                                          size: 12,
                                          color: font_color,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5.00),
                                        child: Text(
                                          dataFinal['enquiry_date_and_time'],
                                          style: TextStyle(
                                            color: font_color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.4),
                            child: Center(
                              child: Text("No pending jobs found"),
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
        });
  }
}
