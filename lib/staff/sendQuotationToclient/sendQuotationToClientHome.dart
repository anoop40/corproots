import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../settingsAllFle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class sendQuotationToClientHome extends StatefulWidget {
  _sendQuotationToClientHome createState() => _sendQuotationToClientHome();
}

class _sendQuotationToClientHome extends State<sendQuotationToClientHome> {
  var _currentState;
  var _pageTitle;
  late double screenWidth;
  late double screenHeight;
  late List createdTemplates;
  late Future str;
  int _selectedIndex = 0;

  Future getData() async {
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-templates";

    var response = await http.post(Uri.parse(serverUrlfinal),
        headers: {"Accept": "application/json"});
    print(response.body);
    this.setState(() {
      createdTemplates = json.decode(response.body) as List<dynamic>;
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
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Select Template"),
      ),
      // extendBodyBehindAppBar: true,
      //body: _currentState,
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                width: ui.window.physicalSize.width,
                /*
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topLeft,
                        image: AssetImage("assets_files/background2.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    */
                child: SizedBox(
                  height: ui.window.physicalSize.height * 0.8,
                  child: RefreshIndicator(
                    onRefresh: getData,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: createdTemplates.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> dataFinal =
                            createdTemplates[index];
                        return Column(
                          children: <Widget>[
                            Ink(
                              child: ListTile(
                                selected: index == _selectedIndex,
                                leading: Icon(Icons.file_present),
                                title: Text(
                                  dataFinal['templateName'],
                                ),
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                  prefs.setString('selectedTemplate',
                                      dataFinal['template_id']);
                                  Navigator.pushNamed(context, 'editQuoataionTemplateBeforeSending');
                                },
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      /*
      bottomNavigationBar: Container(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('NEXT'),
        ),
      ),
      */
    );
  }
}
