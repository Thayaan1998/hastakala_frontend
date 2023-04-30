import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/customer/products.dart';
import 'package:fyp/db/User.dart';
import 'package:fyp/db/userDB.dart';
import 'package:fyp/drivers/home3.dart';
import 'package:fyp/shopowner/viewitem.dart';
import 'package:fyp/shopowner/Orders.dart';

import 'package:fyp/app/Login1.dart';
import 'package:fyp/app/Register.dart';
import 'package:fyp/app/OTP.dart';
import 'package:fyp/shopowner/Home.dart';
import 'package:fyp/customer/home2.dart';
import 'package:fyp/customer/getItemForOrder.dart';
import 'package:fyp/customer/getPeticualarCustomizeShop.dart';



import 'dart:async';
import 'dart:io';


Future<void> main()  async {

  userDB userDb=new userDB();
  List<User> user=await userDb.getUser();
  if(user.length!=0){

    if(user[0].type=='customer'){
      Config.customerId=user[0].userId;
      runApp(MaterialApp(
        title: 'Passing Data',
        theme: ThemeData(
          primaryColor: Color(0xFF55C1EF),
          secondaryHeaderColor: Colors.red
        ),
        initialRoute: '/home2',
        routes: {
          '/': (context) => Login1(),
          '/register': (context) => Register(),
          '/otp': (context) => OTP(),
          '/home': (context) => Home(),
          '/home2': (context) => Home2(),
          '/home3': (context) => Home3(),
          '/getItemForOrder': (context) => GetItemForOrder(),
          '/getPeticualarCustomizeShop': (context) => GetPeticualarCustomizeShop(),
        },
      ));
    }else if(user[0].type=='vendor'){
      Config.vendorId=user[0].userId;
      runApp(MaterialApp(
        title: 'Passing Data',
        theme: ThemeData(
          primaryColor: Color(0xFF55C1EF),
          secondaryHeaderColor: Colors.red
        ),
        initialRoute: '/home',
        routes: {
          '/': (context) => Login1(),
          '/register': (context) => Register(),
          '/otp': (context) => OTP(),
          '/home': (context) => Home(),
          '/home2': (context) => Home2(),
          '/home3': (context) => Home3(),
          '/getItemForOrder': (context) => GetItemForOrder(),
          '/getPeticualarCustomizeShop': (context) => GetPeticualarCustomizeShop(),

        },
      ));
    }
    else if(user[0].type=='driver'){
      Config.driverId=user[0].userId;
      runApp(MaterialApp(
        title: 'Passing Data',
        theme: ThemeData(
            primaryColor: Color(0xFF55C1EF),
            secondaryHeaderColor: Colors.red
        ),
        initialRoute: '/home3',
        routes: {
          '/': (context) => Login1(),
          '/register': (context) => Register(),
          '/otp': (context) => OTP(),
          '/home': (context) => Home(),
          '/home2': (context) => Home2(),
          '/home3': (context) => Home3(),
          '/getItemForOrder': (context) => GetItemForOrder(),
          '/getPeticualarCustomizeShop': (context) => GetPeticualarCustomizeShop(),

        },
      ));
    }

  }else{
    runApp(MaterialApp(
      title: 'Passing Data',
      theme: ThemeData(
          primaryColor: Color(0xFF55C1EF),
          secondaryHeaderColor: Colors.red
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login1(),
        '/register': (context) => Register(),
        '/otp': (context) => OTP(),
        '/home': (context) => Home(),
        '/home2': (context) => Home2(),
        '/getItemForOrder': (context) => GetItemForOrder(),
        '/getPeticualarCustomizeShop': (context) => GetPeticualarCustomizeShop(),

      },
    ));
  }


}



