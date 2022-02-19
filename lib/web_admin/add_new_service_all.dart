import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class add_new_service_all extends StatefulWidget {
  _add_new_service_all createState() => _add_new_service_all();
}

class _add_new_service_all extends State<add_new_service_all> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _service_name = new TextEditingController();
  final _service_description = new TextEditingController();
  GlobalKey _keyEditor = GlobalKey();
  CollectionReference _service_fir =
      FirebaseFirestore.instance.collection('services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("ADD NEW SERVICE"),
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
                      controller: _service_name,
                      decoration: InputDecoration(
                        labelText: "Service Name",
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
                        controller: _service_description,
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
        child: Text('NEXT', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () {
          _service_fir.add({
            'service_heading': _service_name.text,
            'service_description': _service_description.text,
            'documents_required': "not_found",
            'office_details': "not_found"
          }).then((value) {
            // print(value.id);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => update_documents_required(value.id)),
            );
          }).catchError((error) => print("Failed to add user: $error"));
        },
      ),
    );
  }
}

class update_documents_required extends StatefulWidget {
  final doc_id;

  update_documents_required(this.doc_id);

  _update_documents_required createState() => _update_documents_required();
}

class _update_documents_required extends State<update_documents_required> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _service_name = new TextEditingController();
  final _documents_requried = new TextEditingController();
  GlobalKey _keyEditor = GlobalKey();
  CollectionReference _service_fir =
      FirebaseFirestore.instance.collection('services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("DOCUMENTS REQUIRED"),
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
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      child: TextFormField(
                        controller: _documents_requried,
                        textAlign: TextAlign.start,
                        maxLines: 20,
                        decoration: InputDecoration(
                          labelText: "Documents Required",
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
        child: Text('NEXT', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () {
          _service_fir.doc(widget.doc_id).update({
            'documents_required': _documents_requried.text,
          }).then((value) {
            // print(value.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => office_details(widget.doc_id)),
            );

          }).catchError((error) => print("Failed to add user: $error"));
        },
      ),
    );
  }
}
class office_details extends StatefulWidget{
  final doc_id;
  office_details(this.doc_id);
  _office_details createState() => _office_details();
}
class _office_details extends State<office_details> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();
  final _service_name = new TextEditingController();
  final _office_docs_requried = new TextEditingController();
  GlobalKey _keyEditor = GlobalKey();
  CollectionReference _service_fir =
  FirebaseFirestore.instance.collection('services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("OFFICE DETAILS"),
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
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      child: TextFormField(
                        controller: _office_docs_requried,
                        textAlign: TextAlign.start,
                        maxLines: 20,
                        decoration: InputDecoration(
                          labelText: "Office Details Required",
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
        child: Text('FINISH', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () {
          _service_fir.doc(widget.doc_id).update({
            'office_details': _office_docs_requried.text,
          }).then((value) {
            final snackBar = SnackBar(
              backgroundColor: Colors.green[800],
              content: const Text('Successfully updated service'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Navigator.pushNamed(context, 'our_services');
          }).catchError((error) => print("Failed to add user: $error"));
        },
      ),
    );
  }
}
