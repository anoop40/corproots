import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class service_details extends StatefulWidget {
  final service_document_id;

  service_details(this.service_document_id);

  _service_details createState() => _service_details();
}

class _service_details extends State<service_details>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  CollectionReference _service_fir =
      FirebaseFirestore.instance.collection('services');
  var _course_intro;
  var _course_documents_required;
  var _office_details;
  late Future str;
  late var _category_heading;

  @override
  void initState() {
    super.initState();
    str = get_data();
    _tabController = TabController(length: 3, vsync: this);
  }

  get_data() async {
    await FirebaseFirestore.instance
        .collection('services')
        .doc(widget.service_document_id)
        .get()
        .then((value) {
      //print("documents_required : " + value['documents_required'].toString());
      setState(() {
        _course_intro = value['service_description'].toString();
        _course_documents_required = value['documents_required'].toString();
        _office_details = value['office_details'].toString();
        _category_heading = value['service_heading'].toString();
      });
    });
    return true;
  }

  sendEnquiry() async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user_document_id')) {
      /* checking if request already send */
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('enquiries')
          .where('enquiry_category',
              isEqualTo: _category_heading.toString())
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length > 0) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        final snackBar = SnackBar(content: Text("Enquiry already posted."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _btnController.reset();
      } else {
        final snackBar = SnackBar(
          content: const Text('Updating please wait ..'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        DateFormat formatter = DateFormat("dd-MM-yyyy HH:mm:ss");
        final DateTime now = DateTime.now();
        CollectionReference enquiries =
            FirebaseFirestore.instance.collection('enquiries');
        enquiries.add({
          'user_document_id': prefs.getString('user_document_id'), // John Doe
          'enquiry_category': _category_heading.toString(),
          'enquiry_date': formatter.format(now),
          'status': 'processing',
          'admin_view_status': 'not_reviewed',
          'assigned_staff_doc_id' : 'null'
        }).then((value) async {
          /* sending fcm push notification */

          FirebaseFirestore.instance.collection("users")
            .where('user_type', isEqualTo: 'admin')
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((result) async {
                //print("Here the data"+result.data().toString());
                var dataReceive = result.data();

                final data = {
                  "registration_ids": [dataReceive['deviceId']],
                  "collapse_key": "type_a",
                  "notification": {
                    "title": 'New Enquiry',
                    "body": 'We have got new enquiry.Please check it assap ..',
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

          /* ends here */
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          Fluttertoast.showToast(
              msg: "Request posted successfully..",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushNamed(context, 'myRequests');
        }).catchError((error) => print("Failed to add user: $error"));
      }
      /* ends here */

    } else {
      final snackBar = SnackBar(
        content: const Text('Please login to proceed'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, 'loginSignup');
    }
  }

  @override
  Widget build(BuildContext context) {
    getTabDetails() {
      FirebaseFirestore.instance
          .collection("services_tabs")
          .where('services_doc_id', isEqualTo: widget.service_document_id)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) async {
          //print("Here the data"+result.data().toString());
          var dataReceive = result.data();
          print("Tb head : " + dataReceive['service_tab_heading'].toString());
        });
      });
    }

    submit_buton() {
      if (kIsWeb == false) {
        return RoundedLoadingButton(
          color: Colors.blue[800],
          borderRadius: 3.00,
          width: MediaQuery.of(context).size.width,
          child: Text('SUBMIT', style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: () async {
            sendEnquiry();
            _btnController.reset();
          },
        );
      }
    }

    return FutureBuilder(
      future: str,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[800],
              title: Text(_category_heading.toString()),
              bottom: new PreferredSize(
                //child: tabbar_content,
                preferredSize: Size.fromHeight(90.0),
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.list),
                      text: "Introduction",
                    ),
                    Tab(
                      icon: Icon(Icons.upload_file_sharp),
                      text: "Documents Required",
                    ),
                    Tab(icon: Icon(Icons.scanner), text: "Office details"),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: submit_buton(),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(_course_intro.toString()),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(_course_documents_required.toString()),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(_office_details.toString()),
                  ),
                ),
              ],
            ),
          );
        }
        else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
