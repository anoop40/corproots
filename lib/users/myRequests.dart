import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myRequests extends StatefulWidget {
  _myRequests createState() => _myRequests();
}

class _myRequests extends State<myRequests> {
  late Future str;
  late List myRequests;
  late var userDocumentId;

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
/*
    var serverUrlfinal = "${SettingsAllFle.finalURl}list-my-enquiries-user";
    print("User ID is : " + prefs.getString('userId').toString());
    var response = await http.post(Uri.parse(serverUrlfinal),
        body: {'userId': prefs.getString('userId')},
        headers: {"Accept": "application/json"});
    print("My enquiries listing " + response.body);
    this.setState(() {
      myRequests = json.decode(response.body) as List<dynamic>;
    });

 */
    if(prefs.containsKey('user_document_id')) {
      setState(() {
        userDocumentId = prefs.getString('user_document_id');
      });
    }
    else{
      setState(() {
        userDocumentId = "12";
      });
    }
    print("My request doc id :" + userDocumentId);
    return "true";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('enquiries')
                    .where('user_document_id', isEqualTo: userDocumentId)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.data != null) {

                   if(streamSnapshot.data!.docs.length > 0) {
                     return ListView.builder(
                         scrollDirection: Axis.vertical,
                         shrinkWrap: true,
                         itemCount: streamSnapshot.data!.docs.length,
                         itemBuilder: (ctx, index) {
                           // Text(streamSnapshot.data!.docs[index]['amount']),

                           return Column(
                             children: <Widget>[
                               ListTile(
                                 title: Text(streamSnapshot.data!.docs[index]
                                 ['enquiry_category']),
                                 subtitle: Padding(
                                   padding: EdgeInsets.only(top: 14.00),
                                   child: Row(
                                     children: <Widget>[
                                       Icon(
                                         Icons.date_range,
                                         size: 15,
                                       ),
                                       Padding(
                                         padding: EdgeInsets.only(left: 5.00),
                                         child: Text(streamSnapshot
                                             .data!
                                             .docs[index]['enquiry_date']),
                                       ),
                                       Padding(
                                         padding: EdgeInsets.only(left: 8.00),
                                         child: Icon(
                                           Icons.verified_user,
                                           size: 15,
                                         ),
                                       ),
                                       Padding(
                                         padding: EdgeInsets.only(left: 5.00),
                                         child: Text(streamSnapshot
                                             .data!.docs[index]['status']),
                                       )
                                     ],
                                   ),
                                 ),
                               ),
                               Divider(),
                             ],
                           );
                         });
                   }
                   else{
                     return Center(
                       child: Padding(
                         padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                         child: Column(
                           children: <Widget>[
                             Text("Login to view your requests"),
                             Padding(
                               padding: EdgeInsets.only(top: 6.00),
                               child: ElevatedButton(
                                 onPressed: () {
                                   Navigator.pushNamed(context, 'loginSignup');
                                 },
                                 child: Text('LOGIN / SIGNUP'),
                               ),
                             )
                           ],
                         ),
                       ),
                     );
                   }
                  } else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
