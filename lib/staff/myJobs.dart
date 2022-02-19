import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corproots/users/update_enquiry_status.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyJobs extends StatefulWidget {
  _MyJobs createState() => _MyJobs();
}

class _MyJobs extends State<MyJobs> {
  late Future str;
  late List myJobs;
  var colorScheme;
  var font_color;
  late var _document_id;

  CollectionReference _enquiries =
      FirebaseFirestore.instance.collection('enquiries');

  get_document_id() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
  print("Device ID : " + prefs.getString('deviceId').toString());
    await FirebaseFirestore.instance
        .collection('users')
        .where('deviceId', isEqualTo: prefs.getString('deviceId'))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("Mobile number : " + doc["mobile_number"]);
        setState(() {
          _document_id = doc.id;
        });
      });
    });
    print("Document ID is : " + _document_id.toString());
    return true;
  }

  @override
  void initState() {
    super.initState();
    str = get_document_id();
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
              stream: _enquiries
                  .where('assigned_staff_doc_id', isEqualTo: _document_id)
                  .snapshots(),
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
                            title: Text(
                                snapshot.data!.docs[index]['enquiry_category']),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 9),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    size: 12,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.00),
                                    child: Text(
                                      snapshot.data!.docs[index]['status'],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.00),
                                    child: Icon(
                                      Icons.verified_user,
                                      size: 12,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.00),
                                    child: Text(
                                      snapshot.data!.docs[index]
                                          ['enquiry_date'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async{



                              var username2 ;
                              var contact_number;
        //print("user doc id :" + snapshot.data!.docs[index]['user_document_id']);
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index]['user_document_id'])
                                  .get()
                                  .then((value) {
                                    print("username is : " + value['user_name']);
                                username2 = value['user_name'].toString();
                                    contact_number = value['mobile_number'].toString();
                              });

                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  var enquiry_closing_stat;
                                  if(snapshot.data!.docs[index]['status'] == "completed") {
                                    enquiry_closing_stat =  Column(
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.8,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.02, top: MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text("Enquiry Status "),
                                                Text("completed"),

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.8,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.02, top: MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text("Completed On "),
                                                Text(snapshot.data!.docs[index]['completed_on']),

                                              ],
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue[800],
                                          ),
                                          onPressed: () {
                                            // Navigator.pushNamed(context, 'update_status',arguments: {'enquiry_doc_id' : snapshot.data!.docs[index].id});
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => load_history_enquiry(snapshot.data!.docs[index].id),
                                                ));
                                          },
                                          child: Text('Load History',style: TextStyle(color: Colors.white),),
                                        )

                                      ],
                                    );
                                  }
                                  else{
                                    enquiry_closing_stat =  Column(
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.8,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.02, top: MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text("Enquiry Status "),
                                                Text("Processing"),

                                              ],
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue[800],
                                          ),
                                          onPressed: () {
                                            // Navigator.pushNamed(context, 'update_status',arguments: {'enquiry_doc_id' : snapshot.data!.docs[index].id});
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => update_enquiry_status(snapshot.data!.docs[index].id),
                                                ));
                                          },
                                          child: Text('Update Status',style: TextStyle(color: Colors.white),),
                                        )


                                      ],
                                    );
                                  }
                                  return Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,

                                      children: <Widget>[
                                        Container(
                                    decoration: BoxDecoration(color: Colors.blue[800]),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.02, bottom: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.02, left: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.02),
                                            child: Text(
                                              "ENQUIRY DETAILS",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03, top: MediaQuery.of(context).size.height * 0.02),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("Enquiry Heading : "),
                                                Text(snapshot.data!.docs[index]['enquiry_category'])
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02, top: MediaQuery.of(context).size.height * 0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("Customer Name : "),
                                                Text(username2.toString())
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02, top: MediaQuery.of(context).size.height * 0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("Customer Contact Number : "),
                                                Icon(Icons.phone,size: 12,),
                                                Text(contact_number.toString()),

                                              ],
                                            ),
                                          ),
                                        ),
                                        enquiry_closing_stat,

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
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4,
                        left: MediaQuery.of(context).size.width * 0.2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
class load_history_enquiry extends StatefulWidget{
  final enquiry_doc_id;
  load_history_enquiry(this.enquiry_doc_id);
  _load_history_enquiry createState() => _load_history_enquiry();
}

class _load_history_enquiry extends State<load_history_enquiry>{
  CollectionReference _enquiries =
  FirebaseFirestore.instance.collection('enquiries');
  getData(){
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: _enquiries.doc(widget.enquiry_doc_id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.alarm_sharp),
                title: Text("Admin view status : " + data['admin_view_status'].toString()),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.alarm_sharp),
                title: Text("Enquiry category : " + data['enquiry_category'].toString()),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.alarm_sharp),
                title: Text("Enquiry date : " + data['enquiry_date'].toString()),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.alarm_sharp),
                title: Text("Status : " + data['status'].toString()),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.alarm_sharp),
                title: Text("Completed on : " + data['completed_on'].toString()),
              ),
              Divider(),
            ],
          );
        }

        return Text("loading");
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Track enquiry"),
      ),
      body: SingleChildScrollView(
        child: getData(),
      ),
    );
  }


}
