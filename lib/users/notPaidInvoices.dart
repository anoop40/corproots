import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class notPaidInvoices extends StatefulWidget {
  _notifications_user createState() => _notifications_user();
}

class _notifications_user extends State<notPaidInvoices> {
  late List notifications;
  late Future str;
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;
  late String userID;
  late var primaryKeyRefference;
  final DBReference = FirebaseDatabase.instance.reference();


  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-notifications";

    var response = await http.post(Uri.parse(serverUrlfinal), body: {
      'userId': prefs.getString('userId'),
      'payment_status': "not_paid"
    }, headers: {
      "Accept": "application/json"
    });
    // print("NOtifications : " + response.body.toString());
    this.setState(() {
      notifications = json.decode(response.body) as List<dynamic>;
    });

    return true;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    //print("Payment ID : " +response.paymentId.toString() + " and Refference key : " + primaryKeyRefference.toString());
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text(" Please wait...")),
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
    var serverUrlfinal = "${SettingsAllFle.finalURl}/update-payment-details";

    var responseSer = await http.post(Uri.parse(serverUrlfinal), body: {
      'id': primaryKeyRefference.toString(),
      'refference_id': response.paymentId.toString()
    }, headers: {
      "Accept": "application/json"
    });
    print("From server : "+responseSer.body);
    var result = json.decode(responseSer.body);
    if (result[0]['status'] == "success") {
      Navigator.pop(context);
      Navigator.pop(context);

      //DBReference.child('paymentRequests').child('refference_key').child(primaryKeyRefference.toString()).remove();
      await DBReference.child('paymentRequests/${primaryKeyRefference.toString()}').remove();

      /* realtime goes here */

      /* ends here */
      final snackBar = SnackBar(
        backgroundColor: Colors.green[800],
        content: Row(
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.00),
              child: Text("Your payment successfully received"),
            ),
          ],
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      getData();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void initState() {
    super.initState();
    str = getData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: str,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> dataFinal = notifications[index];

                  if (dataFinal['status'] == "success") {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: Colors.blue,
                          ),
                          title: Row(
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.rupeeSign,
                                size: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2.00),
                                child: Text(dataFinal['amount']),
                              )
                            ],
                          ),
                          subtitle: Text(dataFinal['description']),
                          trailing: Text(
                            "Not Paid",
                            style: TextStyle(color: Colors.red[800]),
                          ),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 13.00),
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
                                              "INVOICE DETAILS",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.blue[800]),
                                        ),
                                        Container(
                                          child: Image(
                                            image: AssetImage(
                                                'assets_files/payment.png'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.00, bottom: 10.00),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              FaIcon(
                                                FontAwesomeIcons.rupeeSign,
                                                size: 18,
                                              ),
                                              Text(
                                                dataFinal['amount'],
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Text(dataFinal['description']),
                                          padding: EdgeInsets.only(top: 7.00),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.00, bottom: 9.00),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // print("Pay now button clicked");
                                              setState(() {
                                                primaryKeyRefference =
                                                dataFinal['primaryKey'];
                                              });
                                              var options = {
                                                'key': 'rzp_test_CSZMctw9E9OJy8',
                                                'amount':
                                                int.parse(dataFinal['amount']) *
                                                    100,
                                                'name': 'Corproots Consultants',
                                                'description': 'Invoice Payment',
                                                'prefill': {
                                                  'contact': '8888888888',
                                                  'email': 'test@razorpay.com'
                                                },
                                                'external': {
                                                  'wallets': ['paytm']
                                                }
                                              };

                                              try {
                                                _razorpay.open(options);
                                              } catch (e) {
                                                debugPrint('Error: e');
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue[800],
                                            ),
                                            child: Text("PAY NOW"),
                                          ),
                                        )
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
                  }
                  else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4),
                        child: Text("No records found"),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
