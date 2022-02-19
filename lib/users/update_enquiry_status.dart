import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SingingCharacter { upload_documents, mark_as_completed }

class update_enquiry_status extends StatefulWidget {
  final enquiry_doc_id;

  update_enquiry_status(this.enquiry_doc_id);

  _update_enquiry_status createState() => _update_enquiry_status();
}

class _update_enquiry_status extends State<update_enquiry_status> {
  SingingCharacter? _character = SingingCharacter.upload_documents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text("UPDATE ENQUIRY"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Image(image: AssetImage('assets_files/enquiry_update.png')),
                ListTile(
                  title: const Text('Request to upload documents'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.upload_documents,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Mark as completed'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.mark_as_completed,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 40.0,
          color: Colors.green,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('enquiry_doc_id', widget.enquiry_doc_id);
                      if (_character.toString() ==
                          "SingingCharacter.upload_documents") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => upload_required_docs()),
                        );
                      } else {
                        DateFormat formatter =
                            DateFormat("dd-MM-yyyy HH:mm:ss");
                        final DateTime now = DateTime.now();
                        FirebaseFirestore.instance
                            .collection('enquiries')
                            .doc(widget.enquiry_doc_id)
                            .update(
                          {
                            'status': 'completed',
                            'completed_on': formatter.format(now)
                          },
                        ).then((value) {
                          Fluttertoast.showToast(
                              msg: "Successfully updated",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          prefs.setString(
                              'staff_dash_my_jobs_listing_tab', 'load_now');
                          Navigator.pushNamed(context, 'staff_dash_load');
                        }).catchError((error) =>
                                print("Failed to update user: $error"));
                      }
                    },
                    child: const Text('NEXT'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[800],
                      padding: EdgeInsets.only(bottom: 0.00),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class upload_required_docs extends StatefulWidget {
  _upload_required_docs createState() => _upload_required_docs();
}

class _upload_required_docs extends State<upload_required_docs> {
  final _formKey = GlobalKey<FormState>();
  final _document_name = new TextEditingController();
  final _document_name_db = new TextEditingController();
  String dropdownValue = 'Select document type';
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("What documents required?"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(image: AssetImage('assets_files/add_doc.png')),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: Row(
                        children: <Widget>[
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('documents_list_to_update')
                                .snapshots(),
                            builder:
                                (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.data != null) {
                                return DropdownButton<String>(
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline:
                                      Container(height: 2, color: Colors.black),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  value: dropdownValue,
                                  items: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    //print("Docment are : " + document.toString());
                                    return DropdownMenuItem<String>(
                                      value: document['doc_name'],
                                      child: Text(document['doc_name']),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.4),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            tooltip: 'Add new document type',
                            onPressed: () {
                              Widget okButton = FlatButton(
                                child: Text("UPDATE NOW"),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('documents_list_to_update')
                                      .add({
                                    'doc_name': dropdownValue,
                                  }).then((value) {
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                        msg:
                                            "Document type successfully updated",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }).catchError((error) =>
                                          print("Failed to add user: $error"));
                                },
                              );
                              AlertDialog alert = AlertDialog(
                                title: Text("Add new document type"),
                                content: TextFormField(
                                  controller: _document_name_db,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.only(left: 5.00),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                                actions: [
                                  okButton,
                                ],
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            },
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.document_scanner_sharp,
                                size: 21,
                              ),
                              tooltip: 'Document types',
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, 'saved_document_types');
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: RoundedLoadingButton(
        color: Colors.blue[800],
        borderRadius: 1.00,
        width: MediaQuery.of(context).size.width,
        child: Text('UPDATE NOW', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () async {
          if (dropdownValue == "Select document type") {
            Fluttertoast.showToast(
                msg: "Please select another option",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            _btnController.reset();
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.getString('enquiry_doc_id');

            print("Doc ID : " + prefs.getString('enquiry_doc_id').toString());
            FirebaseFirestore.instance
                .collection('enquiries')
                .doc(prefs.getString('enquiry_doc_id'))
                .update({dropdownValue: 'not_found'}).then((value) async {
              await FirebaseFirestore.instance
                  .collection('enquiries')
                  .doc(prefs.getString('enquiry_doc_id'))
                  .get()
                  .then((value) async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(value['user_document_id'])
                    .get()
                    .then((value2) async {
                      /* update status record */
                  FirebaseFirestore.instance.collection('document_upload_status_table').add({
                    'user_doc_id': value['user_document_id'],
                    'need_to_upload' : dropdownValue
                  })
                      .then((value) => print("User Added"))
                      .catchError((error) => print("Failed to add user: $error"));
                  /* ends here */
                 // print("users_device id is :" + value2['deviceId'].toString());
                  final postUrl = 'https://fcm.googleapis.com/fcm/send';
                  final data = {
                    "registration_ids": [value2['deviceId']],
                    "collapse_key": "type_a",
                    "notification": {
                      "title": 'Upload required documents',
                      "body":
                          'Corproots requested you to upload required documents.',
                    }
                  };

                  final headers = {
                    'content-type': 'application/json',
                    'Authorization':
                        'key=AAAAUUmzTzc:APA91bHbzGr90h2Hpx1wAfokljehgPobk1X9OK7hg0oyfRPlqM6x7JJCOtCJ7MnEJWHeKtTzQcdcH4TkwFMzdwJWG--slZiXfW1o7_SQr6UbwJxrBs_Hddg8ZHfKXJyMDQJphg7C5R84'
                    // 'key=YOUR_SERVER_KEY'
                  };
                  final response = await http.post(Uri.parse(postUrl),
                      body: json.encode(data),
                      encoding: Encoding.getByName('utf-8'),
                      headers: headers);
                  print("Response is : " + response.body);
                  if (response.statusCode == 200) {
                    // on success do sth
                    print('test ok push CFM');
                  } else {
                    print(' CFM error');
                    // on failure do sth

                  }
                });
              });

              Fluttertoast.showToast(
                  msg: "Successfully posted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              _btnController.reset();
            }).catchError((error) {
              Fluttertoast.showToast(
                  msg: "Some errors found",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              _btnController.reset();
            });
          }
        },
      ),
    );
  }
}
