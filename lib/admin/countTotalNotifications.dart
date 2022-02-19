import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class countTotalNotifications extends StatefulWidget {
  _countTotalNotifications createState() => _countTotalNotifications();
}

class _countTotalNotifications extends State<countTotalNotifications> {
  late String totalPending;
  late Future str;

  getData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('enquiries')
        .where('admin_view_status', isEqualTo: 'not_reviewed')
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    setState(() {
      totalPending = documents.length.toString();
    });
    print("Total pending : " + totalPending.toString());
    return true;
  }

  @override
  void initState() {
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: str,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Badge(
            shape: BadgeShape.square,
            position: BadgePosition.topStart(),
            badgeContent: Text(
              totalPending.toString(),
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
            child: Icon(
              Icons.notification_important_outlined,
            ),
          );
        } else {
          return Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    /*
    return FutureBuilder(future : str,builder: (context,snapshot){
      if(snapshot.hasData){
        return Badge(
          shape: BadgeShape.square,
          position: BadgePosition.topStart(),
          badgeContent: Text(
            totalPending.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          child: Icon(
            Icons.notification_important_outlined,
          ),
        );
      }
      else{
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
    */
  }
}
