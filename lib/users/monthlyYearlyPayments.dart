import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class monthlyYearlyPayments extends StatefulWidget {
  _monthlyYearlyPayments createState() => _monthlyYearlyPayments();
}

class _monthlyYearlyPayments extends State<monthlyYearlyPayments> {
  late var userIdLoad;
  late Future str;
  getData() async {
    print("Welcoem all users");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("User id stored 123 : " + prefs.getString('userId').toString());
    setState(() {
      userIdLoad = prefs.getString('userId').toString();
    });
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getData();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: str,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 10.00, top: 10.00, bottom: 8.00),
                child: Text(
                  "Monthly Reminders",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(

                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('reminders/${userIdLoad}/monthly')
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if(streamSnapshot.data != null) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (ctx, index) =>
                        // Text(streamSnapshot.data!.docs[index]['amount']),

                        Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                  streamSnapshot.data!
                                      .docs[index]['description']),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 8.00),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 16,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 1.00),
                                      child: Text(
                                          "${streamSnapshot.data!
                                              .docs[index]['day_to_remind_on_month']} th of every month"),
                                    )
                                  ],
                                ),
                              ),
                              trailing: Text(
                                  "Rs ${streamSnapshot.data!
                                      .docs[index]['amount']}"),

                            ),
                            Divider(),
                          ],
                        ),
                      );
                    }
                    else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 10.00, top: 10.00, bottom: 8.00),
                child: Text(
                  "Yearly Reminders",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(

                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('reminders/${userIdLoad}/yearly')
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if(streamSnapshot.data != null) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (ctx, index) =>
                          // Text(streamSnapshot.data!.docs[index]['amount']),
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(streamSnapshot.data!.docs[index]
                                ['description']),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 8.00),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.date_range,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 1.00),
                                        child: Text(
                                            "${streamSnapshot.data!
                                                .docs[index]['day_to_remind']} th of ${streamSnapshot
                                                .data!
                                                .docs[index]['month_to_remind']} every year"),
                                      )
                                    ],
                                  ),
                                ),
                                trailing: Text(
                                    "Rs ${streamSnapshot.data!
                                        .docs[index]['amount']}"),

                              ),
                              Divider(),
                            ],
                          ));
                    }
                    else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          );
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
