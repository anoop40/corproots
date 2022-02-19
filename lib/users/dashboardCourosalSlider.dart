import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corproots/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_installations/firebase_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class DashboardCourrosalSlider extends StatefulWidget {
  _DashboardCourrosalSlider createState() => _DashboardCourrosalSlider();
}

class _DashboardCourrosalSlider extends State<DashboardCourrosalSlider> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  late final FirebaseMessaging _firebaseMessaging;

  initialFun() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFun();
  }


  sendEnquiry() async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user_document_id')) {
      /* checking if request already send */
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('enquiries')
          .where('enquiry_category',
          isEqualTo: "trademark Application")
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length > 0) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        final snackBar = SnackBar(content: Text("Enquiry already posted."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //_btnController.reset();
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
          'enquiry_category': "Trademark Application",
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
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: false,
            ),
            items: imgList
                .map((item) => Container(
                      child: Center(
                          child: Image.network(item,
                              fit: BoxFit.cover, width: 1000)),
                    ))
                .toList(),
          ),
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'newEnquiry');
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.00),
                        child: Image(
                          image: AssetImage("assets_files/new-enquiry.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                        child: Text(
                          "New Request",
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Welcome(1)),
                );
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.00),
                        child: Image(
                          image: AssetImage("assets_files/myRequests.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                        child: Text(
                          "My Requests",
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                print("welcome");
                await Firebase.initializeApp();
                var token = await FirebaseInstallations.id;
                print("Instance ID: $token");
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.00),
                        child: Image(
                          image: AssetImage("assets_files/getInTouch.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                        child: Text(
                          "Get in Touch",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "OUR SERVICES",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.00),
                                child: Image(
                                  image: AssetImage("assets_files/trademark.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                                child: Text(
                                  "Trademark Application",
                                  style: TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        sendEnquiry();
                      },
                    ),
                    Card(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.00),
                              child: Image(
                                image:
                                    AssetImage("assets_files/patentFiling.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                              child: Text(
                                "Patent Filing",
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.00),
                              child: Image(
                                image: AssetImage(
                                    "assets_files/gst-registration.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                              child: Text(
                                "GST Registration",
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Row(
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.00),
                          child: Image(
                            image: AssetImage(
                                "assets_files/companyRegtstration.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                          child: Text(
                            "Company Registration",
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.00),
                          child: Image(
                            image: AssetImage("assets_files/compliance.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                          child: Text(
                            "Mandatory Compliance",
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.00),
                          child: Image(
                            image: AssetImage("assets_files/gst-filing.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 47.00,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.00, bottom: 8.00),
                          child: Text(
                            "GST Filing",
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
