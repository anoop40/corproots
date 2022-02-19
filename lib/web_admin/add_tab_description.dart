import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
class add_tab_description extends StatefulWidget{
  final document_id;
  add_tab_description(this.document_id);
  _add_tab_description createState() => _add_tab_description();
}
class _add_tab_description extends State<add_tab_description>{
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();
  final _tab_head = new TextEditingController();
  final _tab_description = new TextEditingController();
  CollectionReference _service_fir =
  FirebaseFirestore.instance.collection('services_tabs');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("SERVICE - TABS"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 25.00),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _tab_head,
                      decoration: InputDecoration(
                        labelText: "Tab Heading",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 9.0),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      child: TextFormField(
                        controller: _tab_description,
                        textAlign: TextAlign.start,
                        maxLines: 20,
                        decoration: InputDecoration(
                          labelText: "Introduction",
                          alignLabelWithHint: true,
                          contentPadding:
                          EdgeInsets.only(top: 40.00, left: 9.00),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: RoundedLoadingButton(
        width: MediaQuery.of(context).size.width,
        color: Colors.blue[800],
        borderRadius: 1.50,
        child: Text('UPDATE', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () {
          _service_fir.add({
            'service_tab_heading': _tab_head.text,
            'service_tab_description': _tab_description.text,
            'services_doc_id' : widget.document_id
          }).then((value) {
            showModalBottomSheet<void>(

              context: context,
              isDismissible: false,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  color: Colors.amber,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElevatedButton(

                          child: const Text('FINISH'),
                          onPressed: (){
                            Fluttertoast.showToast(
                                msg: "Service added successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 5,
                                webBgColor: "#17831E",
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pushNamed(context, 'our_services');
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: ElevatedButton(
                            child: const Text('ADD MORE'),
                            onPressed: () {
                              Navigator.pop(context);
                              _btnController.reset();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }).catchError((error) => print("Failed to add user: $error"));
        },
      ),
    );
  }
}