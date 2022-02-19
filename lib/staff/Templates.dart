import 'package:flutter/material.dart';

import '../settingsAllFle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class Templates extends StatefulWidget {
  _Templates createState() => _Templates();
}

class _Templates extends State<Templates> {
  late List createdTemplates;
  late Future str;
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
    // TODO: implement build
    return Scaffold(
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: createdTemplates.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> dataFinal =
                          createdTemplates[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.file_present),
                            title: Text(
                              dataFinal['templateName'],
                            ),

                            onTap: () {
                              showModalBottomSheet<void>(
                                isDismissible: true,
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                "Template",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        SingleChildScrollView(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.9,
                                              margin: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.02,
                                              ),
                                              child : Html(
                                                data: dataFinal['template_content'],

                                              )
                                            /*
                                          child: Text(
                                              dataFinal['template_content']),
                                          */
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      'Deleting Template'),
                                                  content: const Text(
                                                      'This will delete template from database. Are you sure?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        var serverUrlfinal =
                                                            "${SettingsAllFle.finalURl}/delete-template";

                                                        var response =
                                                            await http.post(
                                                          Uri.parse(
                                                              serverUrlfinal),
                                                          headers: {
                                                            "Accept":
                                                                "application/json"
                                                          },
                                                          body: {
                                                            "template_id":
                                                                dataFinal[
                                                                    'template_id']
                                                          },
                                                        );
                                                        //print(response.body);
                                                        var responseF =
                                                            json.decode(
                                                                response.body);
                                                        if (responseF[0]
                                                                ['status'] ==
                                                            "success") {
                                                          Navigator.pop(
                                                              context);
                                                          final snackBar = SnackBar(
                                                              content: Text(
                                                                  'Successfully deleted'));

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        }
                                                      },
                                                      child:
                                                          const Text('Proceed'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.delete,
                                                  size: 19,
                                                ),
                                                Text("DELETE")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );

                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "createNewTemplate",
          );
        },
        label: const Text('New Template'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
