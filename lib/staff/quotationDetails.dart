import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../settingsAllFle.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class quotationDetails extends StatefulWidget {
  var quotation_id;
  var send_date_and_time;
  var file_name;
  var client_review_status;
  var customerPhone;

  quotationDetails(
    this.quotation_id,
    this.send_date_and_time,
    this.file_name,
    this.client_review_status,
    this.customerPhone,
  );

  _quotationDetails createState() => _quotationDetails();
}

class _quotationDetails extends State<quotationDetails> {
  @override
  Widget build(BuildContext context) {
    reviewStatusCheck() {
      if (widget.client_review_status == "0") {
        return Row(
          children: <Widget>[
            SizedBox(
              width: 13.00,
              height: 13.00,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text("Waiting for review"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'pdfViewer',
                    arguments: {"fileName": widget.file_name});
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.00),
                    child: FaIcon(
                      FontAwesomeIcons.filePdf,
                      size: 17,
                      color: Colors.red[300],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.00),
                    child: Text(
                      "View Quotation",
                      style: TextStyle(color: Colors.black87),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      } else {
        return Row(
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 18,
              color: Colors.green,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text("Client reviewed"),
            )
          ],
        );
      }
    }

    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 15.00,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Quotation send on : ",
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 15.00,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                widget.send_date_and_time,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: reviewStatusCheck(),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20.00),
          child: Container(
            margin: EdgeInsets.only(left: 10.00),
            child: InputChip(
              avatar: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.phone,
                  size: 12,
                ),
              ),
              label: const Text('Call to Customer'),
              onPressed: () async {
                final url = "tel:${widget.customerPhone}";
                if (await canLaunch(url) != null) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20.00),
          child: Container(
            margin: EdgeInsets.only(left: 10.00),
            child: InputChip(
              avatar: CircleAvatar(
                backgroundColor: Colors.orange[300],
                child: Icon(
                  Icons.notification_add,
                  size: 12,
                ),
              ),
              label: const Text('Push notification'),
              onPressed: () async {
                const AndroidNotificationDetails
                    androidPlatformChannelSpecifics =
                    AndroidNotificationDetails('your channel id',
                        'your channel name', 'your channel description',
                        importance: Importance.max,
                        priority: Priority.high,
                        showWhen: false);
                const NotificationDetails platformChannelSpecifics =
                    NotificationDetails(
                        android: androidPlatformChannelSpecifics);
                await flutterLocalNotificationsPlugin.show(
                    0, 'plain title', 'plain body', platformChannelSpecifics,
                    payload: 'item x');
              },
            ),
          ),
        ),
      ],
    );
  }
}
