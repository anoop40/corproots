import 'dart:async';

import 'package:flutter/material.dart';

class dashboardItems extends StatefulWidget {
  _dashboardItems createState() => _dashboardItems();
}

class _dashboardItems extends State<dashboardItems> {
  late Future str;
  late String enquiryStatus;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(
              top: 15,
              left: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Text(
              "Assignments",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.96,
            margin: EdgeInsets.only(
              top: 5,
              left: MediaQuery.of(context).size.width * 0.02,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.count(
                primary: false,
                crossAxisCount: 3,
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Image(
                            alignment: Alignment.center,
                            fit: BoxFit.fill,
                            height: 70,
                            image: AssetImage('assets_files/new_re_admin.png'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                          ),
                          child: Text(
                            "Enquiries",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Image(
                            alignment: Alignment.center,
                            fit: BoxFit.fill,
                            height: 70,
                            image: AssetImage('assets_files/jobs.png'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                          ),
                          child: Text(
                            "Jobs",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
