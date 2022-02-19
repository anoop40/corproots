import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

import '../settingsAllFle.dart';
import '../settingsAllFle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WebViewNewLoad extends StatefulWidget {
  final fileName;
  final fileId;

  WebViewNewLoad(this.fileName, this.fileId);

  _WebViewNewLoad createState() => _WebViewNewLoad();
}

class _WebViewNewLoad extends State<WebViewNewLoad> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  var _textBtnState;
  var _barrier = true;
  var _deletionStat = "false";

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text('Are you sure?'),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.25),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'This will delete document from server. This is irreversible . '),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RoundedLoadingButton(
                  width: MediaQuery.of(context).size.width * 0.4,
                  curve: Curves.fastOutSlowIn,
                  child: Text("Proceed"),
                  controller: _btnController,
                  borderRadius: 4,
                  onPressed: () async {
                    var serverUrlfinal =
                        "${SettingsAllFle.finalURl}/delete-user-file";

                    var response =
                        await http.post(Uri.parse(serverUrlfinal), headers: {
                      "Accept": "application/json"
                    }, body: {
                      "fileId": widget.fileId,
                    });
                    print("REsponse form server : " + response.body);
                    var res = json.decode(response.body);
                    if (res[0]['status'] == "success") {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('File deleted successfully'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'myDocumentsUser');
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Document"),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
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
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: WebView(
                      initialUrl:
                          '${SettingsAllFle.finalURl}uploads/${widget.fileName}',
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 0.00),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          bottom: 0.00,
                        ),
                        margin: EdgeInsets.only(
                          bottom: 0.00,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          tooltip: 'Increase volume by 10',
                          onPressed: () {
                            _showMyDialog();
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 0.00),
                        margin: EdgeInsets.only(top: 0.00),
                        child: Text("Delete"),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
