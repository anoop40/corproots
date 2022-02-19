import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class paymentRequest extends StatefulWidget {
  var clientId;

  paymentRequest(this.clientId);

  _PaymentRequest createState() => _PaymentRequest();
}

class _PaymentRequest extends State<paymentRequest> {
  final _formKey = GlobalKey<FormState>();
  DateTime currentDate = DateTime.now();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _amount = new TextEditingController();
  final _description = new TextEditingController();
  late var _lastDate;
  late var refference;
  var LastDateSelection = Container(
    child: Text(
      "NOT SET",
      style: TextStyle(color: Colors.red[800], fontSize: 27),
    ),
  );
  final _DBReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 15.00, bottom: 15.00, left: 10.00),
                child: Text(
                  "NEW PAYMENT REQUEST",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(color: Colors.blue[800]),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.only(left: 10.00, top: 10.00),
                      child: TextFormField(
                        controller: _amount,
                        // The validator receives the text that the user has entered.
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8.0),
                            border: OutlineInputBorder(),
                            labelText: "Amount"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 10.00, top: 15.00, right: 10.00),
                      child: TextFormField(
                        controller: _description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8.0),
                            border: OutlineInputBorder(),
                            labelText: "Description"),
                      ),
                    ),
                    Divider(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.only(left: 7.00, top: 20.00),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                            child: Row(
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.calendar,
                                  size: 13,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.00),
                                  child: Text('Last Date'),
                                )
                              ],
                            ),
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: currentDate,
                                  firstDate: currentDate,
                                  lastDate: DateTime(2050));
                              if (pickedDate != null &&
                                  pickedDate != currentDate)
                                //var selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  _lastDate = DateFormat('dd-MM-yyyy')
                                      .format(pickedDate);
                                  // currentDate = pickedDate;
                                  LastDateSelection = Container(
                                    child: Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.pink[800],
                                          fontSize: 27),
                                    ),
                                  );
                                });
                              FocusScope.of(context).unfocus();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[800],
                            ),
                          ),
                          LastDateSelection,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RoundedLoadingButton(
          borderRadius: 0.00,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue[800],
          child: Text('Update Now', style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              AlertDialog alert = AlertDialog(
                content: new Row(
                  children: [
                    CircularProgressIndicator(),
                    Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text(" Updating...")),
                  ],
                ),
              );
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var serverUrlfinal =
                  "${SettingsAllFle.finalURl}/new-payment-request";
              setState(() {
                refference = DateTime.now().millisecondsSinceEpoch;
              });
              print("Reference key is : " + refference.toString());
              var response = await http.post(Uri.parse(serverUrlfinal), body: {
                'amount': _amount.text,
                'description': _description.text,
                'customerId': widget.clientId,
                'updated_by': prefs.getString('userId'),
                'last_date': _lastDate.toString(),
                'id' : refference.toString()
              }, headers: {
                "Accept": "application/json"
              });
              print("From server is : " + response.body.toString());
              var respo = json.decode(response.body);

              if (respo[0]['status'] == "success") {
                /* add data to realtime db */
                _DBReference.child('paymentRequests/${refference.toString()}').set(
                  {
                    'customerId': widget.clientId,
                    'amount': _amount.text,
                    'last_date': _lastDate.toString(),
                    'payment_status' : "not_paid",
                    'refference_key' : refference.toString(),
                    'client_view_status' : "not_viewed"
                  },
                );
                /* ends here */

                Navigator.pop(context);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Successfully updated')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Please provide all fields')),
              );
              _btnController.reset();
            }
          }),
    );
  }
}
