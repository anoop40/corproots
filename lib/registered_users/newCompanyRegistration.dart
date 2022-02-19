import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class newCompanyRegistration extends StatefulWidget {
  _newCompanyRegistration createState() => _newCompanyRegistration();
}

class _newCompanyRegistration extends State<newCompanyRegistration> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(child: Text("Overview")),
              Tab(child: Text("Benefits")),
              Tab(child: Text("Pre-requisites")),
              Tab(child: Text("Deliverables")),
              Tab(child: Text("FAQs")),
            ],
          ),
          title: Text('Register new company'),
        ),
        bottomNavigationBar: Container(
          child: RoundedLoadingButton(
              width: MediaQuery.of(context).size.width,
              curve: Curves.fastOutSlowIn,
              child: Text("ENQUIRE NOW"),
              controller: _btnController,
              borderRadius: 4,
              onPressed: () async {
                showModalBottomSheet<void>(
                  isDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                  "Private Limited Company Registration Request",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: new Icon(
                                    Icons.close,
                                    size: 24.0,
                                  ),
                                  color: Colors.pink,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _btnController.reset();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Container(
                            child: Text(
                              "Are you sure you want to create the request?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Text(
                              "By clicking on confirm, a ticket witll be generated for the process of Private Limited Company Registrations",
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Text(
                              "Customer Support agent will call you shortly to assist you in the process.",
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _btnController.reset();
                              },
                              child: Text("Cancel"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: RoundedLoadingButton(
                              borderRadius: 1,
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var serverUrlfinal =
                                    "${SettingsAllFle.finalURl}new-enquiry";
                                var response_ur = await http
                                    .post(Uri.parse(serverUrlfinal), body: {
                                  "mobile_number":
                                      prefs.getString('mobile_number'),
                                  "userId": prefs.getString('userId'),
                                  "enquiry_category": "new-company-registration"
                                }, headers: {
                                  "Accept": "application/json"
                                });
                                //print(response_ur.body);
                                //json.decode(response_ur.body);
                                var respo = json.decode(response_ur.body);
                                if (respo[0]['status'] == "success") {
                                  _btnController2.success();
                                  Timer(Duration(seconds: 1), () async {
                                    Navigator.pushNamed(context, "dashboard");
                                  });
                                }
                              },
                              width: MediaQuery.of(context).size.width,
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
              }),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Container(
                  child: TabBarView(
                    children: [
                      Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.1,
                              ),
                              child: Text(
                                "Register a company in India",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.02),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                "A Private Limited Company is the most popular type of corporate entity in India.It is registered as per the compliance and regulatory guidelines of the Ministry of Coroprate Affairs(MCA)",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.02),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: new Column(
                                children: <Widget>[
                                  new ListTile(
                                    leading: Icon(
                                      Icons.fiber_manual_record,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                    title: new Text(
                                      'Offers protection for your company assets',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.fiber_manual_record,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                    title: new Text(
                                      'Attracts more customers',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.fiber_manual_record,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                    title: new Text(
                                      'Helps increase the potential to grow and expand',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.fiber_manual_record,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                    title: new Text(
                                      'Protects from personal liabilities',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04,
                              ),
                              child: Text(
                                "Documents to be submitted by all Directors",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.fiber_manual_record,
                                color: Colors.black,
                                size: 12,
                              ),
                              title: new Text(
                                'Pan card',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.fiber_manual_record,
                                color: Colors.black,
                                size: 12,
                              ),
                              title: new Text(
                                "ID Proof (Driving License/Voter's ID/ Passport copy)",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.fiber_manual_record,
                                color: Colors.black,
                                size: 12,
                              ),
                              title: new Text(
                                "Address Proof(Bank Statement/Telephone Bill/Mobile Bill/Electricity Bill(Latest month)",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04,
                              ),
                              child: Text(
                                "Private LImited Company - Deliverables",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.fiber_manual_record,
                                color: Colors.black,
                                size: 12,
                              ),
                              title: new Text(
                                'Directors Identification Numebr for 2 Directors',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.fiber_manual_record,
                                color: Colors.black,
                                size: 12,
                              ),
                              title: new Text(
                                "Digital Signature Certificate for 2 Directors(If the shareholders are different from directors,then additional DSC is required for Shareholders)",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.fiber_manual_record,
                                color: Colors.black,
                                size: 12,
                              ),
                              title: new Text(
                                "Address Proof(Bank Statement/Telephone Bill/Mobile Bill/Electricity Bill(Latest month)",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text("FAQ"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
