import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corproots/staff/dashboard.dart';
import 'package:corproots/web_admin/web_admin.dart';
import 'package:corproots/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin/admin_dash.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
class UserCheck extends StatefulWidget {
  _UserCheck createState() => _UserCheck();
}

class _UserCheck extends State<UserCheck> {
  var userType ;
  late Future str;
  CollectionReference _users_al =
  FirebaseFirestore.instance.collection('users');
  UserCheck2() async {
    print("Inside user check");
    SharedPreferences prefs = await SharedPreferences.getInstance();

   // prefs.setString('user_name','Staff');
    if (prefs.containsKey('user_type')) {
      print("inside user type");
      //print('user type is : ' + prefs.getString('user_type').toString());
      final QuerySnapshot result =
      await _users_al.where('deviceId', isEqualTo: prefs.getString('deviceId'))
          .limit(1)
          .get();
     // final List<DocumentSnapshot> documents = result.documents;
     // return documents.length == 1;
      if (prefs.getString('user_type') == "admin") {
        //return AdminDash();
        setState(() {
          userType = 'admin';
        });
      }
      if (prefs.getString('user_type') == "normal_user") {
        //return Welcome(0);
        setState(() {
          userType = 'welcome';
        });
      }
      if (prefs.getString('user_type') == "staff") {
       // return staffDash();
        setState(() {
          userType = 'staff';
        });
      }
    } else {
      print("outside user type");
      //return Welcome(0);
      setState(() {
        userType = 'welcome';
      });
    }
    return true;
  }
  @override
  void initState() {
    super.initState();
    str = UserCheck2();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future : str,
      builder: (context,snapshot){
        if(snapshot.hasData){
          print("user type : " +userType.toString());
          if(kIsWeb) {
            return web_admin();

          }
          else{
            if(userType == "admin") {
              return AdminDash();
            }
            if(userType == "staff") {

              return staffDash();
            }
            else{
              return Welcome(0);
            }
          }
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );


  }
}
