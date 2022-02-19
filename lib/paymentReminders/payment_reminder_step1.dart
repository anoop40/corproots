import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class payment_reminder_step1 extends StatefulWidget {
  _payment_reminder_step1 createState() => _payment_reminder_step1();
}

enum SingingCharacter { monthly_reminder, yearly_reminder }

class _payment_reminder_step1 extends State<payment_reminder_step1> {
  SingingCharacter? _character = SingingCharacter.monthly_reminder;
  var selectedDate = "Not found";
  final _amount = new TextEditingController();
  final _description = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  late var _selectedDateOnly;
  late var _selectedMonthOnly;
  late var _selectedYearOnly;
  final _DBReference = FirebaseDatabase.instance.reference();
  FirebaseFirestore _firestoreRefference = FirebaseFirestore.instance;

  getDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      print(DateFormat("dd-MM-yyyy").format(picked));
      setState(() {
        selectedDate = DateFormat("dd-MM-yyyy").format(picked);
        _selectedDateOnly = DateFormat("dd").format(picked);
        _selectedMonthOnly = DateFormat("MM").format(picked);
        _selectedYearOnly = DateFormat("yyyy").format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Payment Reminder Cycle"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image(image: AssetImage('assets_files/raminder1.png')),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Selected Date"),
              subtitle: Text(selectedDate.toString()),
              trailing: Icon(
                Icons.refresh_sharp,
              ),
              onTap: () {
                getDate();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.00, left: 0.00),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _amount,
                  // The validator receives the text that the user has entered.
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: 0.00,
                      bottom: 0.00,
                      left: 13.00,
                    ),
                    border: OutlineInputBorder(),
                    labelText: "Amount",
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
            Padding(
              padding: EdgeInsets.only(top: 15.00, left: 0.00),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: _description,
                  // The validator receives the text that the user has entered.
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: 0.00,
                      bottom: 0.00,
                      left: 13.00,
                    ),
                    border: OutlineInputBorder(),
                    labelText: "Description",
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
            ListTile(
              title: const Text('Monthly Reminder'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.monthly_reminder,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Yearly Reminder'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.yearly_reminder,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: RoundedLoadingButton(
          color: Colors.blue[800],
          borderRadius: 0.00,
          width: MediaQuery.of(context).size.width,
          child: Text('UPDATE NOW', style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            var serverUrlfinal =
                "${SettingsAllFle.finalURl}/get-user-device_id";

            var response = await http.post(Uri.parse(serverUrlfinal),
                body: {'userId': prefs.getString('client_id')},
                headers: {"Accept": "application/json"});
            print("Device Id is : " + response.body.toString());
            var received = json.decode(response.body);
            var device_id = received[0]['device_id'];
            var refference = DateTime.now().millisecondsSinceEpoch;
            //selectedDate.toString();
            print("Selected value  : " + _character.toString());
            CollectionReference reminders =
                _firestoreRefference.collection('reminders');
print("Selcected date is : " + selectedDate.toString());
            if (selectedDate.toString() == "Not found") {
              _btnController.reset();
              final snackBar = SnackBar(
                content: Text('Please select date'),
                backgroundColor: Colors.red,
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            }
            if (_character.toString() == "SingingCharacter.monthly_reminder") {
              reminders
                  .doc(prefs.getString('client_id'))
                  .collection('monthly')
                  .doc()
                  .set({
                    'day_to_remind_on_month': _selectedDateOnly.toString(),
                    'amount': _amount.text,
                    'description': _description.text,
                    'device_id': device_id.toString()
                  })
                  .then((value) => print('data added'))
                  .catchError((error) => print("Failed on adding"));
            } else {
              reminders
                  .doc(prefs.getString('client_id'))
                  .collection('yearly')
                  .doc()
                  .set({
                    'day_to_remind': _selectedDateOnly.toString(),
                    'month_to_remind': _selectedMonthOnly.toString(),
                    'amount': _amount.text,
                    'description': _description.text,
                    'device_id': device_id.toString()
                  })
                  .then((value) => print('data added'))
                  .catchError((error) => print("Failed on adding"));
            }

            _btnController.reset();
            final snackBar = SnackBar(
              backgroundColor: Colors.green[800],
              content: Row(
                children: <Widget>[
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  Text(' Payment reminder set successfully'),
                ],
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}
