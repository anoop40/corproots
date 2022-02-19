import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class paidInvoices extends StatefulWidget {
  _notifications_user createState() => _notifications_user();
}

class _notifications_user extends State<paidInvoices> {
  late List notifications;
  late Future str;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-notifications";

    var response = await http.post(Uri.parse(serverUrlfinal), body: {
      'userId': prefs.getString('userId'),
      'payment_status' : "paid"
    }, headers: {
      "Accept": "application/json"
    });
    //print("NOtifications : " + response.body.toString());
    this.setState(() {
      notifications = json.decode(response.body) as List<dynamic>;
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
    return FutureBuilder(
      future: str,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> dataFinal = notifications[index];

                  if(dataFinal['status'] == "success") {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: Colors.blue,
                          ),
                          title: Row(
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.rupeeSign,
                                size: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2.00),
                                child: Text(dataFinal['amount']),
                              )
                            ],
                          ),
                          subtitle: Text(dataFinal['description']),
                          trailing: Text(
                            "Paid",
                            style: TextStyle(color: Colors.green[800]),
                          ),
                          onTap: (){

                          },
                        ),
                        Divider(),
                      ],
                    );
                  }
                  else{
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                        child: Text("No records found"),
                      ),
                    );
                  }
                },
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
