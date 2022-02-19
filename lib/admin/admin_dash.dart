import 'package:corproots/admin/countTotalNotifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ClientsList.dart';
import 'dashboard_items.dart';
import 'depts.dart';
import 'drawer_items.dart';
import 'enquiriesAdmin.dart';
import 'users.dart';

class AdminDash extends StatefulWidget {
  //final pendingJobs;
  //AdminDash(this.pendingJobs);
  _AdminDash createState() => _AdminDash();
}

class _AdminDash extends State<AdminDash> {
  late String enquiryStatus;
  int _selectedIndex = 0;

  check_if_tab_is_already_set() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('admin_dash_tab_option')){
      if(prefs.getString('admin_dash_tab_option') == "enquiries"){
        setState(() {
          _selectedIndex = 1;
        });
      }
      prefs.remove('admin_dash_tab_option');
    }
  }
  @override
  void initState() {
    super.initState();
    check_if_tab_is_already_set();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      dashboardItems(),
      enquiriesAdmin(),
      Users(),
      depts(),
      Users(),
      ClientsList(),
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[800],
        title: Text("Welcome Admin "),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 14.0),
            child: countTotalNotifications(),
          ),
        ],
      ),
      drawer: drawer_items(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            label: 'Enquiries',
            icon: countTotalNotifications(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Staffs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user_outlined),
            label: 'Depts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'Offers',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user_sharp),
            label: 'Clients',
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
