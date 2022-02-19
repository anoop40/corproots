import 'package:flutter/material.dart';

class web_admin_dashboard extends StatefulWidget {
  _web_admin_dashboard createState() => _web_admin_dashboard();
}

class _web_admin_dashboard extends State<web_admin_dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Welcome Admin"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 15.00,
                      left: MediaQuery.of(context).size.height * 0.06),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, 'our_services');
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(15.00),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Image(
                                  image: AssetImage(
                                      'assets_files/update_services.png')),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.00),
                            child: Text("SERVICES"),
                          )
                        ],
                      ),

                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
