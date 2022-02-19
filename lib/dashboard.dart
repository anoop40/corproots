import 'dart:convert';

import 'package:corproots/settingsAllFle.dart';
import 'package:corproots/staff/dashboard.dart';
import 'package:corproots/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'admin/admin_dash.dart';
class Dashboard extends StatefulWidget{
  _Dashboard createState() => _Dashboard();
}
class _Dashboard extends State<Dashboard>{
  late List personalDetails;
  late var userType;
  late Future str;
  Future<String> userTypeTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}get-profile-details";

    var response = await http.post(Uri.parse(serverUrlfinal),
        body: {'deviceId': prefs.getString('deviceId')},
        headers: {"Accept": "application/json"});

print("From server is : "+response.body);
    personalDetails = json.decode(response.body);

    if (personalDetails[0]['status2'] == "success") {
      setState(() {
        userType = personalDetails[0]['userType'];
      });

     // print("User ID is : " + personalDetails[0]['userId'].toString());
      prefs.setString('userId', personalDetails[0]['userId']);
      prefs.setString('user_name', personalDetails[0]['user_name']);
      prefs.setString('userType', personalDetails[0]['userType']);

    } else {
      setState(() {
        userType = "not_found";
      });
    }

    return "true";
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print("in inti state dashboard");
    str = userTypeTest();

  }
  @override
  Widget build(BuildContext context) {
     return FutureBuilder(
       future: str,
       builder: (context,snapshot){
         if(snapshot.hasData){
           if(userType.toString() == "admin") {
             return Scaffold(
               body: AdminDash(),
             );
           }

           if(userType.toString() == "staff") {
             return Scaffold(
               body: staffDash(),
             );
           }
           else{
             return Scaffold(
               body: Welcome(0),
             );
           }
         }
         else{
           return Scaffold(
             body: Center(
               child: CircularProgressIndicator(),
             ),
           );
         }
       },
     );
    

  }
}