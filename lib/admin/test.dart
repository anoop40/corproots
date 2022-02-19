import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../settingsAllFle.dart';

class Users extends StatefulWidget {
  _users createState() => _users();
}

class _users extends State<Users> {
  late Future str;
  late List users;
  final RoundedLoadingButtonController _btnController2 =
  RoundedLoadingButtonController();
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-users";

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
    return RefreshIndicator(
      onRefresh: getData,
      child: FutureBuilder(
          future: str,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
                floatingActionButton: FloatingActionButton(
                  elevation: 0.00,
                  onPressed: () {
                    Navigator.pushNamed(context, "addNewUser");
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blue[800],
                ),
                body: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> dataFinal = users[index];
                    return Column(
                      children: <Widget>[
                        ListTile(
                          trailing: IconButton(
                            iconSize: 19,
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                            tooltip: 'Delete user',
                            onPressed: () {
                              // print(dataFinal['userId']);
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
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.9,
                                          margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.03,
                                          ),
                                          child: Text(
                                            "Are you sure to delete this user?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.9,
                                          margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.02,
                                            bottom: 20.00,
                                          ),
                                          child: Text(
                                            "This will delete user from database. This is not reversible.",
                                          ),
                                        ),
                                        Container(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          child: RoundedLoadingButton(
                                            borderRadius: 2,
                                            onPressed: () async {
                                              SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                              var serverUrlfinal =
                                                  "${SettingsAllFle.finalURl}deleteStaff";
                                              var response_ur = await http.post(
                                                  Uri.parse(serverUrlfinal),
                                                  body: {
                                                    "userId":
                                                    dataFinal['userId']
                                                  },
                                                  headers: {
                                                    "Accept": "application/json"
                                                  });
                                              //print(response_ur.body);
                                              //json.decode(response_ur.body);
                                              var respo =
                                              json.decode(response_ur.body);
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
                                            child: Text("Proceed"),
                                            controller: _btnController2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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
                                margin: EdgeInsets.only(left: 10.00),
                                child: Icon(
                                  Icons.verified_user,
                                  size: 12,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5.00),
                                child: Text(
                                  dataFinal['userType'],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
