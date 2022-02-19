import 'package:basic_utils/basic_utils.dart';
import 'package:corproots/staff/updateStatusInitial.dart';
import 'package:flutter/cupertino.dart';
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

import 'FormsListing.dart';

class jobcardDetails extends StatefulWidget {
  String enquiry_id;

  jobcardDetails(this.enquiry_id);

  _jobcardDetails createState() => _jobcardDetails();
}

enum SingingCharacter { completed, cancelled }

class _jobcardDetails extends State<jobcardDetails> {
  late Future str;
  var jobCardDetails;
  bool _phonechipSelected = false;
  bool _whatsappchipSelected = false;
  bool _quotationChip = false;
  var _statusUpdateRadiovalue;
  bool value = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  var _commentNotes = TextEditingController();
  var _cardStatus;

  // simple usage
  SingingCharacter _character = SingingCharacter.completed;

  @override
  void initState() {
    super.initState();
    str = getData();
  }

  Future getData() async {
    var serverUrlfinal = "${SettingsAllFle.finalURl}/get-job-card-details";

    var serverUrlfinal1 =
        "${SettingsAllFle.finalURl}/update-enquiry-staff-view-status";

    var response1 = await http.post(Uri.parse(serverUrlfinal1), headers: {
      "Accept": "application/json"
    }, body: {
      "enquiry_id": widget.enquiry_id,
    });

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "enquiry_id": widget.enquiry_id,
    });
    //print(response.body);
    this.setState(() {
      jobCardDetails = json.decode(response.body);
      _cardStatus = jobCardDetails[0]['enquiry_process_status'].toString();
    });

    return "1";
  }

  checkJobCardDetails() {
    if (_cardStatus == "processing") {
      return Row(
        children: <Widget>[
          FaIcon(FontAwesomeIcons.spinner),
          Container(
            margin: EdgeInsets.only(left: 3),
            child: Text(
              "PROCESSING",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
    if (_cardStatus == "completed") {
      return Row(
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.check,
            color: Colors.green,
            size: 13,
          ),
          Container(
            margin: EdgeInsets.only(left: 3),
            child: Text("COMPLETED",
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.exclamation,
            color: Colors.red,
            size: 13,
          ),
          Container(
            margin: EdgeInsets.only(left: 3),
            child: Text(
              "CANCELLED",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
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
                        StringUtils.capitalize(
                            jobCardDetails[0]['customerName']),
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
                        "Enquiry Category:",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        jobCardDetails[0]['enquiry_category'],
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
                        "Enquiry Date & Time:",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        jobCardDetails[0]['enquiry_date_and_time'],
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
                        "Status:",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15.00,
                        top: 10,
                        bottom: 10,
                      ),
                      child: checkJobCardDetails(),
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
                        margin: EdgeInsets.only(left: 10.00),
                        child: InputChip(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Status update",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Next'),
                                      onPressed: () async {
                                        //Navigator.of(context).pop();
                                        //print("checked value : "+_character.toString());
                                        setState(() {
                                          _statusUpdateRadiovalue =
                                              _character.toString();
                                        });
                                        Navigator.of(context).pop();
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Comments",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: <Widget>[
                                                RoundedLoadingButton(
                                                  borderRadius: 6,
                                                  child: Text('UPDATE NOW',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  controller: _btnController,
                                                  onPressed: () async {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    var extraNotes =
                                                        _commentNotes.text;
                                                    var serverUrlfinal =
                                                        "${SettingsAllFle.finalURl}change-enquiry-status";

                                                    var response_ur = await http
                                                        .post(
                                                            Uri.parse(
                                                                serverUrlfinal),
                                                            body: {
                                                          "enquiryId":
                                                              widget.enquiry_id,
                                                          "userId":
                                                              prefs.getString(
                                                                  'userId'),
                                                          "notes": extraNotes,
                                                          "statusUp": _character
                                                              .toString()
                                                        },
                                                            headers: {
                                                          "Accept":
                                                              "application/json"
                                                        });
                                                    //print(response_ur.body);
                                                    var resultCon = json.decode(
                                                        response_ur.body);
                                                    if (resultCon[0]
                                                            ['status'] ==
                                                        "success") {
                                                      _btnController.success();
                                                      Timer(
                                                          Duration(seconds: 1),
                                                          () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            'userDashboard');
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                              //title: Text("SELECT FORM"),
                                              content: StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    TextFormField(
                                                      //textAlignVertical: TextAlignVertical.top,
                                                      maxLines: 8,
                                                      controller: _commentNotes,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Notes",
                                                        fillColor: Colors.white,
                                                        border:
                                                            OutlineInputBorder(),
                                                        alignLabelWithHint:
                                                            true,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                  //title: Text("SELECT FORM"),
                                  content: StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          title: const Text('Task Completed'),
                                            /*
                                          leading: Radio<SingingCharacter>(
                                            value: SingingCharacter.completed,
                                            groupValue: _character,

                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                _character = value;
                                              });
                                            },


                                          ),
                                          */
                                        ),
                                        ListTile(
                                          title: const Text('Task Cancelled'),
                                            /*
                                          leading: Radio<SingingCharacter>(
                                            value: SingingCharacter.cancelled,
                                            groupValue: _character,

                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                _character = value;
                                              });
                                            },


                                          ),
                                          */

                                        ),
                                      ],
                                    );
                                  }),
                                );
                              },
                            );
                          },
                          avatar: CircleAvatar(
                            backgroundColor: Colors.red[300],
                            child: FaIcon(
                              FontAwesomeIcons.calendarCheck,
                              size: 13,
                            ),
                          ),
                          label: const Text('Status Update'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                        child: InputChip(
                          onPressed: () async {
                            //Navigator.of(context).pop();
                            /* start here */

                            showDialog<void>(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //title: Text("SELECT FORM"),
                                  content: StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return FormsListing();
                                  }),
                                );
                              },
                            );

                            /* ends here */
                          },
                          avatar: CircleAvatar(
                            backgroundColor: Colors.orange[400],
                            child: FaIcon(
                              FontAwesomeIcons.pencilAlt,
                              size: 13,
                            ),
                          ),
                          label: const Text('Forms'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                        child: InputChip(
                          selected: _quotationChip,
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('selectedEnquiryId',
                                jobCardDetails[0]['enquiry_id']);
                            setState(() {
                              _quotationChip = true;
                            });
                            Navigator.pushNamed(
                                context, 'sendQuotationToClient');
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
