import 'dart:ui';

import 'package:corproots/registered_users/webViewLoad.dart';
import 'package:corproots/staff/filesUploaded/documentList.dart';
import 'package:corproots/staff/filesUploaded/dropDownButton.dart';
import 'package:corproots/staff/filesUploaded/requestsSendToClientToUploadDocs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:camera/camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';

import '../../settingsAllFle.dart';

class DropdownButtonClass extends StatefulWidget {
  _DropDownButton createState() => _DropDownButton();
}

class _DropDownButton extends State<DropdownButtonClass> {
  String dropdownValue = 'ID Proof';
  late File filePat1;
  final _formKey = GlobalKey<FormState>();

  var userIdFoun;
  late TextEditingController _customeMessage;
  int _selectedIndex = 0;
  late List myDocs;
  late Future str;
  var _status_update = Row(
    children: [
      CircularProgressIndicator(),
      Container(margin: EdgeInsets.only(left: 20), child: Text("Updating...")),
    ],
  );
  //var defaultText = "Dear sir/madam, please upload your documents";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _customeMessage = TextEditingController(text: "Dear sir/madam, please upload your documents");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(

          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 15.00,
                left: 12.00,
              ),
              child: Text(
                "REQUEST TO UPLOAD DOCUMENT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.00, bottom: 15.00),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          /*
                          onChanged: (String newValue) {
      if(newValue.toString() != "Other Document"){
        setState(() {
          _customeMessage = TextEditingController(text: "Dear sir/madam, please upload your ${newValue} documents");
        });
      }
                            setState(() {
                              dropdownValue = newValue;

                            });
                            //print("Drop down value is : " + newValue);

                          },

                           */
                          items: <String>[
                            'ID Proof',
                            'Adhar Card',
                            'PAN Card',
                            'Driving License',
                            'Rental Agreement',
                            'Company Registration Certificate',
                            'Other Document'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 13.00, right: 13.00, bottom: 15.00),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        controller: _customeMessage,
                        maxLines: 15,
                        decoration: InputDecoration(

                            border: OutlineInputBorder(),
                            hintText: 'Custom Message'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            AlertDialog alert = AlertDialog(
              content: _status_update,
            );
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(
                'customMessageToClientToUploadDoc', _customeMessage.text);
            var serverUrlfinal =
                "${SettingsAllFle.finalURl}/request-new-file-upload";

            var response = await http.post(Uri.parse(serverUrlfinal), headers: {
              "Accept": "application/json"
            }, body: {
              "custom_message": _customeMessage.text,
              "customer_id": prefs.getString('fetchingUsersId'),
              "staff_id": prefs.getString('userId'),
            });
            print(response.body);
            var resp = json.decode(response.body);
            if (resp[0]['status'].toString() == "success") {
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
              final snackBar = SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text("Success! Request send successfully ..")),
                  ],
                ),
              );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        },
        child: Text('SEND NOW'),
      ),
    );
  }
}
