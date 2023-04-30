import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/db/userDB.dart';
import 'package:fyp/db/User.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fyp/app/RegisterType.dart';
import 'package:fyp/main.dart';

import 'package:http/http.dart' as http;

class OTP extends StatefulWidget {
  const OTP({Key? key}) : super(key: key);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();

  getUserByPhonenumber(phoneNumber) async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getUserByPhonenumber'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'phoneNumber': phoneNumber.toString()}),
    );

    print(response.body);

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(''),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          keyboardType: TextInputType.number,
                          controller: t1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), counterText: ''),
                          textInputAction: TextInputAction.next,
                          maxLength: 1,
                        ),
                      ),
                      Spacer(
                        flex: 1, // <-- SEE HERE
                      ),
                      new Flexible(
                        child: new TextField(
                          controller: t2,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), counterText: ''),
                          textInputAction: TextInputAction.next,
                          maxLength: 1,
                        ),
                      ),
                      Spacer(
                        flex: 1, // <-- SEE HERE
                      ),
                      new Flexible(
                        child: new TextField(
                          controller: t3,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), counterText: ''),
                          textInputAction: TextInputAction.next,
                          maxLength: 1,
                        ),
                      ),
                      Spacer(
                        flex: 1, // <-- SEE HERE
                      ),
                      new Flexible(
                        child: new TextField(
                          controller: t4,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), counterText: ''),
                          textInputAction: TextInputAction.done,
                          maxLength: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                      // width: 200, // <-- Your width
                      height: 40, // <-- Your height
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          String number=  t1.value.text.toString() +
                              t2.value.text.toString() +
                              t3.value.text.toString() +
                              t4.value.text.toString();
                          if (arguments['randomnumber'].toString() != number)
                             {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(" Entered Otp Number is not valid"),
                            ));
                          } else {
                            var num = await getUserByPhonenumber(
                                arguments['phonenumber'].toString());

                            Config.phonenumber=  arguments['phonenumber'].toString();

                            if (num == "unsuccess") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterType()),
                              );
                            } else {
                              var list = json.decode(num);

                              userDB userDb = new userDB();
                              userDb.insertUser(new User(
                                  userId: list[0], type: list[1].toString()));
                              if (list[1].toString() == 'customer') {
                                Config.customerId =
                                    int.parse(list[0].toString());
                                Navigator.pushNamed(
                                  context,
                                  '/home2',
                                  arguments: {},
                                );
                              } else if(list[1].toString() == 'vendor')  {
                                Config.vendorId = int.parse(list[0].toString());
                                Navigator.pushNamed(
                                  context,
                                  '/home',
                                  arguments: {},
                                );
                              } else if(list[1].toString() == 'driver')  {
                                Config.driverId = int.parse(list[0].toString());
                                Navigator.pushNamed(
                                  context,
                                  '/home3',
                                  arguments: {},
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Continue'),
                      ),
                    ))
              ],
            )));
  }
}
