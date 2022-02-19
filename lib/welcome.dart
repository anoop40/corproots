import 'dart:async';

import 'package:corproots/users/dashboardCourosalSlider.dart';
import 'package:corproots/users/myRequests.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyProfileLoading.dart';



class Welcome extends StatefulWidget {
  final int _selectedIndexFrom;

  Welcome(this._selectedIndexFrom);

  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  int _selectedIndex = 0;
  late var str;

  Future<String> checkDeviceIdData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.containsKey('deviceId');
    /*
    var serverUrlfinal = "${SettingsAllFle.finalURl}check-user-details";
    var response_ur = await http.post(Uri.parse(serverUrlfinal), body: {
      "device_id": prefs.getString('deviceId'),
    }, headers: {
      "Accept": "application/json"
    });

    var resultCon = json.decode(response_ur.body);
    */
    return "true";
  }

  receiveMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  void initState() {
    super.initState();
    str = checkDeviceIdData();
    _onItemTapped(widget._selectedIndexFrom);
    receiveMessage();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    DashboardCourrosalSlider(),
    myRequests(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    MyProfileLoading(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Corp Roots Consultants"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[


          IconButton(
            icon: const  FaIcon(FontAwesomeIcons.rupeeSign, size: 19,),
            onPressed: () {
              Navigator.pushNamed(context, 'payment-notifications-user');
            },
          ),
          IconButton(
            icon: const  Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, 'notifications-user');
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: str,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    // The containers in the background
                    new Column(
                      children: <Widget>[
                        new Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              image: new DecorationImage(
                            image:
                                new AssetImage("assets_files/background2.png"),
                            fit: BoxFit.fill,
                          )),
                        ),
                      ],
                    ),

                    _widgetOptions.elementAt(_selectedIndex),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.local_offer_outlined),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'My Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
