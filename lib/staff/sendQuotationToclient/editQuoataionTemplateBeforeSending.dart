import 'package:cool_alert/cool_alert.dart';
//import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';

import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:open_file/open_file.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../settingsAllFle.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class editQuoataionTemplateBeforeSending extends StatefulWidget {
  _editQuoataionTemplateBeforeSending createState() =>
      _editQuoataionTemplateBeforeSending();
}

class _editQuoataionTemplateBeforeSending
    extends State<editQuoataionTemplateBeforeSending> {
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
  var _responseF;
  late Future str;
  late Directory _localPath;
  var statusString = "Creating quotation";
  var header;
  var footer;

var finalHTMLcontent;
  Future getTemplateDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "${SettingsAllFle.finalURl}/get-template-details";

    var response = await http.post(
      Uri.parse(serverUrlfinal),
      headers: {"Accept": "application/json"},
      body: {
        "templateId": prefs.getString('selectedTemplate'),
      },
    );
    setState(() {
      _responseF = json.decode(response.body);
    });

    //print("From server : " + response.body);
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getTemplateDetails();
  }

  showLoaderDialog(BuildContext context, _etEditor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 15), child: Text(statusString)),
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
      /* pdf creation starts here */

      //_localPath = await DownloadsPathProvider.downloadsDirectory;
      //var targetPath = Directory(_localPath.path);
      var uuid = Uuid();
      final fileName = uuid.v1();
      var targetFileName = fileName.toString();

      File generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          _etEditor, _localPath.path, targetFileName);
/* ends here */
      String url = "${SettingsAllFle.finalURl}generatedQuotation";

      var uri = Uri.parse(url);

      var request = http.MultipartRequest('POST', uri)
        ..fields['userId'] = prefs.getString('userId')!
        ..fields['enquiryId'] = prefs.getString('selectedEnquiryId')!
        ..files.add(await http.MultipartFile.fromPath(
          'quotationFile',
          generatedPdfFile.path,
        ));
      var response = await request.send();
      print("from server"+response.statusCode.toString());
      if (response.statusCode.toString() != null) {

        await successalert(generatedPdfFile.path);
      }
    } else {
      final snackBar = SnackBar(content: Text('All fields are required'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _btnController.reset();
    }
  }

  successalert(fileName) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("HOME"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 21.0),
            child: Center(
              child: Icon(
                Icons.check_box_outlined,
                size: 60,
                color: Colors.green,
              ),
            ),
          ),
          Container(
            child: Text("Quotation created successfully .."),
          )
        ],
      ),
      actions: [
        TextButton(
          child: Text("Home"),
          onPressed: () {
            Navigator.pushNamed(context, 'userDashboard');
          },
        ),
        ElevatedButton(
          onPressed: () {
            OpenFile.open(fileName);
          },
          child: Text('Load Quotation'),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    /*
    return CoolAlert.show(
      barrierDismissible: false,
     confirmBtnText: "Home",
      onConfirmBtnTap: (){
       // OpenFile.open(fileName);
        Navigator.pushNamed(context, '/userDashboard');
      },


      cancelBtnText: "Home",
      onCancelBtnTap: (){
        Navigator.pushNamed(context, '/userDashboard');
      },
      context: context,
      type: CoolAlertType.success,
      text: "Quotation successfully created..",
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Template Content"),
      ),
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // Insert widget into tree

                          FlutterSummernote(
                              value: _responseF[0]['template_content'],
                              showBottomToolbar: false,
                              height: MediaQuery.of(context).size.height * 0.8,
                              key: _keyEditor,
                              customToolbar: """
            [
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['table', ['table']],
                ['para', ['ul', 'ol', 'paragraph']],
            ]""")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        child: ElevatedButton(
          onPressed: () async {
            _etEditor = await _keyEditor.currentState?.getText();
            header = "<html><body><div style='width:100%;'><img style='float:right;' src='${SettingsAllFle.finalURl}uploads/corproots-e1574146264545.png' /></div>";

            footer = "</body></html>";
            finalHTMLcontent = header + _etEditor + footer;
            //print(_etEditor.isEmpty);
            bool stat = _etEditor.isEmpty;
            //print("Stat is : " + stat.toString());
            if (stat == false) {
              //print("entered value : " + _etEditor);
              showLoaderDialog(context, finalHTMLcontent);
            }
          },
          child: Text('GENERATE QUOTATION'),
        ),
      ),
    );
  }
}
