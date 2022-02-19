import 'package:corproots/registered_users/newforms/newllpRegistration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class MyDashboardItems extends StatefulWidget {
  _MyDashboardItems createState() => _MyDashboardItems();
}

class AdaptiveTextSize {
  const AdaptiveTextSize();

  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

class _MyDashboardItems extends State<MyDashboardItems> {
  var pendingForms;
  late Future str;
  @override
  void initState() {
    super.initState();
    str = getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal =
        "${SettingsAllFle.finalURl}/check-pending-form-submission";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "userId": prefs.getString('userId'),
    });
    //print("From server : " + response.body);
    this.setState(() {
      pendingForms = json.decode(response.body) as List<dynamic>;
    });

    return "1";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: getData,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topLeft,
              image: AssetImage("assets_files/background2.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: FutureBuilder(
                  future: str,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: pendingForms.length,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> dataFinal =
                              pendingForms[index];
                          if (dataFinal['status'].toString() ==
                              "not_submitted") {
                            return Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const ListTile(
                                    leading: Icon(Icons.album),
                                    title: Text('Submit application'),
                                    subtitle: Text(
                                        'Thank you for your enquiry. Please click following link and submit your data'),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      TextButton(
                                        child: const Text('UPDATE DATA'),
                                        onPressed: () async {
                                          if (dataFinal['form_type'] ==
                                              "llp-registration") {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                'form_assigned_to_clint_table_id',
                                                dataFinal['refferenceId']);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Newllp()),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              child: Text(""),
                            );
                          }
                        },
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 30.00,
                        ),
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  top: 15,
                ),
                child: Wrap(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "newRequest");
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Image(
                                width: 85,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                image:
                                    AssetImage('assets_files/new_request.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Text("New Request"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "howToVideos",
                        );
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Image(
                                width: 85,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                image: AssetImage(
                                    'assets_files/customer_support.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Text("How to ?"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Image(
                                width: 85,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                image: AssetImage(
                                    'assets_files/latest_news_all.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Text("Announcemets"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Text(
                  "Our Services",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  top: 15,
                ),
                child: Wrap(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "newCompanyRegistration");
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Image(
                                width: 85,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                image: AssetImage(
                                    'assets_files/company_register.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Text("Company"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Image(
                                width: 85,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                image: AssetImage('assets_files/tax.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Text("Tax & Filing"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Image(
                                width: 85,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                image: AssetImage('assets_files/tm.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Text("Trademark"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
