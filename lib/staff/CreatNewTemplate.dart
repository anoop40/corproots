import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../settingsAllFle.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

import 'newTemplate/template_content.dart';


class CreatNewTemplate extends StatefulWidget {
  _CreatNewTemplate createState() => _CreatNewTemplate();
}

class _CreatNewTemplate extends State<CreatNewTemplate> {
  var currentState;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final templateName = TextEditingController();
  final _templateContent = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var welcomeText;

  GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();

  loadingWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Template Name"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Image.asset('assets_files/template_registre_here.jpeg'),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 40.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: templateName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter template name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Eg.Quotation for LLP registration'),
                      ),
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
            if (_formKey.currentState!.validate()) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('templateName', templateName.text);
              setStateFunction();
            } else {
              final snackBar =
                  SnackBar(content: Text('All fields are required'));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("NEXT"),
              Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //currentStateSet = firstState;
    currentState = loadingWidget();
  }

  setStateFunction() {
    this.setState(() {
      currentState = Template_content();
    });
  }

  /*setting state */

  @override
  Widget build(BuildContext context) {
    return currentState;
  }
}
