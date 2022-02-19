import 'package:corproots/registered_users/profile/editPersonalProfile.dart';
import 'package:corproots/registered_users/profile/existingValues.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';



class My_personal_profile_contents extends StatefulWidget {
  _My_personal_profile_contents createState() =>
      _My_personal_profile_contents();
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class _My_personal_profile_contents
    extends State<My_personal_profile_contents> {
var _currentState;
bool editVindowStat = false;
  @override
  void initState() {
    super.initState();
 _currentState = existingValues();

  }


setFloatingActionButton(){
    if(editVindowStat == false) {
      return FloatingActionButton.extended(
        onPressed: () {
          this.setState(() {
            _currentState = editPersonalProfile();
            editVindowStat = true;
          });
        },
        label: const Text('EDIT'),
        icon: const Icon(Icons.edit),
      );
    }
}


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topLeft,
              image: AssetImage("assets_files/background2.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: _currentState,
        ),
      ),
      floatingActionButton: setFloatingActionButton(),
    );
  }
}
