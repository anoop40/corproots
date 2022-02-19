import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListAllDepartments extends StatefulWidget {
  _ListAllDepartments createState() => _ListAllDepartments();
}

class _ListAllDepartments extends State<ListAllDepartments> {
  late Future str;
  CollectionReference _departments =
      FirebaseFirestore.instance.collection('departments');
  late var _total_users;

  @override
  void initState() {
    super.initState();
  }

  count_total_staffs(String dept_name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('department', isEqualTo: dept_name)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    setState(() {
      _total_users = documents.length.toString();
    });
    //return documents.length.toString();
    return "12";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(
          "Saved Departments",
        ),
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
                  var _dept_name =
                      snapshot.data!.docs[index]['department_name'].toString();
                  count_total_staffs(_dept_name);

                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.building,
                          color: Colors.blue[800],
                        ),
                        title:
                            Text(snapshot.data!.docs[index]['department_name']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            if (snapshot.data!.docs[index]['department_name'] !=
                                "Select Department") {
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
                                    fontSize: 16.0);
                              }).catchError((error) =>
                                      print("Failed to delete user: $error"));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Can't able to delete this department.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
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
                          setState(() {
                            _total_users = documents.length.toString();
                          });
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
                        },
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
