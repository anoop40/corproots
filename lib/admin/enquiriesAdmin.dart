import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class enquiriesAdmin extends StatefulWidget {
  _enquiriesAdmin createState() => _enquiriesAdmin();
}

class _enquiriesAdmin extends State<enquiriesAdmin> {
  late Future str;
  late List users;
  late List staffList;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  CollectionReference enquiries =
      FirebaseFirestore.instance.collection('enquiries');

  Future getAllStaffList() async {
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-staffs-details";

    var response = await http.post(Uri.parse(serverUrlfinal),
        headers: {"Accept": "application/json"});
    //print("Stffs : " + response.body);
    var saved_staffList = json.decode(response.body);
    this.setState(() {
      staffList = saved_staffList;
    });

    return "1";
  }

  @override
  void initState() {
    super.initState();
    getAllStaffList();
    // str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: enquiries.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    // Text(streamSnapshot.data!.docs[index]['amount']),
                    var enquiry_assingn_statsu;

                    if (snapshot.data!.docs[index]['assigned_staff_doc_id']
                            .toString() !=
                        "null") {
                      enquiry_assingn_statsu = Text(
                        "Staff assigned",
                        style: TextStyle(fontSize: 13),
                      );
                    } else {
                      enquiry_assingn_statsu =
                          Text("Not assigned", style: TextStyle(fontSize: 13));
                    }
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                              snapshot.data!.docs[index]['enquiry_category']),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 8.00),
                            child: Wrap(
                              children: <Widget>[
                                Icon(
                                  Icons.visibility_outlined,
                                  size: 13,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.00),
                                  child: Text(
                                    snapshot.data!.docs[index]
                                        ['admin_view_status'],
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.00),
                                  child: Icon(
                                    Icons.calendar_today,
                                    size: 13,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.00),
                                  child: Text(
                                    snapshot.data!.docs[index]['enquiry_date'],
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.00),
                                  child: Icon(
                                    Icons.verified_user,
                                    size: 13,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.00),
                                  child: enquiry_assingn_statsu,
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 120,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        //Icon(Icons.delete_outline),
                                        Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                                tooltip:
                                                    'Increase volume by 10',
                                                onPressed: () {
                                                  print(
                                                      "Delete button clicked");

                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // user must tap button!
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Are you sure ?'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children: const <
                                                                Widget>[
                                                              Text(
                                                                  'This will remove the enquiry from database..'),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'Cancel'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                                'Proceed'),
                                                            onPressed: () {
                                                              print("Document ID is : " +
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id);
                                                              enquiries
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Successfully Deleted",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity: ToastGravity
                                                                        .CENTER,
                                                                    timeInSecForIosWeb:
                                                                        1,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        16.0);
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              }).catchError(
                                                                      (error) =>
                                                                          print(
                                                                              "Failed to delete entry: $error"));
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              Text('Delete this Enquiry')
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.verified_user_outlined,
                                                  color: Colors.green,
                                                ),
                                                tooltip:
                                                    'Increase volume by 10',
                                                onPressed: () async {
                                                  // set up the buttons
                                                  Widget cancelButton =
                                                      FlatButton(
                                                    child: Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  );
                                                  Widget continueButton =
                                                      FlatButton(
                                                    child: Text("Continue"),
                                                    onPressed: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefs.setString(
                                                          'enquiry_document_id',
                                                          snapshot.data!
                                                              .docs[index].id);
                                                      Navigator.pushNamed(
                                                          context,
                                                          'assign_staff');
                                                    },
                                                  );
                                                  // set up the AlertDialog
                                                  AlertDialog alert =
                                                      AlertDialog(
                                                    title: Text(
                                                        "Enquiry already assigned"),
                                                    content: Text(
                                                        "Would you like to continue ?"),
                                                    actions: [
                                                      cancelButton,
                                                      continueButton,
                                                    ],
                                                  );
                                                  // show the dialog
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alert;
                                                    },
                                                  );
                                                },
                                              ),
                                              Text('Assign Staff')
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              IconButton(
                                                icon: const Icon(
                                                  Icons
                                                      .supervised_user_circle_outlined,
                                                  color: Colors.orange,
                                                ),
                                                tooltip:
                                                    'Increase volume by 10',
                                                onPressed: () async {
                                                  // set up the buttons
                                                  Widget cancelButton =
                                                      FlatButton(
                                                    child: Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  );
                                                  Widget continueButton =
                                                      FlatButton(
                                                    child: Text("Continue"),
                                                    onPressed: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefs.setString(
                                                          'enquiry_document_id',
                                                          snapshot.data!
                                                              .docs[index].id);
                                                      Navigator.pushNamed(
                                                          context,
                                                          'assign_dept');
                                                    },
                                                  );
                                                  // set up the AlertDialog
                                                  AlertDialog alert =
                                                      AlertDialog(
                                                    title: Text(
                                                        "Enquiry already assigned"),
                                                    content: Text(
                                                        "Would you like to continue ?"),
                                                    actions: [
                                                      cancelButton,
                                                      continueButton,
                                                    ],
                                                  );
                                                  // show the dialog
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alert;
                                                    },
                                                  );

                                                  /*
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setString(
                                                      'enquiry_document_id',
                                                      snapshot.data!.docs[index]
                                                          .id);
                                                  Navigator.pushNamed(
                                                      context, 'assign_dept');
                                                */
                                                },
                                              ),
                                              Text('Assign Dept')
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Divider(),
                      ],
                    );
                  });
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
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: getData,
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> dataFinal = users[index];
                    if (dataFinal['status'] == "success") {
                      if (dataFinal['assigned_empolyee'].toString() ==
                          "Not assigned") {
                        return Column(
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                color: Colors.red[400],
                              ),
                              child: ListTile(
                                onTap: () async {
                                  /*
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssignStaffForLead(
                                          dataFinal['enquiry_id']),
                                    ),
                                  );

                                   */
                                  showModalBottomSheet<void>(

                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        color: Colors.amber,
                                        child: Center(
                                          child: AssignStaffForLead(
                                              dataFinal['enquiry_id']),
                                        ),
                                      );
                                    },
                                  );
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      child: IconButton(
                                        iconSize: 19,
                                        icon: new Icon(
                                          Icons.phone_in_talk,
                                          color: Colors.white70,
                                        ),
                                        highlightColor: Colors.pink,
                                        onPressed: () async {
                                          final url =
                                              "tel:${dataFinal['mobile_number']}";
                                          if (await canLaunch(url) != null) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                          print(dataFinal['mobile_number']);
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        iconSize: 19,
                                        icon: const Icon(Icons.delete_outline),
                                        color: Colors.white70,
                                        tooltip: 'Delete enquiry',
                                        onPressed: () {
                                          // print(dataFinal['userId']);
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                      ),
                                                      child: Text(
                                                        "Are you sure to delete this enquiry?",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                        bottom: 20.00,
                                                      ),
                                                      child: Text(
                                                        "This will delete all records regarding this enquiry. This is not reversible.",
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child:
                                                          RoundedLoadingButton(
                                                        borderRadius: 2,
                                                        onPressed: () async {
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          var serverUrlfinal =
                                                              "${SettingsAllFle.finalURl}deleteEnquiry";
                                                          var response_ur =
                                                              await http.post(
                                                                  Uri.parse(
                                                                      serverUrlfinal),
                                                                  body: {
                                                                "enquriy_id":
                                                                    dataFinal[
                                                                        'enquiry_id']
                                                              },
                                                                  headers: {
                                                                "Accept":
                                                                    "application/json"
                                                              });
                                                          print(
                                                              response_ur.body);
                                                          //json.decode(response_ur.body);
                                                          var respo =
                                                              json.decode(
                                                                  response_ur
                                                                      .body);
                                                          if (respo[0]
                                                                  ['status'] ==
                                                              "success") {
                                                            _btnController2
                                                                .success();
                                                            Timer(
                                                                Duration(
                                                                    seconds: 1),
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          }
                                                        },
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        curve: Curves
                                                            .fastOutSlowIn,
                                                        child: Text("Proceed"),
                                                        controller:
                                                            _btnController2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                title: Text(
                                  StringUtils.capitalize(
                                      dataFinal['user_name']),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      size: 12,
                                      color: Colors.white70,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5.00),
                                      child: Text(
                                        dataFinal['mobile_number'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10.00),
                                      child: Icon(
                                        Icons.account_box,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5.00),
                                      child: Text(
                                        StringUtils.capitalize(
                                            dataFinal['assigned_empolyee']),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Container(
                              child: ListTile(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AssignStaffForLead(
                                                dataFinal['enquiry_id']),
                                      ));
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      child: IconButton(
                                        iconSize: 19,
                                        icon: new Icon(
                                          Icons.phone_in_talk,
                                        ),
                                        highlightColor: Colors.pink,
                                        onPressed: () async {
                                          final url =
                                              "tel:${dataFinal['mobile_number']}";
                                          if (await canLaunch(url) != null) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                          print(dataFinal['mobile_number']);
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        iconSize: 19,
                                        icon: const Icon(Icons.delete_outline),
                                        tooltip: 'Delete enquiry',
                                        onPressed: () {
                                          // print(dataFinal['userId']);
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                child: Column(

                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                      ),
                                                      child: Text(
                                                        "Are you sure to delete this enquiry?",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                        bottom: 20.00,
                                                      ),
                                                      child: Text(
                                                        "This will delete all records regarding this enquiry. This is not reversible.",
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child:
                                                          RoundedLoadingButton(
                                                        borderRadius: 2,
                                                        onPressed: () async {
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          var serverUrlfinal =
                                                              "${SettingsAllFle.finalURl}deleteEnquiry";
                                                          var response_ur =
                                                              await http.post(
                                                                  Uri.parse(
                                                                      serverUrlfinal),
                                                                  body: {
                                                                "enquriy_id":
                                                                    dataFinal[
                                                                        'enquiry_id']
                                                              },
                                                                  headers: {
                                                                "Accept":
                                                                    "application/json"
                                                              });
                                                          print(
                                                              response_ur.body);
                                                          //json.decode(response_ur.body);
                                                          var respo =
                                                              json.decode(
                                                                  response_ur
                                                                      .body);
                                                          if (respo[0]
                                                                  ['status'] ==
                                                              "success") {
                                                            _btnController2
                                                                .success();
                                                            Timer(
                                                                Duration(
                                                                    seconds: 1),
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          }
                                                        },
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        curve: Curves
                                                            .fastOutSlowIn,
                                                        child: Text("Proceed"),
                                                        controller:
                                                            _btnController2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                title: Text(
                                  StringUtils.capitalize(
                                      dataFinal['user_name']),
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      size: 12,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5.00),
                                      child: Text(
                                        dataFinal['mobile_number'],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10.00),
                                      child: Icon(
                                        Icons.account_box,
                                        size: 12,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5.00),
                                      child: Text(
                                        StringUtils.capitalize(
                                            dataFinal['assigned_empolyee']),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.4),
                          child: Text("No enquiries found"),
                        ),
                      );
                    }
                  },
                ),
              ),

            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
  */
}
