import 'package:basic_utils/basic_utils.dart';
import 'package:corproots/staff/dashboard_items.dart';
import 'package:corproots/staff/myJobs.dart';
import 'package:flutter/material.dart';
import 'package:corproots/admin/countTotalNotifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_items.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'myClients.dart';

class staffDash extends StatefulWidget {
  _staffDash createState() => _staffDash();
}

class _staffDash extends State<staffDash> {
  int _selectedIndex = 0;
  var userName;
 late Future str;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

   getSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
    if(prefs.containsKey('staff_dash_my_jobs_listing_tab')){
      setState(() {
        _selectedIndex = 1;
      });
    }
    return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getSessionData();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      dashboardItemsStaffs(),
      MyJobs(),
      dashboardItemsStaffs(),
      MyClients(),
      //Admin_dash(),
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder(
        future: str,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue[800],
                automaticallyImplyLeading: false,
                title: Text("Welcome " + StringUtils.capitalize(userName)),
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
                    label: 'My Jobs',
                    icon: countTotalNotifications(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: 'Reminders',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.users),
                    label: 'My Clients',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
              body: _widgetOptions.elementAt(_selectedIndex),
            );
          }
          else{
            return Scaffold(
              appBar: AppBar(
                title: Text("Welcome " + StringUtils.capitalize(userName.toString())),
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
                      label: 'My Jobs',
                      icon: countTotalNotifications(),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Reminders',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.users),
                      label: 'My Clients',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped,
                ),
              body: Container(
                child: Center(
                  child : CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
