import 'dart:convert';

import 'package:corproots/admin/paymentRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class clientAccountDetails extends StatefulWidget {
  String clientId;

  clientAccountDetails(this.clientId);

  _clientAccountDetails createState() => _clientAccountDetails();
}

class _clientAccountDetails extends State<clientAccountDetails> {
  late Future str;
  late List accounts;
  late var _totalDue;


  getData() async {
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-client-account";

    var response = await http.post(Uri.parse(serverUrlfinal),
        body: {'clientId': widget.clientId},
        headers: {"Accept": "application/json"});
    print(response.body);
    var temps = json.decode(response.body);
    this.setState(() {
      accounts = json.decode(response.body) as List<dynamic>;
      if(temps[0]['totalDue'].toString() == "notFound"){
        _totalDue = "0";
      }
      else{
        _totalDue = temps[0]['totalDue'].toString();
      }

    });

    return true;
  }

  @override
  void initState() {
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Details "),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm_sharp),
            tooltip: 'Reminder',
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('client_id', widget.clientId);
              Navigator.pushNamed(context, 'remindersLoading');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New',
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: paymentRequest(widget.clientId),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_sharp),
            tooltip: 'Refresh',
            onPressed: () {
              getData();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Column(
            children: <Widget>[
              Divider(),
              Container(
                padding: EdgeInsets.only(bottom: 15.00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "OUTSTANDING AMOUNT : ",
                      style: TextStyle(color: Colors.white),
                    ),
                    FaIcon(
                      FontAwesomeIcons.rupeeSign,
                      color: Colors.white,
                      size: 13,
                    ),
                    FutureBuilder(
                      future: str,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "" + _totalDue.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: FutureBuilder(
          future: str,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> dataFinal = accounts[index];

                 // print("Total due is : " + dataFinal['totalDue'].toString());
                  if(dataFinal['status'] == "success") {

                    checkPaymentStatus() {
                      if (dataFinal['payment_status'] == "paid") {
                        return Icon(
                          Icons.check_circle,
                          color: Colors.green[800],
                        );
                      } else {
                        return Icon(
                          Icons.close_outlined,
                          color: Colors.red[800],
                        );
                      }
                    }
                    checkReminderStatus(){
                      if(dataFinal['payment_status'] == "not_paid"){
                        return IconButton(
                          icon: const Icon(
                            Icons.notification_add,
                            color: Colors.pink,
                          ),
                          onPressed: () async {
                            AlertDialog alert = AlertDialog(
                              content: new Row(
                                children: [
                                  CircularProgressIndicator(),
                                  Container(
                                      margin: EdgeInsets.only(left: 7),
                                      child: Text(" Please wait...")),
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
                            var serverUrlfinal =
                                "${SettingsAllFle
                                .finalURl}/send-notification-to-client";

                            var response = await http.post(
                                Uri.parse(serverUrlfinal),
                                body: {
                                  'user_id': widget.clientId
                                },
                                headers: {"Accept": "application/json"});
                            var responseF = json.decode(response.body);
                            if (responseF[0]['status'] == "success") {
                              Navigator.pop(context);
                              final snackBar = SnackBar(
                                backgroundColor: Colors.green[800],
                                content: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                    ),
                                    Text(' Reminder send successfully'),
                                  ],
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar);
                            }
                            else {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red[800],
                                content: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                    ),
                                    Text(' Some error occured'),
                                  ],
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar);
                            }
                          },
                        );
                      }
                    }

                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: checkPaymentStatus(),
                          title: Row(
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.rupeeSign,
                                color: Colors.black,
                                size: 11,
                              ),
                              Text(" ${dataFinal['amount']}"),
                            ],
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Payment Status : "),
                                  Text(dataFinal['payment_status'])
                                ],
                              )
                            ],
                          ),
                          trailing: checkReminderStatus(),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.only(bottom: 20.00),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.00,
                                              bottom: 15.00,
                                              left: 10.00),
                                          child: Text(
                                            "ENQUIRY DETAILS",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.blue[800]),
                                      ),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 15.00),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Amount : "),
                                              FaIcon(
                                                FontAwesomeIcons.rupeeSign,
                                                size: 12,
                                              ),
                                              Text(dataFinal['amount'])
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 4.00),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Description : "),
                                              Text(dataFinal['description'])
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 4.00),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Updated By : "),
                                              Text(dataFinal['updated_by'])
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 4.00),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Last Date : "),
                                              Text(dataFinal['last_date'])
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 4.00),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Updated On : "),
                                              Text(dataFinal['updated_on'])
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 4.00),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Payment Status : "),
                                              Text(dataFinal['payment_status'])
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 4.00),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Payment Date : "),
                                              Text(dataFinal['payment_date'])
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.8,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 4.00),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Razorpay Reference ID : "),
                                              Text(dataFinal['refference_id'])
                                            ],
                                          ),
                                        ),
                                      )
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
                  }
                  else{

                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                        child: Text("No data found"),
                      ),
                    );
                  }

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
