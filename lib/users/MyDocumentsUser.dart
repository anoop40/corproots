import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corproots/CameraFile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDocumentsUser extends StatefulWidget {
  _MyDocumentsUser createState() => _MyDocumentsUser();
}

class _MyDocumentsUser extends State<MyDocumentsUser> {
  final _fileName = new TextEditingController();
  final _documentNameForm = GlobalKey<FormState>();
  late Future str;
  late List _documents;
  late var _user_document_id;

  getDataAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*
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
    */
    if (prefs.containsKey('user_document_id')) {
      setState(() {
        _user_document_id = prefs.getString('user_document_id');
      });
    } else {
      setState(() {
        _user_document_id = "12";
      });
    }
    print("My request doc id :" + _user_document_id);
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getDataAll();
  }
/*
  _check_for_notifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*
    FirebaseFirestore.instance.collection("document_upload_status_table").where('user_doc_id',isEqualTo: prefs.getString('user_document_id')).get().then((querySnapshot) {
      if(querySnapshot.hasData){

      }
      querySnapshot.docs.forEach((result) {


      });
    });
    */
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("document_upload_status_table")
        .where('user_doc_id', isEqualTo: prefs.getString('user_document_id'))
        .get()
    .then((querySnapshot){
      final List<DocumentSnapshot> documents = querySnapshot.docs;
      if(documents.length > 0){
        print("Some documents are found");
        return true;
      }
      else{

        print("No documents found");

      }
      return Text("");
    });
    return "1";
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text("My Documents"),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: str,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.zero,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('enquiries')
                        .where('user_document_id', isEqualTo: _user_document_id)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.data != null) {
                        if (streamSnapshot.data!.docs.length > 0) {
                          return Column(
                            children: <Widget>[
                            //  _check_for_notifications(),
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: streamSnapshot.data!.docs.length,
                                  itemBuilder: (ctx, index) {
                                    // Text(streamSnapshot.data!.docs[index]['amount']),

                                    return Column(
                                      children: <Widget>[

                                        ListTile(
                                          title: Text(streamSnapshot.data!
                                              .docs[index]['enquiry_category']),
                                          subtitle: Padding(
                                            padding:
                                                EdgeInsets.only(top: 14.00),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  size: 15,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.00),
                                                  child: Text(streamSnapshot
                                                          .data!.docs[index]
                                                      ['enquiry_date']),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.00),
                                                  child: Icon(
                                                    Icons.verified_user,
                                                    size: 15,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.00),
                                                  child: Text(streamSnapshot
                                                      .data!
                                                      .docs[index]['status']),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    );
                                  })
                            ],
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.4),
                              child: Column(
                                children: <Widget>[
                                  Text("Login to view your requests"),
                                  Padding(
                                    padding: EdgeInsets.only(top: 6.00),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, 'loginSignup');
                                      },
                                      child: Text('LOGIN / SIGNUP'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.4),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
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
