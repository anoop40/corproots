import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_extensions/string_extensions.dart';

class RegisteredUserDrawer extends StatefulWidget {
  _RegisteredUserDrawer createState() => _RegisteredUserDrawer();
}

class _RegisteredUserDrawer extends State<RegisteredUserDrawer> {
  var userName;
  late Future str;

  getSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      userName = prefs.getString('user_name').toTitleCase();
    });
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str = getSessionData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: str,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          /*
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          image: AssetImage('assets_files/my_profile.jpeg'),
                          fit: BoxFit.cover)),
                  child: Text(
                    'Welcome ${userName}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text('My Profile'),
                  trailing: Icon(Icons.verified_user),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'myProfileUser');
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('My Documents'),
                  trailing: Icon(Icons.document_scanner),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'myDocumentsUser');
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Settings'),
                  trailing: Icon(Icons.settings),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Logout'),
                  trailing: Icon(Icons.logout),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'logout');
                  },
                ),
              ],
            ),
          );
          */
          return Drawer(
            // column holds all the widgets in the drawer
            child: Column(
              children: <Widget>[
                Expanded(
                  // ListView contains a group of widgets that scroll inside the drawer
                  child: ListView(
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                                image:
                                    AssetImage('assets_files/my_profile.jpeg'),
                                fit: BoxFit.cover)),
                        child: Text(
                          'Welcome ${userName}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title: Text('Home'),
                        leading: Icon(Icons.home),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'userDashboard');
                        },
                      ),
                      ListTile(
                        title: Text('My Profile'),
                        leading: Icon(Icons.verified_user),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'myProfileUser');
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('My Documents'),
                        leading: Icon(Icons.document_scanner),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'myDocumentsUser');
                        },
                      ),
                    ],
                  ),
                ),
                // This container holds the align
                Container(
                    // This align moves the children to the bottom
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        // This container holds all the children that will be aligned
                        // on the bottom and should not scroll with the above ListView
                        child: Container(
                            child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                                leading: Icon(Icons.settings),
                                title: Text('Settings')),
                            ListTile(
                              leading: Icon(Icons.logout),
                              title: Text('Logout'),
                              onTap: () async {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                await preferences.clear();
                                Navigator.pushNamed(context, 'mobileVarification');
                              },
                            ),
                          ],
                        ))))
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
