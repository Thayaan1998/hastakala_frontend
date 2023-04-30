import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/drivers/deliveryItems.dart';
import 'package:fyp/drivers/acceptedRequests.dart';
import 'package:fyp/drivers/accounts3.dart';



import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;

class Home3 extends StatefulWidget {
  const Home3({super.key});

  @override
  State<Home3> createState() => _MyStatefulWidgetState();
}



class _MyStatefulWidgetState extends State<Home3> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    DeliveryItems(),
    AcceptedRequests(),
    Accounts3()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _loadDatas();
  //   });
  // }
  //
  // String cartCount='0';
  // _loadDatas() async {
  //
  //   var response2 = await http.post(
  //     Uri.parse(Config.mainUrl + '/getCountCart'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body:
  //     jsonEncode(<String, String>{'userId': Config.customerId.toString()}),
  //   );
  //   setState(() {
  //     var list = (jsonDecode(response2.body) as List);
  //
  //     if(list[0][0]>0){
  //       setState(() {
  //         cartCount=list[0][0].toString();
  //       });
  //     }
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:  BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental,size: 30),
            label: 'Delivery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,size: 30),
            label: 'user',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        backgroundColor:Colors.white,
        unselectedItemColor: Colors.grey,

        onTap: _onItemTapped,

      ),
    );
  }
}