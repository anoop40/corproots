import 'package:corproots/settingsAllFle.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class userProfile extends StatefulWidget {
  _userProfile createState() => _userProfile();
}

class _userProfile extends State<userProfile> {
  var customerDetails;
  late Future str;
  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "${SettingsAllFle.finalURl}/get-all-user-profile";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "job_card_Id": prefs.getString('jobCardId'),
    });
    print("From server :" + response.body);
    this.setState(() {
      customerDetails = json.decode(response.body);
    });

    return "1";
  }

  @override
  void initState() {
    super.initState();
    str = getDetails();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          child: Image.asset('assets_files/customer details.png'),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 21,
          ),
          child: Text(
            "CUSTOMER DETAILS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        FutureBuilder(
          future: str,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 18,
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Text(
                        "Customer Name : ",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 18,
                      ),
                      child: Text(
                        customerDetails[0]['user_name'],
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 22,
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Text(
                        "Contact Number : ",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 22,
                      ),
                      child: Text(
                        customerDetails[0]['mobile_number'],
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 22,
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Text(
                        "Customer Email : ",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 22,
                      ),
                      child: Text(
                        customerDetails[0]['email'],
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 22,
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Text(
                        "Registered On : ",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 22,
                      ),
                      child: Text(
                        customerDetails[0]['registered_on'],
                      ),
                    )
                  ],
                ),
              ]);
            } else {
              return Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}
