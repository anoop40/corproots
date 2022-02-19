import 'dart:isolate';
import 'dart:ui';

import 'package:corproots/registered_users/webViewLoad.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';
import 'RegisteredUserDrawer.dart';
import 'cameraFileForAlertBox.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class MyDocumentsUser extends StatefulWidget {
  _MyDocumentsUser createState() => _MyDocumentsUser();
}

class _MyDocumentsUser extends State<MyDocumentsUser> {
  late bool _imagePickStatus;
  bool _imageUploadStatus = false;
  var _scannedDocument;
  var _documentHeading = TextEditingController();
  late File filePat1;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isdisabled = true;
  var _uploadImagePath;
  late Directory _localPath;
  var userIdFoun;

  var _imageUploadStat = Container(
    margin: EdgeInsets.only(
      top: 10.00,
    ),
    child: Text("No data"),
  );
  late List myDocs;
  late Future str;

  Future MyDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-my-documents-user";


    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "userId": prefs.getString('userId'),
    });
    //print("From server documents : " + response.body);
    this.setState(() {
      myDocs = json.decode(response.body) as List<dynamic>;
    });

    return "1";
  }

  _currently_uploaded_img(filePat) {
    if (filePat != null) {
      setState(
        () {
          showModal();
          setState(() {
            filePat1 = File(filePat);
            _imagePickStatus = true;
            _scannedDocument = ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(filePat1));
          });
        },
      );
    } else {
      setState(() {
        _imagePickStatus = false;
      });
    }
  }

  checkPhotoStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('documentCameraPick')) {
      showModal();
      setState(() {
        filePat1 = File(prefs.getString('documentCameraPick').toString());
        _imagePickStatus = true;
        _scannedDocument = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(filePat1));
      });
    } else {
      setState(() {
        _imagePickStatus = false;
      });
    }
  }

  showModal() {
    return showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        // we set up a container inside which
        // we create center column and display text
        return Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.00, bottom: 10.0),
                  width: MediaQuery.of(context).size.width * 0.94,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _documentHeading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Document heading required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Document heading',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: _scannedDocument,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 6.00, bottom: 7.00),
                      child: OutlinedButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('documentCameraPick');
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0))),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 6.00, bottom: 7.00, left: 10.00),
                      child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            showModalBottomSheet(
                                isDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: 20.00,
                                                height: 20.00,
                                                margin: EdgeInsets.only(
                                                    right: 15.00),
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              Text("Updating please wait")
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            var uri = Uri.parse(
                                SettingsAllFle.finalURl + "upload-documents");
                            //print("Uri is : " + uri.toString());
                            var request = http.MultipartRequest('POST', uri)
                              ..fields['userId'] = prefs.getString('userId')!
                              ..fields['documentHeading'] =
                                  _documentHeading.text
                              ..files.add(await http.MultipartFile.fromPath(
                                'userfile',
                                filePat1.path,
                              ));

                            var response = await request.send();
                            print("response data : " +
                                response.statusCode.toString());
                            if (response.statusCode.toString() == "200") {
                              prefs.remove('documentCameraPick');

                              setState(() {
                                _imageUploadStatus = true;
                              });
                            }
                          }
                        },
                        child: Text('Upload'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> openCameraFuction() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    Navigator.of(context).pop();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPhotoStatus();
    str = MyDocuments();
  }

  @override
  Widget build(BuildContext context) {
    Future showSnackbar() async {
      final snackBar = SnackBar(
        content: Text('Files uploaded successfully!'),
        backgroundColor: Colors.green,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (_imageUploadStatus == true) {
      Navigator.of(context).pop();
      showSnackbar();
    }
    return Scaffold(
      drawer: RegisteredUserDrawer(),
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            // context and builder are
            // required properties in this widget
            context: context,
            builder: (BuildContext context) {
              // we set up a container inside which
              // we create center column and display text
              return Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "DOCUMENT SOURCE",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            WidgetsFlutterBinding.ensureInitialized();
                            final cameras = await availableCameras();
                            final firstCamera = cameras.first;
                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraFile(
                                        camera: firstCamera,
                                        returnUrl: "myDocumentsUser",
                                        uploadDocumentType: "document",
                                      )),
                            );
                            */

                            openCameraFuction();
                          },
                          icon: FaIcon(FontAwesomeIcons.camera),
                          label: Text("USE CAMERA"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                        ),
                        child: Text(
                          "OR",
                        ),
                      ),
                      Container(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    allowCompression: true,
                                    type: FileType.custom,
                                    allowedExtensions: [
                                  'jpg',
                                  'png',
                                  'jpeg',
                                  'pdf'
                                ]);

                            if (result != null) {


                              _currently_uploaded_img(result.files.single.path);
                            } else {
                              print("User cancelled");
                              // User canceled the picker
                            }
                          },
                          icon: FaIcon(FontAwesomeIcons.fileImage),
                          label: Text("GALLERY"),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("My documents"),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: str,
          builder: (builder, snapshot) {
            if (snapshot.hasData) {

              return RefreshIndicator(
                onRefresh: MyDocuments,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topLeft,
                        image: AssetImage("assets_files/background2.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: myDocs.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> dataFinal = myDocs[index];
                        if(dataFinal['status'] == "success") {
                          return Column(
                            children: <Widget>[
                              Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white70,
                                ),
                                child: ListTile(
                                  leading: FaIcon(FontAwesomeIcons.file),
                                  title: Text(dataFinal['file_heading']),
                                  onTap: () async {
                                    // await showUploadedFile(dataFinal['id']);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WebViewNewLoad(
                                                  dataFinal['file_name'],
                                                  dataFinal['id'])),
                                    );
                                  },
                                  subtitle: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 8.00,
                                          right: 4.00,
                                        ),
                                        child: FaIcon(
                                          FontAwesomeIcons.fileAlt,
                                          size: 12,
                                        ),
                                      ),
                                      Text(
                                        dataFinal['file_type'],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 8.00,
                                          right: 2.00,
                                        ),
                                        child: FaIcon(
                                          FontAwesomeIcons.calendarAlt,
                                          size: 12,
                                        ),
                                      ),
                                      Text(
                                        dataFinal['uploaded_on'],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        }
                        else{
                          return Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                            child: Center(
                              child: Text("No data found"),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
