import 'package:flutter/material.dart';

import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../settingsAllFle.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Template_content extends StatefulWidget {
  _Template_content createState() => _Template_content();
}

class _Template_content extends State<Template_content> {
  var currentState;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final templateName = TextEditingController();
  final _templateContent = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var welcomeText;
  var _etEditor;
  bool status = false;
  GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();

  showLoaderDialog(BuildContext context,_etEditor) async {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 15), child: Text(" Updating...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var serverUrlfinal = "${SettingsAllFle.finalURl}/update-templates";

      var response = await http.post(
        Uri.parse(serverUrlfinal),
        headers: {"Accept": "application/json"},
        body: {
          "userId": prefs.getString('userId'),
          "templateName": prefs.getString('templateName'),
          "templateContents": _etEditor,
        },
      );
      var responseF = json.decode(response.body);
      if (responseF[0]['status'] == "success") {
        Navigator.pop(context);
        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: <Widget>[
              Icon(Icons.check),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text('Successfully completed'),
              )
            ],
          ),

        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushNamed(context, '/settings');
      }
    } else {
      final snackBar = SnackBar(content: Text('All fields are required'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Template Content"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  bottom: 10.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Insert widget into tree

                      FlutterSummernote(
                          hint: "Your text here...",
                          key: _keyEditor,
                          customToolbar: """
            [
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['table', ['table']],
                ['para', ['ul', 'ol', 'paragraph']],
            ]""")
                      /*
                      TextFormField(
                        controller: _templateContent,
                        maxLines: 14,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(9.00),
                            border: OutlineInputBorder(),
                            hintText: "Template contents"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter template content";
                          }
                          return null;
                        },
                      ),
                      */
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: ElevatedButton(
          onPressed: () async {
            _etEditor = await _keyEditor.currentState?.getText();

            //print(_etEditor.isEmpty);
            bool stat = _etEditor.isEmpty;
            if (stat == false) {
              //print("Entered value is " + _etEditor.toString());
              showLoaderDialog(context,_etEditor);
            }
          },
          child: Text('UPDATE NOW'),
        ),
        /*
        child: RoundedLoadingButton(
          width: MediaQuery.of(context).size.width,
          curve: Curves.fastOutSlowIn,
          child: Text("UPDATE"),
          controller: _btnController,
          borderRadius: 4,
          onPressed: () async {
            //print("Entered data : " + _templateContent.text);
            //final _etEditor = await _keyEditor.currentState.getText();
            var _etEditor = await _keyEditor.currentState?.getText();
            print("Entered value is " + _etEditor.toString());
            if (_formKey.currentState.validate()) {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              var serverUrlfinal =
                  "${SettingsAllFle.finalURl}/update-templates";

              var response = await http.post(
                Uri.parse(serverUrlfinal),
                headers: {"Accept": "application/json"},
                body: {
                  "userId": prefs.getString('userId'),
                  "templateName": prefs.getString('templateName'),
                  "templateContents": _etEditor,
                },
              );
              var responseF = json.decode(response.body);
              if (responseF[0]['status'] == "success") {
                _btnController.success();
              }
            } else {
              final snackBar =
              SnackBar(content: Text('All fields are required'));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              _btnController.reset();
            }
          },
        ),
        */
      ),
    );
  }
}
