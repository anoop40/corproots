import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Newllp extends StatefulWidget {
  _Newllp createState() => _Newllp();
}

class _Newllp extends State<Newllp> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New LLP Registration"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image(image: AssetImage('assets_files/upload_file1.png')),
            ),
            Container(
              child: Text(
                "Documents Required",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text('PAN Card'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text('Passport Size Photograph'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text('ID Proof – Adhar card or passport'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text('Email Id and Phone number'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text(
                      'Address Proof : any one of the following documents:-'),
                  subtitle: Text(
                      "Bank Statement or Telephone Bill or Mobile Bill or Electricity Bill (not older than 2 months)"),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              child: Text(
                "Office Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text(
                      'Rental agreement + NOC - Non-Objection Certificate *'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text('Electricity Bill or any of the Utility Bills.'),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.03,
                left: 15,
                right: 15,
              ),
              child: Text(
                "Residential address and virtual office address can also be used as office address",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: RoundedLoadingButton(
            width: MediaQuery.of(context).size.width,
            curve: Curves.fastOutSlowIn,
            child: Text("START NOW"),
            controller: _btnController,
            borderRadius: 4,
            onPressed: () async {
              // Navigator.pushNamed(context, 'pan-card-upload');
              Navigator.pushNamed(context, 'contactDetails');
            }),
      ),
    );
  }
}
