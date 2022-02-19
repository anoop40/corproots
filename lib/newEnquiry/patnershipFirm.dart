import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';
import 'package:intl/intl.dart';

class PatnershipFirm extends StatefulWidget {
  _PatnershipFirm createState() => _PatnershipFirm();
}

class _PatnershipFirm extends State<PatnershipFirm>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  sendEnquiry() async {


    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user_document_id')) {
      /* checking if request already send */
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('enquiries')
          .where('enquiry_category',
          isEqualTo: 'Partnership firm registration')
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
          'enquiry_category': 'Partnership firm registration',
          'enquiry_date': formatter.format(now),
          'status': 'processing',
          'admin_view_status': 'not_reviewed'
        }).then((value) async {
          /* sending fcm push notification */

          FirebaseFirestore.instance.collection("users").where('user_type',
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
        title: Text("Partnership Firm"),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.list),
              text: "Overview",
            ),
            Tab(
              icon: Icon(Icons.local_offer_sharp),
              text: "Benefits",
            ),
            Tab(
              icon: Icon(Icons.local_offer_sharp),
              text: "Pre-requisites",
            ),
            Tab(
              icon: Icon(Icons.local_offer_sharp),
              text: "Deliverables",
            ),

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
            child: Center(
              child : Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    child: Text(
                      "Start a partnership firm online",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: MediaQuery.of(context).size.height * 0.01,
                        right: MediaQuery.of(context).size.height * 0.01),
                    child: Text(
                      "A general partnership is a corporate structure in which two or more people manage and operate a company in accordance with the partnership deed's provisions and objectives. This structure is thought to have lost its relevance since the introduction of the limited liability partnership (LLP) because the partners in a general partnership firm have unlimited liability, which means they are personally liable for the debts of the business. However, low costs, ease of setting up, and minimal compliance requirements make it a sensible option for some, such as home businesses that are unlikely to take on any debt. Registration is optional for general partnerships. Contact our Vakilsearch experts now to know the recent partnership deed format.",
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
                      "Timeframe",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: MediaQuery.of(context).size.height * 0.01,
                        right: MediaQuery.of(context).size.height * 0.01),
                    child: Text(
                      "The partnership firm registration process takes about 10 to 12 working days, depending on departmental approval and reverts from each department.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.lato(
                        wordSpacing: 3.0,
                        height: 1.7,
                      ),
                    ),
                  ),



                ],
              )
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
          Text("Weloc")
        ],
      ),
    );
  }
}
