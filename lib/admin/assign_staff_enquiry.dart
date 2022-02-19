import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class assign_staff_enquiry extends StatefulWidget {
  _assign_staff_enquiry createState() => _assign_staff_enquiry();
}

class _assign_staff_enquiry extends State<assign_staff_enquiry> {
  bool isChecked = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference _enquiries =
      FirebaseFirestore.instance.collection('enquiries');
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
        title: Text("Assign staff"),
      ),
      body: SingleChildScrollView(
          child: StreamBuilder(
        stream: users.where('user_type', isEqualTo: 'staff').snapshots(),
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
                    title: Text(snapshot.data!.docs[index]['username']),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5.00),
                      child: Row(
                        children: <Widget>[
                          Text("Pending Jobs : "),
                          Padding(
                            padding: EdgeInsets.only(left: 2.00),
                            child: Text("59"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.00),
                            child: Text("Department :"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2.00),
                            child: Text("GST"),
                          )
                        ],
                      ),
                    ),
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
                                  'This will assign ${snapshot.data!.docs[index]['username']} to followup this enquiry . Are you sure ?  '),
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

                              /* sending FCM message */
                              var staff_device_id = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index].id)
                                  .get()
                                  .then((value) async {
                                final data = {
                                  "registration_ids": [value['deviceId']],
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
                                            set_this_user_to_regular_followup(
                                                snapshot.data!.docs[index].id)),
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
  var assigned_staff_doc_id;

  set_this_user_to_regular_followup(this.assigned_staff_doc_id);

  _set_this_user_to_regular_followup createState() =>
      _set_this_user_to_regular_followup();
}

class _set_this_user_to_regular_followup
    extends State<set_this_user_to_regular_followup> {
  bool isChecked = false;
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
      return Colors.black;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Assign staff to customer"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image(image: AssetImage('assets_files/assign_permenant.png')),
            Row(
              children: <Widget>[
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text("Set this staff as one point contact for this customer")
              ],
            )
          ],
        ),
      ),
      bottomSheet: RoundedLoadingButton(
        color: Colors.blue[800],
        width: MediaQuery.of(context).size.width,
        borderRadius: 1.05,
        child: Text('UPDATE', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (isChecked == true) {
            // print("Enquiry doc id : "+prefs.getString('enquiry_document_id').toString());
            // FirebaseFirestore.instance.collection('enquiries').doc(prefs.getString('enquiry_document_id').toString()).get();
            await FirebaseFirestore.instance
                .collection('enquiries')
                .doc(prefs.getString('enquiry_document_id').toString())
                .get()
                .then((value) async {
              //print("Client Doc ID Is : " + value['user_document_id'].toString());
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(value['user_document_id'].toString())
                  .update({
                'permanently_assigned_staff_doc_id':
                    widget.assigned_staff_doc_id
              }).then((value) {
                Fluttertoast.showToast(
                    msg: "Successfully Updated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                prefs.setString('admin_dash_tab_option', 'enquiries');
                Navigator.pushNamed(context, 'admin-dash');
              });
            });
          }
          _btnController.reset();
        },
      ),
    );
  }
}
