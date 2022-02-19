import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corproots/newEnquiry/service_details.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class our_services extends StatefulWidget{
  _our_services createState() => _our_services();
}
class _our_services extends State<our_services>{
  CollectionReference _our_services_count =
  FirebaseFirestore.instance.collection('services');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("SAVED SERVICES "),

      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _our_services_count.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) =>
                // Text(streamSnapshot.data!.docs[index]['amount']),

                Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ListTile(
                        title:
                        Text(snapshot.data!.docs[index]['service_heading']),

                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 8.00),

                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete',
                          onPressed: () {
                            _our_services_count
                                .doc(snapshot.data!.docs[index].id)
                                .delete()
                                .then((value){
                              Fluttertoast.showToast(
                                  msg: "Service deleted successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 5,
                                  webBgColor: "#17831E",
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            })
                                .catchError((error) => print("Failed to delete user: $error"));
                          },
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => service_details(
                                    snapshot.data!.docs[index].id)),
                          );
                        },
                      ),
                    ),
                    Divider(),
                  ],
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'add-new-service');
        },
        label: Text("ADD NEW"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue[800],

      ),
    );
  }
}