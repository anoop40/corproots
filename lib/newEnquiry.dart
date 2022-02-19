import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'newEnquiry/service_details.dart';

class newEnquiry extends StatefulWidget {
  _newEnquiry createState() => _newEnquiry();
}

class _newEnquiry extends State<newEnquiry> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  CollectionReference _our_services_count =
      FirebaseFirestore.instance.collection('services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("New Enquiry"),
      ),
      /*
      bottomNavigationBar: RoundedLoadingButton(
        color: Colors.blue[800],
        borderRadius: 3.00,
        width: MediaQuery.of(context).size.width,
        child: Text('SUBMIT NOW', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () {},
      ),
      */
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                bottom: MediaQuery.of(context).size.height * 0.01,
                left: 10,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "BUSINESS REGISTRATIONS",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.98,
              child: Wrap(
                children: <Widget>[
                  StreamBuilder(
                    stream: _our_services_count.snapshots(),
                    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) =>
                              // Text(streamSnapshot.data!.docs[index]['amount']),
                              Padding(
                            padding: EdgeInsets.only(left: 6.00),
                            child: ActionChip(
                              pressElevation: 15.00,
                              elevation: 3.0,
                              padding: EdgeInsets.all(2.0),
                              label: Text(snapshot.data!.docs[index]
                                  ['service_heading']),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => service_details(
                                          snapshot.data!.docs[index].id)),
                                );
                                // Navigator.pushNamed(context, 'pvtltdEnquiry');
                              },
                              backgroundColor: Colors.white60,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
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
                  )
                  /*
                  Padding(
                    padding: EdgeInsets.only(left: 6.00),
                    child: ActionChip(

                      pressElevation: 15.00,
                      elevation: 3.0,
                      padding: EdgeInsets.all(2.0),
                      label: Text('Private Limited Company'),
                      onPressed: () {
                        Navigator.pushNamed(context, 'pvtltdEnquiry');
                      },
                      backgroundColor: Colors.white60,
                      shape: StadiumBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),
  */
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
