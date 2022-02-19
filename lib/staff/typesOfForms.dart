import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../settingsAllFle.dart';

class typesOfForms extends StatefulWidget {
  _typesOfForms createState() => _typesOfForms();
}

class _typesOfForms extends State<typesOfForms> {
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            ActionChip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Text('LP'),
              ),
              label: const Text('LLP Registration'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var serverUrlfinal =
                    "${SettingsAllFle.finalURl}/send-form-to-client";

                var response =
                    await http.post(Uri.parse(serverUrlfinal), headers: {
                  "Accept": "application/json"
                }, body: {
                  "staffId": prefs.getString('userId'),
                  "jobCardId": prefs.getString('jobCardId'),
                  "form_type": "llp-registration"
                });
                // print(response.body);
                var rep = json.decode(response.body);
                if (rep[0]['status'] == "success") {
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Successfully generated',
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (rep[0]['status'] == "already-assigned") {
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Request already generated!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
            Container(
              margin: EdgeInsets.only(
                left: 15.00,
              ),
              child: ActionChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: const Text('PL'),
                ),
                label: const Text('Pvt Ltd Registration'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var serverUrlfinal =
                      "${SettingsAllFle.finalURl}/send-form-to-client";

                  var response =
                      await http.post(Uri.parse(serverUrlfinal), headers: {
                    "Accept": "application/json"
                  }, body: {
                    "staffId": prefs.getString('userId'),
                    "jobCardId": prefs.getString('jobCardId'),
                    "form_type": "pvt-ltd-registration"
                  });
                  //print(response.body);
                  var rep = json.decode(response.body);
                  if (rep[0]['status'] == "success") {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          'Successfully generated',
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (rep[0]['status'] == "already-assigned") {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Request already generated!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 15.00,
              ),
              child: ActionChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: const Text('GT'),
                ),
                label: const Text('GST Registration'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var serverUrlfinal =
                      "${SettingsAllFle.finalURl}/send-form-to-client";

                  var response =
                      await http.post(Uri.parse(serverUrlfinal), headers: {
                    "Accept": "application/json"
                  }, body: {
                    "staffId": prefs.getString('userId'),
                    "jobCardId": prefs.getString('jobCardId'),
                    "form_type": "gst-registration"
                  });
                  //print(response.body);
                  var rep = json.decode(response.body);
                  if (rep[0]['status'] == "success") {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          'Successfully generated',
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (rep[0]['status'] == "already-assigned") {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Request already generated!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
