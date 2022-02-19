import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class assign_dept_al extends StatefulWidget {
  _assign_dept_al createState() => _assign_dept_al();
}

class _assign_dept_al extends State<assign_dept_al> {
  bool isChecked = false;
  CollectionReference _departments_list =
      FirebaseFirestore.instance.collection('departments');
  CollectionReference _enquiries =
      FirebaseFirestore.instance.collection('enquiries');
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Assign Department"),
      ),
      body: SingleChildScrollView(
          child: StreamBuilder(
        stream: _departments_list.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) =>
                  // Text(streamSnapshot.data!.docs[index]['amount']),

                  Column(
                children: <Widget>[
                  ListTile(
                    title: Text(snapshot.data!.docs[index]['department_name']),
                    onTap: () async {
                      final postUrl = 'https://fcm.googleapis.com/fcm/send';
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      AlertDialog alert = AlertDialog(
                        title: Text("Are you sure ? "),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                  'This will assign "${snapshot.data!.docs[index]['department_name']}" department to followup this enquiry . Are you sure ?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          RoundedLoadingButton(
                            child: Text('PROCEED',
                                style: TextStyle(color: Colors.white)),
                            color: Colors.blue[800],
                            borderRadius: 3.00,
                            controller: _btnController,
                            onPressed: () async {
                              // print("Assigned department doc id : " + snapshot.data!.docs[index].id );
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.getString('enquiry_document_id');
                              await _enquiries
                                  .doc(prefs.getString('enquiry_document_id'))
                                  .update({
                                'assigned_staff_doc_id':
                                    snapshot.data!.docs[index].id,
                                'admin_view_status': 'viewed',
                              });

                              final QuerySnapshot result = await _users
                                  .where('department',
                                  isEqualTo: snapshot.data!.docs[index]
                                  ['department_name'])
                                  .get();
                              final List<DocumentSnapshot> documents = result.docs;
                              documents.forEach((element) async {
                                //print("username : " + element['username'].toString());
                                var staff_device_id = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where('department_name',
                                    isEqualTo: snapshot.data!.docs[index].id)
                                    .get()
                                    .then((value) async {
                                  final data = {
                                    "registration_ids": [element['deviceId']],
                                    "collapse_key": "type_a",
                                    "notification": {
                                      "title": 'New task assigned',
                                      "body": 'Admin assigned you a new task',
                                    }
                                  };

                                  final headers = {
                                    'content-type': 'application/json',
                                    'Authorization':
                                    'key=AAAAUUmzTzc:APA91bHbzGr90h2Hpx1wAfokljehgPobk1X9OK7hg0oyfRPlqM6x7JJCOtCJ7MnEJWHeKtTzQcdcH4TkwFMzdwJWG--slZiXfW1o7_SQr6UbwJxrBs_Hddg8ZHfKXJyMDQJphg7C5R84'
                                    // 'key=YOUR_SERVER_KEY'
                                  };

                                  final response = await http.post(
                                      Uri.parse(postUrl),
                                      body: json.encode(data),
                                      encoding: Encoding.getByName('utf-8'),
                                      headers: headers);
                                  print("Response is : " + response.body);
                                  if (response.statusCode == 200) {
                                    // on success do sth
                                    Fluttertoast.showToast(
                                        msg: "Successfully assigned",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              set_this_user_to_regular_followup()),
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Some errors found",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    // on failure do sth

                                  }
                              });

                              /* sending FCM message */
                              //snapshot.data!.docs[index].id


                              });

                              /* ends here */
                            },
                          )
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
                  Divider(),
                ],
              ),
            );
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
      )),
    );
  }
}

class set_this_user_to_regular_followup extends StatefulWidget {
  _set_this_user_to_regular_followup createState() =>
      _set_this_user_to_regular_followup();
}

class _set_this_user_to_regular_followup
    extends State<set_this_user_to_regular_followup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Assign staff to customer"),
      ),
    );
  }
}
