import 'package:corproots/admin/assign_staff_for_lead.dart';
import 'package:corproots/registered_users/EnquiryDetails.dart';
import 'package:corproots/staff/jobCardDetails.dart';
import 'package:corproots/staff/typesOfForms.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../settingsAllFle.dart';
import 'package:http/http.dart' as http;

class enquiriesByUser extends StatefulWidget {
  _enquiriesByUser createState() => _enquiriesByUser();
}

class _enquiriesByUser extends State<enquiriesByUser> {
  late Future str;
  late List userEnquiries;
  late String jobCardId;
  var enquriryStatus;

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
    var serverUrlfinal =
        "${SettingsAllFle.finalURl}/get-enquiry-list-by-user-id";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "job_card_id": prefs.getString('jobCardId'),
    });
    print(json.decode(response.body));
    this.setState(() {
      userEnquiries = json.decode(response.body) as List<dynamic>;
      jobCardId = prefs.getString('job_card_Id')!;
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
                child: ListView.builder(
                  itemCount: userEnquiries.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> dataFinal = userEnquiries[index];
                    if (dataFinal['enquiry_process_status'].toString() ==
                        "processing") {
                      enquriryStatus = IconButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('enqyiryId', dataFinal['enquiry_id']);
                          Navigator.pushNamed(context, 'enquiryDetails');
                        },
                        icon: Icon(
                          Icons.offline_pin_outlined,
                          color: Colors.pink,
                        ),
                      );
                    } else {
                      enquriryStatus = Icon(
                        Icons.check,
                        color: Colors.green,
                      );
                    }
                    return Column(
                      children: <Widget>[
                        Container(
                          child: ListTile(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.getString('userId') ==
                                  dataFinal['assigned_empolyee']) {
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: typesOfForms(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'You are not assigned as agent by admin'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(child: enquriryStatus),
                              ],
                            ),
                            title: Text(
                              dataFinal['enquiry_category'],
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 10.00),
                                  child: Icon(
                                    Icons.date_range_sharp,
                                    size: 12,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.00),
                                  child: Text(
                                    dataFinal['enquiry_date_and_time'],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10.00),
                                  child: Icon(
                                    Icons.verified_user_sharp,
                                    size: 12,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.00),
                                  child: Text(
                                    dataFinal['assigned_empolyee_name'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
