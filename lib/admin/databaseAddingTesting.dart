import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class databaseAddingTesting extends StatefulWidget {
  _databaseAddingTesting createState() => _databaseAddingTesting();
}

class _databaseAddingTesting extends State<databaseAddingTesting> {
  final _formKey = GlobalKey<FormState>();
  final _username = new TextEditingController();
  final _useremail = new TextEditingController();
  final DBReference = FirebaseDatabase.instance.reference();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is it"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _username,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _useremail,

                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var serverUrlfinal = "https://fcm.googleapis.com/fcm/send";
                    var titleM = "New enquiry received";
                    var bodyAll = {'title' : 'thisis','body' : 'this is all'};

                    var response =
                        await http.post(Uri.parse(serverUrlfinal), body: {
                      'to':
                          'fSnuNUBiQyiKcu_gJbqCdk:APA91bH143svTO7Tn40Avv295rPtPYpqep3YcQXgfk3nnj_5CZigjP0tUJehoI9Dzn6Ormms226Q9C0RIP8c8Gjz5tGq63FVvwq-SkgT3BSDtZWwsc81pVa0c9e0kCkucrhJbQ2DY2qf',
                      'title': "title",
                          'body' : "Body content goes here"
                    }, headers: {
                      "Accept": "application/json",
                      "Authorization":
                          "key=AAAAUUmzTzc:APA91bHbzGr90h2Hpx1wAfokljehgPobk1X9OK7hg0oyfRPlqM6x7JJCOtCJ7MnEJWHeKtTzQcdcH4TkwFMzdwJWG--slZiXfW1o7_SQr6UbwJxrBs_Hddg8ZHfKXJyMDQJphg7C5R84"
                    });
                    print(response.body);

                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
