import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fyp/db/User.dart';
import 'package:fyp/db/userDB.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fyp/app/OTP.dart';
import 'package:http/http.dart' as http;

class Login1 extends StatefulWidget {
  const Login1({Key? key}) : super(key: key);

  @override
  _RegisterWithPhoneNumberState createState() =>
      _RegisterWithPhoneNumberState();
}

class _RegisterWithPhoneNumberState extends State<Login1> {
  String phonenumber='';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _loadDatas();
    });
  }

  num random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  String randomnumber='';
  _getRandomNumberForOTP() async {
     randomnumber=random(1000, 10000).toString();
     print(randomnumber);
    // final response = await http.get(
    //   Uri.parse('https://www.textit.biz/sendmsg?id=94778148352&pw=9690&to=0710850660&text='+randomnumber),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //
    // );
    // return response.body;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.asset('assets/images/app.png'),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      //print(number.phoneNumber);
                      phonenumber=number.phoneNumber.toString();
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        trailingSpace: false),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    formatInput: false,
                    maxLength: 9,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    cursorColor: Colors.black,
                    inputDecoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phonenumber',
                      hintText: 'Enter Your Phonenumber',
                    ),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                      // width: 200, // <-- Your width
                      height: 40, // <-- Your height
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()  async{
                          if(phonenumber.length<12){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  " Not Valid Phonenumber"),
                            ));
                          }else{

                            await _getRandomNumberForOTP();


                            Navigator.pushNamed(
                              context,
                              '/otp',
                              arguments: {'phonenumber': phonenumber,'randomnumber':randomnumber},
                            );
                          }

                        },
                        child: const Text('Continue'),
                      ),
                    ))
              ],
            )));
  }
}
