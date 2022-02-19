import 'package:corproots/registered_users/myDashboardItems.dart';
import 'package:corproots/registered_users/myRequests.dart';
import 'package:flutter/material.dart';

import 'RegisteredUserDrawer.dart';

class UserDash extends StatefulWidget {
  _UserDash createState() => _UserDash();
}

class _UserDash extends State<UserDash> {
  var _titleText;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleText = Text("Welcome");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MyDashboardItems(),
      MyRequests(),
      //Admin_dash(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: _titleText,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      drawer: RegisteredUserDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'My Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'Offers',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      /*
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets_files/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      */
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
