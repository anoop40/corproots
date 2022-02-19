import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:camera/camera.dart';

import '../CameraFile.dart';
import 'package:string_extensions/string_extensions.dart';

class editPersonalProfile extends StatefulWidget {
  _editPersonalProfile createState() => _editPersonalProfile();
}

class _editPersonalProfile extends State<editPersonalProfile> {
  var _username;
  var _email;
  var _mobileNumber;
  var _registered_on;
  var _userType;
  var _imageUploadStat;
  var _profile_img;

  var _currentState;
  late Future str;

  Future getSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('profilePic')) {
      this.setState(() {
        _imageUploadStat = prefs.getString('profilePic');
      });
    }
    this.setState(() {
      _username = prefs.getString('user_name').toTitleCase();
      _email = prefs.getString('email');
      _mobileNumber = prefs.getString('mobile_number');
      _registered_on = prefs.getString('registered_on');
      _userType = prefs.getString('userType');
    });
    return true;
  }

  setProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('profilePic')) {
      File filePat1 = File(prefs.getString('profilePic').toString());
      this.setState(() {
        _profile_img = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(filePat1));
      });
    } else {
      this.setState(() {
        _profile_img = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets_files/my_profile.jpeg',
              fit: BoxFit.cover,
            ));
      });
    }
  }

  setProfileImageCustom() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets_files/unnamed.png',
        fit: BoxFit.cover,
      ),
    );
  }

  alertShow() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('IMAGE SOURCE'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('From where you want to load image ?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () async {
                WidgetsFlutterBinding.ensureInitialized();
                final cameras = await availableCameras();
                final firstCamera = cameras.first;

              },
              icon: Icon(Icons.camera_alt_outlined, size: 18),
              label: Text("Use my camera"),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await alertShow();
              },
              icon: Icon(Icons.upload_file_sharp, size: 18),
              label: Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    str = getSessionData();
    setProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: str,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.22),
                child: _profile_img,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await alertShow();
                  },
                  icon: Icon(Icons.camera_alt_outlined, size: 18),
                  label: Text("UPDATE PROFILE PICTURE"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "PERSONAL PROFILE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(top: 15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    labelText: 'Your Name',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(top: 15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // await alertShow();
                  },
                  child: Text("UPDATE NOW"),
                ),
              )
            ],
          );
        } else {
          return Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
