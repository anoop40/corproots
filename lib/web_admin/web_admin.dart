import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class web_admin extends StatefulWidget {
  _web_admin createState() => _web_admin();
}

class _web_admin extends State<web_admin> {
  final _formKey = GlobalKey<FormState>();
  final _user_email = new TextEditingController();
  final _passord = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("WEB ADMIN LOGIN"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      child: TextFormField(
                        controller: _user_email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.03),
                      child: TextFormField(
                        controller: _passord,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Password"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: RoundedLoadingButton(
        width: MediaQuery.of(context).size.width * 0.3,
        color: Colors.blue[800],
        borderRadius: 11,
        child: Text('LOGIN', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () async {
          print("user email : " + _user_email.text + " password is : " + _passord.text);
          if (_formKey.currentState!.validate()) {
            final QuerySnapshot result = await FirebaseFirestore.instance
                .collection('web_admin')
                .where('email', isEqualTo: _user_email.text)
                .where('password', isEqualTo: _passord.text)
                .limit(1)
                .get();
            final List<DocumentSnapshot> documents = result.docs;
            print("Length is : " + documents.length.toString());
            if(documents.length ==0){
              Fluttertoast.showToast(

                  msg: "Username or password miss match",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 4,
                  webBgColor : "#B91232",
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              _btnController.reset();
            }
            else{
              Fluttertoast.showToast(

                  msg: "Logged in successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  webBgColor : "#17831e",
                  timeInSecForIosWeb: 4,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            Navigator.pushNamed(context, 'web_admin_dashboard');
          }
          else{
            Fluttertoast.showToast(

                msg: "Wrong credentials",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 4,
              webBgColor : "#B91232",
                textColor: Colors.white,
                fontSize: 16.0,
            );
            _btnController.reset();
          }
        },
      ),
    );
  }
}
