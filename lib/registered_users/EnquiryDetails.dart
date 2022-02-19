import 'package:corproots/staff/enquiryDetails/tasks.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settingsAllFle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EnquiryDetails extends StatefulWidget {
  @override
  _EnquiryDetails createState() => _EnquiryDetails();
}

class _EnquiryDetails extends State<EnquiryDetails> {
  var assignment_initial_step;
  late Future str;
  late Future statusLoading;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Tasks(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.tasks,
              color: Colors.black,
              size: 19,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Submitted Forms',
          ),
          BottomNavigationBarItem(
            label: 'Documents',
            icon: Icon(Icons.supervised_user_circle),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        title: Text("ENQUIRY STATUS"),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
