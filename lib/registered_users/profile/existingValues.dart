import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:string_extensions/string_extensions.dart';
import '../CameraFile.dart';
class existingValues extends StatefulWidget {
  _existingValues createState() => _existingValues();
}

class _existingValues extends State<existingValues> {
  var _username;
  var _email;
  var _mobileNumber;
  var _registered_on;
  var _userType;
  var _imageUploadStat;
  var _profile_img;



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
    getSessionData();
    setProfileImage();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.22),
          child: _profile_img,
        ),

        Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            "PERSONAL PROFILE",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 30, top: 20, bottom: 10, right: 10),
              child: Text("Account Type : "),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(_userType),
            )
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 10),
              child: Text("Name : "),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(_username),
            )
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, right: 10),
              child: Text("Email  : "),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(_email),
            )
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, bottom: 10, right: 10),
              child: Text("Phone : "),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(_mobileNumber),
            )
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 30, bottom: 30, top: 10, right: 10),
              child: Text("Account Created On : "),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 30,
              ),
              child: Text(_registered_on),
            ),
          ],
        ),

      ],
    );
  }
}
