import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class saved_document_types_all extends StatefulWidget{
  _saved_document_types_all createState() => _saved_document_types_all();
}
class _saved_document_types_all extends State<saved_document_types_all>{
  final _document_name_db = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Saved document types"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('documents_list_to_update')
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
                            leading: Icon(Icons.document_scanner_outlined),
                            title: Text(streamSnapshot.data!.docs[index]
                            ['doc_name']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline_outlined),
                              tooltip: 'Delete this item',
                              onPressed: () {
                                FirebaseFirestore.instance.collection('documents_list_to_update')
                                    .doc(streamSnapshot.data!.docs[index].id)
                                    .delete()
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Successfully deleted item",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                })
                                    .catchError((error) => print("Failed to delete user: $error"));
                              },
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
                        Text("No docs found"),

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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

          Widget okButton = FlatButton(
            child: Text("UPDATE NOW"),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('documents_list_to_update')
                  .add({
                'doc_name': _document_name_db.text,
              }).then((value) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg:
                    "Document type successfully updated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }).catchError((error) =>
                  print("Failed to add user: $error"));
            },
          );
          AlertDialog alert = AlertDialog(
            title: Text("Add new document type"),
            content: TextFormField(
              controller: _document_name_db,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(left: 5.00),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            actions: [
              okButton,
            ],
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );

        },
          label: Text("Add New"),
          icon: const Icon(Icons.add),
        backgroundColor: Colors.blue[800],
      ),
    );
  }
}