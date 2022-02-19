import 'package:corproots/settingsAllFle.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class countTotalNotifications extends StatefulWidget {
  _countTotalNotifications createState() => _countTotalNotifications();
}

class _countTotalNotifications extends State<countTotalNotifications> {
  late Future str;
  late String totalPending;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "${SettingsAllFle.finalURl}assignedJobsStaff";

    var response_ur = await http.post(Uri.parse(serverUrlfinal), body: {
      'userId': prefs.getString('userId'),
    }, headers: {
      "Accept": "application/json"
    });
    //print(response_ur.body);
    var resultCon = json.decode(response_ur.body);
    this.setState(() {
      totalPending = resultCon[0]['count'].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      shape: BadgeShape.square,
      position: BadgePosition.topStart(),
      badgeContent: Text(
        totalPending.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
      child: Icon(
        Icons.notification_important_outlined,
      ),
    );
  }
}
