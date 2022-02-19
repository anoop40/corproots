import 'dart:ui';

import 'package:corproots/registered_users/webViewLoad.dart';
import 'package:corproots/staff/filesUploaded/documentList.dart';
import 'package:corproots/staff/filesUploaded/dropDownButton.dart';
import 'package:corproots/staff/filesUploaded/requestsSendToClientToUploadDocs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settingsAllFle.dart';
import 'cameraFileForAlertBox.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';

class FilesUploadedByCilent extends StatefulWidget {
  _FilesUploadedByCilent createState() => _FilesUploadedByCilent();
}

class _FilesUploadedByCilent extends State<FilesUploadedByCilent> {
  late File filePat1;
  final _formKey = GlobalKey<FormState>();

  var userIdFoun;
  var _customeMessage = TextEditingController();
  int _selectedIndex = 0;
  late List myDocs;
  late Future str;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      DocumentList(),
      RequestsSendToClientToUploadDocs(),
      //Admin_dash(),
    ];
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            // context and builder are
            // required properties in this widget
            context: context,
            builder: (BuildContext context) {
              // we set up a container inside which
              // we create center column and display text
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: DropdownButtonClass(),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Uploaded documents"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Documents Uploaded',
          ),
          BottomNavigationBarItem(
            label: 'Requests',
            icon: Icon(Icons.alarm),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
