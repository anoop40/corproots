import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users extends StatefulWidget {
  _users createState() => _users();
}

class _users extends State<Users> {
  late Future str;
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();
  CollectionReference _users_al =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _users_al.where('user_type', isEqualTo: "staff").snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(snapshot.data!.docs[index]['username']),
                        subtitle: Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              size: 12,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.00),
                              child: Text(
                                snapshot.data!.docs[index]['mobile_number'],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.00),
                              child: Icon(
                                Icons.verified_user,
                                size: 12,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.00),
                              child: Text(
                                snapshot.data!.docs[index]['user_type'],
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          iconSize: 19,
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          tooltip: 'Delete user',
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences
                                .getInstance();

                            if (snapshot.data!.docs[index]['deviceId'] ==
                                prefs.getString('deviceId')) {
                              Fluttertoast.showToast(
                                  msg: "Can't delete account",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                            else {
                              // set up the button
                              Widget okButton = FlatButton(
                                child: Text("YES"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _users_al
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete()
                                      .then((value) {
                                    Fluttertoast.showToast(
                                        msg: "Successfully deleted user",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }).catchError((error) =>
                                      print("Failed to delete user: $error"));
                                },
                              );
                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                title: Text("DELETE USER"),
                                content: Text(
                                    "This will delete this user from database. Are you sure ?"),
                                actions: [
                                  okButton,
                                ],
                              );
                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }
                          }
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
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
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0.00,
        onPressed: () async {

          Navigator.pushNamed(context, 'addNewUser');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
      ),
    );
  }
}
