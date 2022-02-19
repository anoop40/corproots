import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class AssignStaffForLead extends StatefulWidget {
  String enquiry_id;

  AssignStaffForLead(this.enquiry_id);

  _AssignStaffForLead createState() => _AssignStaffForLead();
}

class _AssignStaffForLead extends State<AssignStaffForLead> {
  late Future str;
  late List users;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-staffs-details";

    var response = await http.post(Uri.parse(serverUrlfinal),
        headers: {"Accept": "application/json"});
    //print(response.body);
    this.setState(() {
      users = json.decode(response.body) as List<dynamic>;
    });

    return "1";
  }

  @override
  void initState() {
    super.initState();
    str = getData();
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
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.blue[800]),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                              bottom: MediaQuery.of(context).size.height * 0.02,
                              left: 15.00),
                          child: Text(
                            "ASSIGN STAFF",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> dataFinal = users[index];
                            return Column(
                              children: <Widget>[
                                ListTile(
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
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red[900]),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .height *
                                                              0.01,
                                                          bottom: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .height *
                                                              0.01,
                                                          left: 15.00),
                                                      child: Text(
                                                        "CLIENT MANAGER",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.1,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.9,
                                                child: Center(
                                                  child: Text(
                                                    "This will assign ${dataFinal['user_name']} as client manager . Are you sure ? ",
                                                  ),
                                                ),
                                                padding:
                                                EdgeInsets.only(top: 15.00),
                                              ),

                                              Container(

                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.02,
                                                ),
                                                child: RoundedLoadingButton(
                                                  onPressed: () async {
                                                    print("selected user id : " +
                                                        dataFinal['userId']);
                                                    SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                    var serverUrlfinal =
                                                        "${SettingsAllFle.finalURl}assign-enquiry-to-staff";
                                                    var response_ur = await http
                                                        .post(
                                                        Uri.parse(
                                                            serverUrlfinal),
                                                        body: {
                                                          "userId":
                                                          dataFinal['userId'],
                                                          "enquiry_id":
                                                          widget.enquiry_id
                                                        },
                                                        headers: {
                                                          "Accept":
                                                          "application/json"
                                                        });
                                                    print(response_ur.body);
                                                    //json.decode(response_ur.body);
                                                    var respo = json
                                                        .decode(response_ur.body);
                                                    if (respo[0]['status'] ==
                                                        "success") {
                                                      _btnController2.success();
                                                      Timer(Duration(seconds: 1),
                                                              () async {
                                                            Navigator.pop(context);
                                                          });
                                                    }
                                                  },
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  curve: Curves.fastOutSlowIn,
                                                  child: Text("PROCEED"),
                                                  controller: _btnController2,
                                                  borderRadius: 2.00,
                                                  color: Colors.blue[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  title: Text(dataFinal['user_name']),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone,
                                        size: 12,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5.00),
                                        child: Text(
                                          dataFinal['mobile_number'],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5.00),
                                        child: Icon(
                                          Icons.unsubscribe_rounded,
                                          size: 12,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5.00),
                                        child: Row(children: <Widget>[
                                          Text(
                                            dataFinal['pending_projects']
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5.00),
                                            child: Text(
                                              "Pending jobs",
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/140x100')),
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}
