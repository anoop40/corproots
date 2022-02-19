import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'profile/My_personal_profile_contents.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileUser extends StatefulWidget {
  _MyProfileUser createState() => _MyProfileUser();
}

class _MyProfileUser extends State<MyProfileUser> {
  late List myEnquiries;
  late Future str;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-my-enquiries-user";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "userId": prefs.getString('userId'),
    });
    print("REsponse form server : " + response.body);
    this.setState(() {
      myEnquiries = json.decode(response.body) as List<dynamic>;
    });

    return "1";
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //str = getData();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      My_personal_profile_contents(),
      My_personal_profile_contents(),
      //Admin_dash(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Personal Profile',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Company Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
