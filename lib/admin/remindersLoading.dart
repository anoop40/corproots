import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class remindersLoading extends StatefulWidget {
  _remindersLoading createState() => _remindersLoading();
}

class _remindersLoading extends State<remindersLoading> {
  FirebaseFirestore _firestoreRefference = FirebaseFirestore.instance;
  late var userId;
  CollectionReference reminders =
      FirebaseFirestore.instance.collection('reminders');

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('client_id');
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Reminders"),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.00,
        onPressed: () async {
          Navigator.pushNamed(
            context,
            "payment-reminder-step1",
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    .collection('reminders/${userId}/monthly')
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
                            leading: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black54,
                              ),
                              onPressed: () async {
                                var documentId =
                                    streamSnapshot.data!.docs[index].id;
                                await FirebaseFirestore.instance
                                    .collection('reminders/${userId}/monthly')
                                    .doc(documentId)
                                    .delete()
                                    .whenComplete(
                                      () =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                            'Successfully Deleted',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                )
                                    .catchError((e) => print(e));
                              },
                            ),
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
                    .collection('reminders/${userId}/yearly')
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
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black54,
                                ),
                                onPressed: () async {
                                  var documentId =
                                      streamSnapshot.data!.docs[index].id;
                                  await FirebaseFirestore.instance
                                      .collection('reminders/${userId}/yearly')
                                      .doc(documentId)
                                      .delete()
                                      .whenComplete(
                                        () =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                              'Successfully Deleted',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                  )
                                      .catchError((e) => print(e));
                                },
                              ),
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
        ),
      ),
    );
  }
}
