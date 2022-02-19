import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';

class pendingTasks extends StatefulWidget {
  _pendingTasks createState() => _pendingTasks();
}

class _pendingTasks extends State<pendingTasks> {
  late List myTaks;
  late Future str;
  DateTime currentDate = DateTime.now();
  var quotation_id;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal = "${SettingsAllFle.finalURl}/list-all-my-pending-tasks";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "userId": prefs.getString('userId'),
    });
    //print(response.body);
    this.setState(() {
      myTaks = json.decode(response.body) as List<dynamic>;
    });

    return true;
  }

  Future updateNextRminderDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 12),
            child: Text("Loading..."),
          ),
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

    var serverUrlfinal =
        "${SettingsAllFle.finalURl}/update-next-followup-date-for-quotation-table";

    var response = await http.post(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json"
    }, body: {
      "userId": prefs.getString('userId'),
      "quotationId": quotation_id,
      "next_review_date": currentDate.toString(),
    });
    //print("From server : " + response.body);
    var resp = json.decode(response.body);
    if (resp[0]['status'] == "success") {
      //Navigator.of(context).pop();
      final snackBar = SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 15.00,

              ),
              child: Text('Successfully updated !'),
            )
          ],
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Timer(Duration(seconds: 1), () {
        Navigator.pushNamed(context, 'userDashboard');
      });


// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Pending Jobs"),
      ),
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print("inside hasdata");
            return SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: getData,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: myTaks.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> dataFinal = myTaks[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.userCheck,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    StringUtils.capitalize(
                                        dataFinal['customer_name']),
                                  ),
                                )
                              ],
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        size: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.00),
                                        child: Text(
                                          dataFinal['send_date_and_time'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 7),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.close_sharp,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 1.00),
                                        child: Text(
                                          "Reminder",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                quotation_id = dataFinal['quotation_id'];
                              });
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.00, bottom: 10.00),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.94,
                                            child: const Text(
                                              'SET REMINDER',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 0.00,
                                            left: 7.00,
                                            bottom: 30.00,
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              InputChip(
                                                onPressed: () async {
                                                  //Navigator.of(context).pop();
                                                  /* start here */
                                                  Navigator.of(context).pop();
                                                  DateTime selectedTime;
                                                  final DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              currentDate,
                                                          firstDate:
                                                              DateTime(2015),
                                                          lastDate:
                                                              DateTime(2050));
                                                  if (pickedDate != null &&
                                                      pickedDate !=
                                                          currentDate) {
                                                    print(
                                                        "Selected date is : " +
                                                            pickedDate
                                                                .toString());
                                                    setState(() {
                                                      currentDate = pickedDate;
                                                    });
                                                    await updateNextRminderDate();
                                                  }
                                                  /* ends here */
                                                },
                                                avatar: CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .calendarPlus,
                                                    size: 13,
                                                  ),
                                                ),
                                                label: const Text(
                                                  'Set next reminder date',
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
