import 'package:corproots/staff/clientDetailsLoading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../settingsAllFle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';

class MyClients extends StatefulWidget {
  _MyClients createState() => _MyClients();
}

class _MyClients extends State<MyClients> {
  late List myClients;
  late Future str;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/get-my-clients-list";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "userId": prefs.getString('userId'),
    });
    //print("From server is : "+response.body);
    this.setState(() {
      myClients = json.decode(response.body) as List<dynamic>;
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
            return RefreshIndicator(
                onRefresh: getData,
                child: ListView.builder(
                  itemCount: myClients.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> dataFinal = myClients[index];

                    if (dataFinal['status'] == "success") {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ListTile(
                              onTap: () async {
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
                                                  "CLIENT DETAILS",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                            /*
                                          child: jobcardDetails(
                                              dataFinal['job_card_id']),
                                          */
                                            child: clientDetailsLoading(
                                                dataFinal['clientId']),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },

                              title: Text(
                                StringUtils.capitalize(dataFinal['user_name']),
                              ),
                              subtitle: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 10.00),
                                    child: FaIcon(
                                      FontAwesomeIcons.mobileAlt,
                                      size: 14,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.00),
                                    child: Text(
                                      dataFinal['mobile_number'],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10.00),
                                    child: FaIcon(
                                      FontAwesomeIcons.calendar,
                                      size: 14,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.00),
                                    child: Text(
                                      dataFinal['registered_on'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
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
                            top: MediaQuery.of(context).size.height * 0.4),
                        child: Center(
                          child: Text("No pending jobs found"),
                        ),
                      );
                    }
                  },
                ));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
