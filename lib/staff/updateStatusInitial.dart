import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../settingsAllFle.dart';

class updateStatusInitial extends StatefulWidget {
  String job_card_id;
  updateStatusInitial(this.job_card_id);
  _updateStatusInitial createState() => _updateStatusInitial();
}

enum BestTutorSite { yes, no }

class _updateStatusInitial extends State<updateStatusInitial> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _statusFinal = TextEditingController();
  bool valuefirst = false;
  BestTutorSite _site = BestTutorSite.yes;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: Container(
        child: RoundedLoadingButton(
            width: MediaQuery.of(context).size.width,
            curve: Curves.fastOutSlowIn,
            child: Text("UPDATE NOW"),
            controller: _btnController,
            borderRadius: 4,
            onPressed: () async {
              var comments = _statusFinal.text;
              //print("comment is  " + comments.toString());
              var serverUrlfinal =
                  "${SettingsAllFle.finalURl}/add-initial-stage-followup";

              var response =
                  await http.post(Uri.parse(serverUrlfinal), headers: {
                "Accept": "application/json"
              }, body: {
                "job_card_id": widget.job_card_id,
                "didYoucall": _site.toString(),
                "comments": comments.toString()
              });
              var responseF = json.decode(response.body);
              if (responseF[0]['status'] == "success") {
                _btnController.success();
                Timer(Duration(seconds: 1), () async {
                  Navigator.pushNamed(context, "jobCardDetails");
                });
              }
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image(image: AssetImage('assets_files/customer_call.jpg')),
            ),
            Container(
              child: Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.06,
                  top: 19.00,
                ),
                child: Text(
                  "Initial step status",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: 17.00,
                top: 20.00,
              ),
              child: Text("Did you call customer?"),
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: BestTutorSite.yes,
                  groupValue: _site,
                  onChanged: (BestTutorSite? value) {  },

                  /*
                  onChanged: (BestTutorSite value) {
                    setState(() {
                      _site = value;
                    });
                  },

                   */

                ),
                Text("Yes"),
                Radio(
                  value: BestTutorSite.no,
                  groupValue: _site,
                  onChanged: (BestTutorSite? value) {  },

                  /*
                  onChanged: (BestTutorSite value) {
                    setState(() {
                      _site = value;
                    });
                  },

                   */
                ),
                Text("No")
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: 17.00,
                top: 20.00,
              ),
              child: Text("Status"),
            ),
            Container(
              margin: EdgeInsets.only(top: 11.00),
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _statusFinal,
                maxLines: 8,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
