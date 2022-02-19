import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
class pvtltdEnquiry extends StatefulWidget {
  final enquiry_document_id;
  pvtltdEnquiry(this.enquiry_document_id);
  _pvtltdEnquiry createState() => _pvtltdEnquiry();
}

class _pvtltdEnquiry extends State<pvtltdEnquiry>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  sendEnquiry() async {


    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user_document_id')) {
      /* checking if request already send */
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('enquiries')
          .where('enquiry_category',
              isEqualTo: 'Pvt Ltd new registration enquiry')
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
          'enquiry_category': 'Pvt Ltd new registration enquiry',
          'enquiry_date': formatter.format(now),
          'status': 'processing',
          'admin_view_status': 'not_reviewed'
        }).then((value) async {
          /* sending fcm push notification */

          FirebaseFirestore.instance.collection("users")..where('user_type',
              isEqualTo: 'admin').get().then((querySnapshot) {
            querySnapshot.docs.forEach((result) async {
              //print("Here the data"+result.data().toString());
              var dataReceive = result.data();



              final data = {
                "registration_ids" : [dataReceive['deviceId']],
                "collapse_key" : "type_a",
                "notification" : {
                  "title": 'New Enquiry',
                  "body" : 'We have got new enquiry.Please check it assap ..',
                }
              };

              final headers = {
                'content-type': 'application/json',
                'Authorization': 'key=AAAAUUmzTzc:APA91bHbzGr90h2Hpx1wAfokljehgPobk1X9OK7hg0oyfRPlqM6x7JJCOtCJ7MnEJWHeKtTzQcdcH4TkwFMzdwJWG--slZiXfW1o7_SQr6UbwJxrBs_Hddg8ZHfKXJyMDQJphg7C5R84' // 'key=YOUR_SERVER_KEY'
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Private Limited Company 123"),
        bottom: TabBar(
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
      bottomNavigationBar: RoundedLoadingButton(
        color: Colors.blue[800],
        borderRadius: 3.00,
        width: MediaQuery.of(context).size.width,
        child: Text('SUBMIT', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () async {
          sendEnquiry();
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: Text(
                    "Requirements for Establishing a Company in India",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.height * 0.01,
                      right: MediaQuery.of(context).size.height * 0.01),
                  child: Text(
                    "To start a company in India, a minimum of two persons and an address in India are required. A private limited company in India must have a minimum of two directors (persons) and a minimum of two shareholders (can be persons or corporate entities). Further, the incorporation rules in India states that one of the Director of the Company must be both an Indian Citizen and Indian Resident (any person who has lived in India for over 186 days is considered an Indian Resident).",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.lato(
                      wordSpacing: 3.0,
                      height: 1.7,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.height * 0.01,
                      right: MediaQuery.of(context).size.height * 0.01),
                  child: Text(
                    "An address in India is required to serve as the registered office of the Company. The city in which the registered office address of the company will be setup will also determine the legal jurisdiction applicable for the company.",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.lato(
                      wordSpacing: 3.0,
                      height: 1.7,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: Text(
                    "WHAT IS INCLUDED IN THIS PACKAGE?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.01,
                      right: MediaQuery.of(context).size.height * 0.01),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "1. DIN - Directors Identification Number for 2 Directors",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "2. DSC - Digital Signature Certificate for 2 Directors",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "3. Name Approval with RUN Application",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "4. Certificate of Incorporation",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "5. PAN Number",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "6. TAN Number",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "7. ESIC CODE NUMBER",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "8. EPF ACCOUNT NUMBER",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "9. Drafting the Memorandum of Association",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "10. Drafting the Articles of Association",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "11. Filing fees for an authorized capital",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "12.  Filing fees for Government Stamp Duty ",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(bottom: 15.00),
                        child: Text(
                          "13. Assistance in Bank Account Opening.",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            wordSpacing: 3.0,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.01,
                  right: MediaQuery.of(context).size.height * 0.01),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    child: Text(
                      "Director details (All Directors):-",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "1. PAN Card ",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "2. Passport Size Photograph",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "3. ID Proof – Adhar card or passport",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "4. Email Id and Phone number",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "5. Address Proof : any one of the following documents:-",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Bank Statement or Telephone Bill or Mobile Bill or Electricity Bill (not older than 2 months)",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.01,
                  right: MediaQuery.of(context).size.height * 0.01,
                  top: 20.00),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "1. Rental agreement + NOC - Non-Objection Certificate*",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "2. Electricity Bill or any of the Utility Bills.",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "(Residential address and virtual office address can also be used as office address)",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    child: Text(
                      "HOW MUCH TIME WILL IT TAKE TO COMPLETE THE PROCESS?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, height: 1.7),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Usually, it takes around 8-14 business days to complete the entire process.",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
