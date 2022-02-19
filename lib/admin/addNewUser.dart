import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddNewUser extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<AddNewUser> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  late String dropdownValue = "Select Department";

  // late String dropdownValue;
  late String _userType = 'Select user type';

  //late String dropdownValue;
  final _depatmentName = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  late List departments;
  late Future str;

  final _username = new TextEditingController();
  final _mobileNumber = new TextEditingController();
  final _email = new TextEditingController();
  CollectionReference _departments =
      FirebaseFirestore.instance.collection('departments');
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
      //print("Contact list + " + _contacts.toString());
    }
  }

  getDepartmentList() async {
    /*
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-depts";

    var response = await http.post(Uri.parse(serverUrlfinal),
        headers: {"Accept": "application/json"});
    print(response.body);
    var resBody = json.decode(response.body) as List<dynamic>;
    this.setState(() {
      departments = resBody;
    });
    return "true";
    */
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    str = getDepartmentList();
  }

  void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      this.dropdownValue = newValueSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[800],
        title: Text(
          "New user",
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: RoundedLoadingButton(
          width: MediaQuery.of(context).size.width,
          color: Colors.blue[800],
          borderRadius: 0.00,
          child: Text('CREATE NOW', style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: () async {
            final QuerySnapshot result = await _users
                .where('mobile_number', isEqualTo: _mobileNumber.text)
                .limit(1)
                .get();
            final List<DocumentSnapshot> documents = result.docs;
            if (documents.length == 0) {
              _users.add({
                'username': _username.text,
                'mobile_number': _mobileNumber.text,
                'user_type': _userType,
                'department': dropdownValue,
                'email': _email.text,
              }).then((value) {
                _btnController.reset();
                Fluttertoast.showToast(
                    msg: "User successfully added",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 4,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }).catchError((error) => print("Failed to add user: $error"));
            } else {
              _btnController.reset();
              Fluttertoast.showToast(
                  msg: "User already found in database",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 4,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }

            /*
            var serverUrlfinal = "${SettingsAllFle.finalURl}/add-new-user";

            var response = await http.post(Uri.parse(serverUrlfinal), body: {
              'username': _username.text,
              'email': _email.text,
              'mobile_number': _mobileNumber.text,
              'userType': _userType,
              'department_id': dropdownValue
            }, headers: {
              "Accept": "application/json"
            });
            //print(response.body);
            var savingStatus = json.decode(response.body);
            if (savingStatus[0]['status'] == "success") {
              Navigator.of(context).pop();
              _btnController.reset();
              final snackBar = SnackBar(
                backgroundColor: Colors.green[800],
                content: Row(
                  children: <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    Text(' Successfully created user'),
                  ],
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            */
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          //await pickContact();
        },
        label: const Text('Phone Book'),
        icon: const Icon(Icons.contact_phone),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(bottom: 30.00),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets_files/add-new-user.png')),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      children: <Widget>[
                        /*
                        FutureBuilder(
                            future: str,
                            builder: (context, snapshot) {
                              //print("Snapshot : " + snapshot.toString());
                              if (snapshot.hasData) {
                                //print("Department is : " +departments.toString());
                                return DropdownButton<String>(
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline:
                                      Container(height: 2, color: Colors.black),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  value: dropdownValue,
                                  items :
                                    /*
                                  items: departments.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(
                                          item['dept_name'].toString()),
                                      value: item['dept_id'].toString(),
                                    );
                                  }).toList(),
                                  */
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        */

                        StreamBuilder(
                          stream: _departments.snapshots(),
                          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.data != null) {
                              return DropdownButton<String>(
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline:
                                    Container(height: 2, color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                value: dropdownValue,
                                items: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  //print("Docment are : " + document.toString());
                                  return DropdownMenuItem<String>(
                                    value: document['department_name'],
                                    child: Text(document['department_name']),
                                  );
                                }).toList(),
                              );
                            } else {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.4),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: 'Create new department',
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.00,
                                              bottom: 15.00,
                                              left: 10.00),
                                          child: Text(
                                            "ADD NEW DEPARTMENT",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.blue[800]),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.00),
                                        child: Form(
                                          key: _formKey1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 10.00,
                                                ),
                                                child: Container(
                                                  child: TextFormField(
                                                    controller: _depatmentName,
                                                    // The validator receives the text that the user has entered.
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter some text';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            "Department Name"),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.96,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 7.00, top: 7.00),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              'listDepartments');
                                                        },
                                                        child:
                                                            Text("DEPARTMENTS"),
                                                      ),
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'UPDATE'),

                                                        onPressed: () async {
                                                          AlertDialog alert =
                                                              AlertDialog(
                                                            content: new Row(
                                                              children: [
                                                                CircularProgressIndicator(),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              7),
                                                                  child: Text(
                                                                      " Loading..."),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                          showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return alert;
                                                            },
                                                          );
                                                          _departments.add({
                                                            'department_name':
                                                                _depatmentName
                                                                    .text,
                                                          }).then((value) {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            final snackBar =
                                                                SnackBar(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              content: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        right:
                                                                            8.00),
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_circle_outline,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "Department successfully updated")
                                                                ],
                                                              ),
                                                            );

                                                            // Find the ScaffoldMessenger in the widget tree
                                                            // and use it to show a SnackBar.
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar);
                                                            getDepartmentList();
                                                          }).catchError(
                                                              (error) => print(
                                                                  "Failed to add user: $error"));
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Colors.blue[800],
                                                        ),
                                                        // Navigator.pop(context),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded),
                          tooltip: 'Create new department',
                          onPressed: () {
                            getDepartmentList();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.00),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      children: <Widget>[
                        DropdownButton<String>(
                          value: _userType,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _userType = newValue!;
                            });
                          },
                          items: <String>[
                            'Select user type',
                            'staff',
                            'agency',
                            'admin',
                            'normal_user'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.00),
                    child: TextFormField(
                      controller: _username,
                      // The validator receives the text that the user has entered.
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 0.00,
                          bottom: 0.00,
                          left: 13.00,
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.00),
                    child: TextFormField(
                      controller: _mobileNumber,
                      maxLength: 10,
                      // The validator receives the text that the user has entered.
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 0.00,
                          bottom: 0.00,
                          left: 13.00,
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Mobile Number",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.00),
                    child: TextFormField(
                      controller: _email,
                      // The validator receives the text that the user has entered.
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 0.00,
                          bottom: 0.00,
                          left: 13.00,
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Email",
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
    );
  }
}
