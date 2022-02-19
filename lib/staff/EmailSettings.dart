import 'package:flutter/material.dart';
class EmailSettings extends StatefulWidget{
  _EmailSettings createState() => _EmailSettings();
}
class _EmailSettings extends State<EmailSettings>{
  var currentState;
  onloading(){
    return Container(

      child: ListTile(
        leading: Icon(Icons.mail),
        title: Text("Saved Email"),
        subtitle: Text("anoopkrishnapillai1989@gmail.com"),
        trailing: Icon(Icons.edit),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    currentState = onloading();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: currentState,
    );
  }
}
