import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class depts extends StatefulWidget {
  _depts createState() => _depts();
}

class _depts extends State<depts> {
  late Future str;
  late List users;
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  CollectionReference _departments =
  FirebaseFirestore.instance.collection('departments');
  final _depatmentName = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();
  final _formKey1 = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0.00,
        onPressed: () async{
          //Navigator.pushNamed(context, "addNewUser");
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height:
                MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width:
                      MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 15.00,
                            bottom: 15.00,
                            left: 10.00),
                        child: Text(
                          "ADD NEW DEPARTMENT",
                          style:
                          TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue[800]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.00),
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10.00,
                              ),
                              child: Container(
                                child: TextFormField(
                                  controller: _depatmentName,
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border:
                                      OutlineInputBorder(),
                                      labelText:
                                      "Department Name"),
                                ),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.96,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 7.00, top: 7.00),
                              child: Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.6,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context,
                                            'listDepartments');
                                      },
                                      child:
                                      Text("DEPARTMENTS"),
                                    ),
                                    ElevatedButton(
                                      child: const Text(
                                          'UPDATE'),

                                      onPressed: () async {
                                        AlertDialog alert =
                                        AlertDialog(
                                          content: new Row(
                                            children: [
                                              CircularProgressIndicator(),
                                              Container(
                                                margin: EdgeInsets
                                                    .only(
                                                    left:
                                                    7),
                                                child: Text(
                                                    " Loading..."),
                                              ),
                                            ],
                                          ),
                                        );
                                        showDialog(
                                          barrierDismissible:
                                          false,
                                          context: context,
                                          builder:
                                              (BuildContext
                                          context) {
                                            return alert;
                                          },
                                        );
                                        _departments.add({
                                          'department_name':
                                          _depatmentName
                                              .text,
                                        }).then((value) {
                                          Navigator.pop(
                                              context);
                                          Navigator.pop(
                                              context);
                                          final snackBar =
                                          SnackBar(
                                            backgroundColor:
                                            Colors.green,
                                            content: Row(
                                              children: <
                                                  Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                      8.00),
                                                  child: Icon(
                                                    Icons
                                                        .check_circle_outline,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                ),
                                                Text(
                                                    "Department successfully updated")
                                              ],
                                            ),
                                          );

                                          // Find the ScaffoldMessenger in the widget tree
                                          // and use it to show a SnackBar.
                                          ScaffoldMessenger
                                              .of(context)
                                              .showSnackBar(
                                              snackBar);
                                        }).catchError(
                                                (error) => print(
                                                "Failed to add user: $error"));
                                      },
                                      style: ElevatedButton
                                          .styleFrom(
                                        primary:
                                        Colors.blue[800],
                                      ),
                                      // Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _departments.snapshots(),
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
                        leading: FaIcon(
                          FontAwesomeIcons.building,
                          color: Colors.blue[800],
                        ),
                        title: Text(snapshot.data!.docs[index]['department_name']),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            if(snapshot.data!.docs[index]['department_name'] != "Select Department") {
                              _departments
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete()
                                  .then((value) {
                                Fluttertoast.showToast(
                                    msg: "Successfully deleted",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              })
                                  .catchError((error) =>
                                  print("Failed to delete user: $error"));
                            }
                            else{
                              Fluttertoast.showToast(
                                  msg: "Can't able to delete this department.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          },
                        ),
                          onTap: () async {
                            final QuerySnapshot result = await FirebaseFirestore.instance
                                .collection('users')
                                .where('department', isEqualTo: snapshot.data!.docs[index]['department_name'])
                                .limit(1)
                                .get();
                            final List<DocumentSnapshot> documents = result.docs;

                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 100,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('Total staffs'),
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.00),
                                          child: Text(documents.length.toString(),style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
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
    );
  }
}
