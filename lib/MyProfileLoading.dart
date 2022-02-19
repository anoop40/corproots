import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corproots/settingsAllFle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileLoading extends StatefulWidget {
  _MyProfileLoading createState() => _MyProfileLoading();
}

class _MyProfileLoading extends State<MyProfileLoading> {
  late Future str;
  late var personalDetails;
  var userCurrentSt;
  late var user_doc_id ;

  Future<String> checkUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*
    var serverUrlfinal = "${SettingsAllFle.finalURl}get-profile-details";

    var response = await http.post(Uri.parse(serverUrlfinal),
        body: {'deviceId': prefs.getString('deviceId')},
        headers: {"Accept": "application/json"});
    print(response.body);
    this.setState(() {
      personalDetails = json.decode(response.body);
    });
    if (personalDetails[0]['status2'] == "success") {
      prefs.setString('userId', personalDetails[0]['userId']);
    }
    */
    if(prefs.containsKey('user_document_id')) {
      setState(() {
        user_doc_id = prefs.getString('user_document_id');
      });
    }
    else{
      setState(() {
        user_doc_id = "123";
      });
    }
    print("Dvice tok : " + user_doc_id.toString());
    return "true";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = checkUserDetails();
  }

  userCurrentStatsu() {
    if (personalDetails[0]['status'] == 'enable') {
      return Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            Text(" Active", style: TextStyle(fontSize: 15)),
          ],
        ),
      );
    } else {
      return Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.close_rounded,
              color: Colors.red,
            ),
            Text(" Suspended", style: TextStyle(fontSize: 15)),
          ],
        ),
      );
    }
  }

  checkStat() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_document_id')) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.03,
              bottom: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Text(
              "MY PERSONAL PROFILE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.verified_user,
                  color: Colors.green[800],
                ),
                Text(
                  " " + personalDetails[0]['user_name'],
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.email_outlined,
                ),
                Text(" " + personalDetails[0]['email'],
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                ),
                Text("+91 " + personalDetails[0]['mobile_number'],
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.date_range_rounded,
                ),
                Text(" " + personalDetails[0]['registered_on'],
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.verified_user_sharp,
                ),
                Text(" " + personalDetails[0]['userType'],
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Divider(),
          userCurrentStatsu(),
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.zero,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'loginSignup');
          },
          child: Text('LOGIN / SIGNUP'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot>(
        future: users.doc(user_doc_id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  children: <Widget>[
                    Text("There is no data found"),
                    Padding(
                      padding: EdgeInsets.only(top: 6.00),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'loginSignup');
                        },
                        child: Text('LOGIN / SIGNUP'),
                      ),
                    ),
                  ],
                ),
              ) ,
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            //return Text("Full Name: ${data['user_name']} ${data['mobile_number']}");
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.13),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image(
                        image: AssetImage("assets_files/unnamed.png"),
                      ),
                    ),
                  ),
                  // checkStat(),

                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Text(
                      "SERVICES",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(Icons.production_quantity_limits),
                      title: Text("My Services"),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(Icons.upload_file_sharp),
                      title: Text("My Documents"),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () async {
                        Navigator.pushNamed(context, 'myDocumentsUser');
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(Icons.star_border_sharp),
                      title: Text("Rate our App"),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(Icons.file_copy),
                      title: Text("Privacy Policy"),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(Icons.help_outline),
                      title: Text("Help & Feedback"),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Logout"),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.pushNamed(context, 'loginSignup');
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          else{
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}
