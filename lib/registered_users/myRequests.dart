import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'package:url_launcher/url_launcher.dart';

class MyRequests extends StatefulWidget {
  _MyRequests createState() => _MyRequests();
}

class _MyRequests extends State<MyRequests> {
  late List myEnquiries;
  late Future str;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-my-enquiries-user";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "userId": prefs.getString('userId'),
    });
    print("REsponse form server : " + response.body);
    this.setState(() {
      myEnquiries = json.decode(response.body) as List<dynamic>;
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
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topLeft,
                  image: AssetImage("assets_files/background2.png"),
                  fit: BoxFit.contain,
                ),
              ),
              child: Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: myEnquiries.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> dataFinal = myEnquiries[index];

                      if (dataFinal["status"] == "success") {
                        return Container(
                          decoration: new BoxDecoration(
                            color: Colors.white70,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.questionCircle,
                                  color: Colors.blue,
                                ),
                                title: Text(dataFinal['enquiry_category']),
                                subtitle: Row(
                                  children: <Widget>[
                                    FaIcon(
                                      FontAwesomeIcons.calendar,
                                      size: 13,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5, top: 5),
                                      child: Text(
                                        dataFinal['enquiry_date_and_time'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: FaIcon(
                                        FontAwesomeIcons.spinner,
                                        size: 13,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5, top: 5),
                                      child: Text(
                                        dataFinal['enquiry_process_status'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    )
                                  ],
                                ),
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
                                            Container(
                                              child: Text(
                                                "Enquiry Details",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              margin: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                            ),
                                            Divider(),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 29.00),
                                                    child:
                                                        Text("Enquiry Type : "),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: Text(dataFinal[
                                                        'enquiry_category']),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.005,
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 29.00),
                                                    child: Text(
                                                        "Enquiry Posted On : "),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: Text(dataFinal[
                                                        'enquiry_date_and_time']),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.005,
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 29.00),
                                                    child: Text(
                                                        "Enquiry Status : "),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.spinner,
                                                      size: 13,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(dataFinal[
                                                        'enquiry_process_status']),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.005,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      var url =
                                                          'tel:${dataFinal['staffContactNumber']}';
                                                      if (await canLaunch(
                                                          url)) {
                                                        await launch(url);
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.phone,
                                                          size: 17,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 4.00),
                                                          child:
                                                              Text('CALL NOW'),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.005,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                      left: 5.00),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      final link =
                                                          WhatsAppUnilink(
                                                        phoneNumber: "+91" +
                                                            dataFinal[
                                                                'staffContactNumber'],
                                                        text: "Hi",
                                                      );
                                                      // Convert the WhatsAppUnilink instance to a string.
                                                      // Use either Dart's string interpolation or the toString() method.
                                                      // The "launch" method is part of "url_launcher".
                                                      await launch('$link');
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        FaIcon(
                                                            FontAwesomeIcons
                                                                .whatsapp,
                                                            size: 17),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 4.00),
                                                          child:
                                                              Text('MESSAGE'),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.4),
                          child: Center(
                            child: Text("No enquiries found"),
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
    );
  }
}
