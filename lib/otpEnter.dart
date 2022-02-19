import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class otpEnter extends StatefulWidget {
  _LoginSignup createState() => _LoginSignup();
}

class _LoginSignup extends State<otpEnter> {
  FirebaseFirestore _firestoreRefference = FirebaseFirestore.instance;

  Future addUserToDatabase() async {
    var documentId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var doc_ref = await FirebaseFirestore.instance
        .collection("users")
        .where('mobile_number', isEqualTo: prefs.getString('userMobileNumber'))
        .get();
    doc_ref.docs.forEach((result) {
      documentId = result.id;
    });

    CollectionReference usersL = FirebaseFirestore.instance.collection('users');
    QuerySnapshot users = await _firestoreRefference
        .collection('users')
        .where('mobile_number', isEqualTo: prefs.getString('userMobileNumber'))
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = users.docs;
    if (documents.length == 0) {
      usersL.add({
        "mobile_number": prefs.getString('userMobileNumber'),
        "deviceId": prefs.getString('deviceId'),
        "user_type": 'normal_user',
        "user_name" : 'not_found'
      }).then((value) {
        prefs.setString('user_id', value.id);
        Navigator.pop(context);
        final snackBar = SnackBar(
          backgroundColor: Colors.green[800],
          content: Row(
            children: <Widget>[
              Icon(
                Icons.check,
                color: Colors.white,
              ),
              Text("Logged in")
            ],
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((error) => print("Failed on adding $error"));
    } else {
      usersL
          .doc(documentId)
          .update({'deviceId': prefs.getString('deviceId')})
          .then((value) => print("User successfuly updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
    var doc_ref2 = await FirebaseFirestore.instance
        .collection("users")
        .where('deviceId', isEqualTo: prefs.getString('deviceId'))
        .get();
    doc_ref2.docs.forEach((result) {
      prefs.setString('user_doc_id', documentId.toString());
      if(result['user_type'] == "admin"){
        prefs.setString('user_type','admin');
        prefs.setString('user_document_id',documentId.toString());
      }
      if(result['user_type'] == "normal_user"){
        prefs.setString('user_type','normal_user');
        prefs.setString('user_document_id',documentId.toString());
      }
      if(result['user_type'] == "staff"){
        prefs.setString('user_type','staff');
        prefs.setString('user_document_id',documentId.toString());
      }
    });
    print("before novigation ");
    Navigator.pushNamed(context, 'userCheck');
    /*
    users.add({
      "mobile_number": prefs.getString('userMobileNumber'),
      "deviceId": prefs.getString('deviceId'),
      "user_type": 'normal_user',
    }).then((value) {
      prefs.setString('user_id', value.id);
      Navigator.pop(context);
      final snackBar = SnackBar(
        backgroundColor: Colors.green[800],
        content: Row(
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Text("Logged in")
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((error) => print("Failed on adding $error"));
    */
    /*
    var serverUrlfinal =
        "${SettingsAllFle.finalURl}save-new-user";

    var response_ur =
    await http.post(Uri.parse(serverUrlfinal), body: {
      "mobile_number": prefs.getString('userMobileNumber'),
      "deviceId" : prefs.getString('deviceId')
    }, headers: {
      "Accept": "application/json"
    });
    print("From server : " + response_ur.body);
    var resultCon = json.decode(response_ur.body);
    if(resultCon[0]['status'].toString() == "success"){
      prefs.setString('userType',resultCon[0]['userType']);
      prefs.setString('userId', resultCon[0]['userId'].toString());
      if(resultCon[0]['user_name'] == "not_found"){
        Navigator.pushNamed(context, 'updateProfile');
      }
      else{
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Welcome(3),
            ));
      }

    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Verify Mobile Number",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
              child: Image(
                image: AssetImage("assets_files/otp.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15.00, left: 15.00),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: OTPTextField(
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 50,
                        style: TextStyle(fontSize: 17),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        onCompleted: (pin) async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                          AlertDialog alert = AlertDialog(
                            content: new Row(
                              children: [
                                CircularProgressIndicator(),
                                Container(
                                    margin: EdgeInsets.only(left: 7),
                                    child: Text(" Please wait")),
                              ],
                            ),
                          );
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                          if (prefs.getString('otp') == pin) {
                            await addUserToDatabase();
                          } else {
                            Navigator.pop(context, false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('OTP miss match')),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 14),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  AlertDialog alert = AlertDialog(
                    content: new Row(
                      children: [
                        CircularProgressIndicator(),
                        Container(
                            margin: EdgeInsets.only(left: 7),
                            child: Text(" Please wait")),
                      ],
                    ),
                  );
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                  var otpCode;
                  var rng = new Random();
                  for (var i = 1001; i < 9999; i++) {
                    otpCode = rng.nextInt(9999);
                  }

                  prefs.setString("otp", otpCode.toString());
                  var response = await http.post(
                      Uri.parse(
                          "https://app.getlead.co.uk/api/pushsms?username=918157954264&token=gl_8edffd785828da352fba&sender=golabs&to=" +
                              prefs.getString('userMobileNumber').toString() +
                              "&message=Thank you for register on Corproots. Your OTP is " +
                              otpCode.toString() +
                              " by golabsoft&priority=11&message_type=0"),
                      headers: {"Accept": "application/json"});
                  print("New OTP is : " + otpCode.toString());
                  var resultCon = json.decode(response.body);
                  if (resultCon['status'].toString() == "success") {
                    Navigator.pop(context, false);
                  }
                },
                child: const Text('Resend OTP'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
