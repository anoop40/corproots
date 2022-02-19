import 'package:badges/badges.dart';
import 'package:corproots/settingsAllFle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class dashboardItemsStaffs extends StatefulWidget {
  _dashboardItemsStaffs createState() => _dashboardItemsStaffs();
}

class _dashboardItemsStaffs extends State<dashboardItemsStaffs> {
  late Future str;
  var totalCount;

  @override
  void initState() {
    super.initState();
    str = checkTotalPendings();
  }

  Future checkTotalPendings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal =
        "${SettingsAllFle.finalURl}check-pending-remainders-counts";

    var response_ur = await http.post(Uri.parse(serverUrlfinal), body: {
      "user_id": prefs.getString('userId'),
    }, headers: {
      "Accept": "application/json"
    });
    // print("Total count : " + response_ur.body);
    var remainingCount = json.decode(response_ur.body);
    setState(() {
      totalCount = remainingCount[0]['countTotal'];
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: str,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: checkTotalPendings,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    margin: EdgeInsets.only(
                      top: 15,
                      left: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.count(
                        primary: false,
                        crossAxisCount: 3,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              top: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, 'pendingTasks');
                              },
                              child: Badge(
                                animationType: BadgeAnimationType.scale,
                                toAnimate: true,
                                shape: BadgeShape.square,
                                badgeColor: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                                badgeContent: Text(
                                    '${totalCount.toString()} Tasks',
                                    style: TextStyle(color: Colors.white)),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Image(
                                        alignment: Alignment.center,
                                        fit: BoxFit.fill,
                                        height: 70,
                                        image: AssetImage(
                                            'assets_files/To-do-List-scaled.png'),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 1,
                                      ),
                                      child: Text("Pending Tasks"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
