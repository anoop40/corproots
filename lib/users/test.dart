import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:corproots/CameraFile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class MyDocumentsUser extends StatefulWidget {
  _MyDocumentsUser createState() => _MyDocumentsUser();
}

class _MyDocumentsUser extends State<MyDocumentsUser> {
  final _fileName = new TextEditingController();
  final _documentNameForm = GlobalKey<FormState>();
  late Future str;
  late List _documents;

  getDataAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}list-my-documents-user";

    var response_ur = await http.post(Uri.parse(serverUrlfinal), body: {
      "userId": prefs.getString('userId'),
    }, headers: {
      "Accept": "application/json"
    });
    //print("From server : " + response_ur.body);
    this.setState(() {
      _documents = json.decode(response_ur.body) as List<dynamic>;
    });
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getDataAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text("My Documents"),
        ),
        body: FutureBuilder(
          future: str,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _documents.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> dataFinal = _documents[index];
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(dataFinal['file_heading']),
                          subtitle: Row(
                            children: <Widget>[
                              Icon(
                                Icons.upload_file_outlined,
                                size: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.00),
                                child: Text(dataFinal['file_type']),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16.00),
                                child: Icon(
                                  Icons.date_range_sharp,
                                  size: 14,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.00),
                                child: Text(dataFinal['uploaded_on']),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.delete_outline_outlined,
                            size: 19,
                            color: Colors.red[600],
                          ),
                          onTap: () {
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(
                                        child: Padding(
                                            padding: EdgeInsets.only(top: 17),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              '${SettingsAllFle.finalURl}uploads/${dataFinal['file_name']}',
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                  downloadProgress) =>
                                                  SizedBox(
                                                    width: 50.00,
                                                    height: 50.00,
                                                    child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                  Icon(Icons.error),
                                            )),
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.8,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.9,
                                      ),
                                      ElevatedButton(
                                        child: const Text('Close'),
                                        onPressed: () => Navigator.pop(context),
                                      )
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
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "IMAGE SOURCE",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: () async {
                              //Navigator.pop(context);

                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                  allowCompression: true,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'jpg',
                                    'png',
                                    'jpeg',
                                    'pdf'
                                  ]);
                              //print("File path is : " + result!.files.single.path!);
                              //_currently_uploaded_img(result!.files.single.path!);
                              /* updateFilename section */
                              /*
                              AlertDialog alert = AlertDialog(
                                content: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // CircularProgressIndicator(),
                                    // Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
                                    Form(
                                      key: _documentNameForm,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        controller: _fileName,
                                        decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText: 'Document heading'),
                                      ),
                                    ),
                                    ElevatedButton(
                                      child: const Text('UPLOAD'),
                                      onPressed: () async {
                                        if (_documentNameForm.currentState!
                                            .validate()) {
                                          /*ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Processing Data')),
                                          );
                                          */
                                          var serverUrlfinal =
                                              "${SettingsAllFle.finalURl}upload-documents";
                                          var request = http.MultipartRequest(
                                              'POST', Uri.parse(serverUrlfinal))
                                            ..fields['userId'] =
                                                prefs.getString('userId')!
                                            ..fields['documentHeading'] =
                                                _fileName.text
                                            ..files.add(await http.MultipartFile
                                                .fromPath(
                                                    'userfile',
                                                    result!.files.single.path
                                                        .toString()));
                                          var response = await request.send();
                                          CoolAlert.show(
                                              onConfirmBtnTap: () {
                                                Navigator.pushNamed(
                                                    context, 'myDocumentsUser');
                                              },
                                              context: context,
                                              type: CoolAlertType.success,
                                              text:
                                                  'File uploaded successfully!');
                                        }
                                      },
                                    ),
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

                               */
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.home,
                                  size: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.00,
                                  ),
                                  child: Text("GALLERY"),
                                )
                              ],
                            ),
                          ),
                        ),
                        Text("OR"),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: () async {
                              WidgetsFlutterBinding.ensureInitialized();

                              // Obtain a list of the available cameras on the device.
                              final cameras = await availableCameras();
                              //print("Available cameras : "+cameras.toString());
                              // Get a specific camera from the list of available cameras.
                              final firstCamera = cameras.first;
                              //print("First camera is : " + firstCamera.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CameraFile(camera: firstCamera)),
                              );
                              /*
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CameraFile(
                                    firstCamera,
                                    "addressProof",
                                    "PAN Card",
                                  ),
                                ),
                              );

                               */
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.camera_alt_sharp,
                                  size: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.00,
                                  ),
                                  child: Text("CAMERA"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          label: const Text('UPLOAD NEW'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blue[800],
        ));
  }

  Widget _buildButton(
      {VoidCallback? onTap, required String text, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MaterialButton(
        color: color,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
