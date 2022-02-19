import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
class LoginSignup extends StatefulWidget {
  _LoginSignup createState() => _LoginSignup();
}

class _LoginSignup extends State<LoginSignup> {
  final _contactNumber = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                image: AssetImage("assets_files/mobileVerificaiton.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15.00, left: 15.00),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _contactNumber,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 10) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 9.0),
                        labelText: "+91",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: ElevatedButton(
                onPressed: () async {
                  print("is android : " + Platform.isAndroid.toString());
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if (_formKey.currentState!.validate()) {


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
                      prefs.setString(
                          "userMobileNumber", _contactNumber.text.toString());
                      prefs.setString("otp", otpCode.toString());
                      print("OTP is : " + otpCode.toString());

                      var response = await http.post(
                          Uri.parse(
                              "https://app.getlead.co.uk/api/pushsms?username=918157954264&token=gl_8edffd785828da352fba&sender=golabs&to=" +
                                  _contactNumber.text +
                                  "&message=Thank you for register on Corproots. Your OTP is " +
                                  otpCode.toString() +
                                  " by golabsoft&priority=11&message_type=0"),
                          headers: {
                            "Accept": "application/json",

                          });
                      print("Response from server : " + response.body);
                      var resultCon = json.decode(response.body);
                      if (resultCon['status'].toString() == "success") {
                        Navigator.pushNamed(context, 'otpEnter');
                        //Navigator.pop(context);
                      } else {
                        Navigator.pop(context, false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Some errors found. Please retry ..')),
                        );
                      }

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please enter a valid mobile number')),
                    );
                  }
                },
                child: Text('GET OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
