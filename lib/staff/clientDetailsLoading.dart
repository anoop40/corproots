import 'package:corproots/staff/updateStatusInitial.dart';
import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../settingsAllFle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

class clientDetailsLoading extends StatefulWidget {
  String clientId;

  clientDetailsLoading(this.clientId);

  _clientDetailsLoading createState() => _clientDetailsLoading();
}

class _clientDetailsLoading extends State<clientDetailsLoading> {
  late Future str;
  var jobCardDetails;
  bool _phonechipSelected = false;
  bool _whatsappchipSelected = false;
  bool _quotationChip = false;

  @override
  void initState() {
    super.initState();
    //getAllJobList();
    str = getData();
  }

  Future getData() async {
    var serverUrlfinal = "${SettingsAllFle.finalURl}/get-client-details-all";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "cilentId": widget.clientId,
    });
    print(response.body);
    this.setState(() {
      jobCardDetails = json.decode(response.body);
    });

    return "1";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        "Customer Name :",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        jobCardDetails[0]['user_name'],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        "Contact Number :",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        jobCardDetails[0]['mobile_number'],
                      ),
                    ),
                    Container(
                      child: IconButton(
                        iconSize: 19,
                        icon: new Icon(
                          Icons.phone_in_talk,
                          color: Colors.blue[400],
                        ),
                        highlightColor: Colors.pink,
                        onPressed: () async {
                          final url =
                              "tel:${jobCardDetails[0]['mobile_number']}";
                          if (await canLaunch(url) != null) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        "Email :",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        jobCardDetails[0]['email'],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        "Processing Enquiries:",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        jobCardDetails[0]['pendingEnquiries'].toString()
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        "Registered On:",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        jobCardDetails[0]['registered_on'],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 15.0,
                      top: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.01),
                  child: Text(
                    "ACTIONS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10.00,right:2.00),
                        child: Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: FaIcon(
                              FontAwesomeIcons.rupeeSign,
                              size: 13,
                            ),
                          ),
                          label: const Text('Accounts'),
                        ),
                      ),


                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                        child: InputChip(
                          onPressed: (){
                            Navigator.pushNamed(context, 'myProfileUser');
                          },
                          avatar: CircleAvatar(
                            backgroundColor: Colors.pink[400],
                            child: FaIcon(
                              FontAwesomeIcons.userCheck,
                              size: 13,
                            ),
                          ),
                          label: const Text('Profile'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                        child: ActionChip(
                          onPressed: (){
                            Navigator.pushNamed(context, 'client-history');
                          },
                          avatar: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: FaIcon(
                              FontAwesomeIcons.history,
                              size: 13,
                            ),
                          ),
                          label: const Text('History'),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10.00,right:2.00),
                        child: InputChip(
                          onPressed: ()async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('fetchingUsersId', widget.clientId);
                            Navigator.pushNamed(context, 'filesUploadedByClient');
                          },
                          avatar: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            child: FaIcon(
                              FontAwesomeIcons.file,
                              size: 13,
                            ),
                          ),
                          label: const Text('Documents'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.00,right:2.00),
                        child: Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: FaIcon(
                              FontAwesomeIcons.servicestack,
                              size: 13,
                            ),
                          ),
                          label: const Text('Services Enrolled'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                        child: InputChip(
                          selected: _quotationChip,
                          onPressed: () async {
                            //print("Enquiry Id : " + jobCardDetails[0]['enquiry_id']);
                            /*
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setString('selectedEnquiryId',
                                jobCardDetails[0]['enquiry_id']);
                            setState(() {
                              _quotationChip = true;
                            });
                            */
                           /*  Navigator.pushNamed(
                                context, 'sendQuotationToClient');

                            */
                            Navigator.pushNamed(context, 'quotationsSendToClient');
                          },
                          avatar: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: FaIcon(
                              FontAwesomeIcons.stickyNote,
                              size: 13,
                            ),
                          ),
                          label: const Text('Quotations'),
                        ),
                      ),

                    ],
                  ),
                ),


                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                      left: 15.0,
                      top: MediaQuery.of(context).size.height * 0.01,
                      bottom: MediaQuery.of(context).size.height * 0.01),
                  child: Text(
                    "QUICK CONTACT",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5.00),
                        child: InputChip(
                          selected: _phonechipSelected,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.phone,
                              size: 12,
                            ),
                          ),
                          label: const Text('Call to Customer'),
                          onPressed: () async {
                            setState(() {
                              _phonechipSelected = true;
                            });
                            final url =
                                "tel:${jobCardDetails[0]['mobile_number']}";
                            if (await canLaunch(url) != null) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                        child: InputChip(
                          selected: _whatsappchipSelected,
                          onPressed: () async {
                            setState(() {
                              _whatsappchipSelected = true;
                            });
                            await launch(
                                "https://wa.me/+91${jobCardDetails[0]['mobile_number']}?text=Hello");
                          },
                          avatar: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: FaIcon(
                              FontAwesomeIcons.whatsapp,
                              size: 13,
                            ),
                          ),
                          label: const Text('Whats app'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                        child: Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: FaIcon(
                              FontAwesomeIcons.envelope,
                              size: 13,
                            ),
                          ),
                          label: const Text('Email'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                        child: Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: FaIcon(
                              FontAwesomeIcons.comments,
                              size: 13,
                            ),
                          ),
                          label: const Text('Message'),
                        ),
                      )
                    ],
                  ),
                ),
                /*
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.3,
                    top: MediaQuery.of(context).size.height * 0.03,
                    bottom: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  updateStatusInitial(widget.job_card_id)));
                    },
                    child: Text('UPDATE STATUS'),
                  ),
                ),
                */
              ],
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
