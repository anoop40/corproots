import 'dart:convert';

import 'package:corproots/admin/clientAccountDetails.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../settingsAllFle.dart';

class ClientsList extends StatefulWidget {
  _ClientsList createState() => _ClientsList();
}

class _ClientsList extends State<ClientsList> {
  late List clientList;
  late Future str;

  getData() async {
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-customers";

    var response = await http.post(Uri.parse(serverUrlfinal),
        headers: {"Accept": "application/json"});
    print(response.body);
    this.setState(() {
      clientList = json.decode(response.body) as List<dynamic>;
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
          child: FutureBuilder(
            future: str,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: clientList.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> dataFinal = clientList[index];
                    return Padding(
                      padding: EdgeInsets.only(top: 9.00),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: ClipOval(
                              child: Image(
                                image: NetworkImage(
                                    "${SettingsAllFle.finalURl}/uploads/pexels-photo-220453.jpeg"),
                              ),
                            ),
                            title: Text(dataFinal['user_name']),
                            subtitle: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 15,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 3.00),
                                  child: Text(
                                    dataFinal['registered_on'],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.00),
                                  child: Icon(
                                    Icons.phone,
                                    size: 15,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 3.00),
                                  child: Text(
                                    dataFinal['mobile_number'],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.only(bottom: 13.00),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 15.00,
                                                bottom: 15.00,
                                                left: 10.00),
                                            child: Text(
                                              "CLIENT DETAILS",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.blue[800]),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.00),
                                          child: Container(
                                            child: Text(
                                              "PERSONAL DETAILS",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.94,
                                          ),
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.00),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("Customer Name : "),
                                                Text(dataFinal['user_name'])
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 20.00),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("Contact Number : "),
                                                Text(dataFinal['mobile_number'])
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 20.00),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("Email : "),
                                                Text(dataFinal['email'])
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 20.00),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("Registered On : "),
                                                Text(dataFinal['registered_on'])
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.00),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 9.00),
                                                child: ElevatedButton(
                                                  child: Row(
                                                    children: <Widget>[
                                                      FaIcon(
                                                        FontAwesomeIcons
                                                            .rupeeSign,
                                                        size: 13,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.00),
                                                        child: Text('ACCOUNTS'),
                                                      )
                                                    ],
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            clientAccountDetails(
                                                          dataFinal['userId'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.blue[800],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 9.00),
                                                child: ElevatedButton(
                                                  child: Row(
                                                    children: <Widget>[
                                                      FaIcon(
                                                        FontAwesomeIcons.tasks,
                                                        size: 13,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.00),
                                                        child:
                                                            Text('JOB HISTORY'),
                                                      )
                                                    ],
                                                  ),
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.orange[800],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 9.00),
                                                child: ElevatedButton(
                                                  child: Row(
                                                    children: <Widget>[
                                                      FaIcon(
                                                        FontAwesomeIcons.trash,
                                                        size: 13,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.00),
                                                        child: Text('DELETE'),
                                                      )
                                                    ],
                                                  ),
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red[800],
                                                  ),
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
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(
                    child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4),
                  child: CircularProgressIndicator(),
                ));
              }
            },
          ),
        ));
  }
}
