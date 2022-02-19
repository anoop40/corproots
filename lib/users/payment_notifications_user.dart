
import 'package:corproots/users/notPaidInvoices.dart';
import 'package:flutter/material.dart';

import 'PaidInvoices.dart';
import 'monthlyYearlyPayments.dart';


class payment_notifications_user extends StatefulWidget {
  _notifications_user createState() => _notifications_user();
}

class _notifications_user extends State<payment_notifications_user> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    paidInvoices(),
    notPaidInvoices(),
    monthlyYearlyPayments(),

  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Payment Notifications"),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'PAID',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close_rounded),
            label: 'NOT PAID',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh_sharp),
            label: 'MONTHLY / YEARLY',
            backgroundColor: Colors.red,
          ),


        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
