import 'package:flutter/material.dart';
import 'package:fyp/app/Register.dart';

class RegisterType extends StatefulWidget {
  const RegisterType({Key? key}) : super(key: key);

  @override
  _RegisterTypeState createState() => _RegisterTypeState();
}

class _RegisterTypeState extends State<RegisterType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(''),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: GestureDetector(
                          onTap: () => {


                          Navigator.pushNamed(
                          context,
                          '/register',
                          arguments: {'title': 'Register-Customer',
                            'name':'Enter Name','address':'Enter Address',
                            'userType':'customer','pick':'pick your image'
                          },
                          )

                      },
                          child: Card(
                              elevation: 20,
                              margin: EdgeInsets.all(20),
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Image.asset(
                                      'assets/images/registerascustomer.png')
                              )
                          )

                      )),
                  Container(
                      child: GestureDetector(
                          onTap: () =>
                          {
                            Navigator.pushNamed(
                              context,
                              '/register',
                              arguments: {'title': 'Register-Vendor',
                                'name':'Enter Shop Name','address':'Enter Address','pick':'pick shop image',
                                'userType':'vendor'
                              },
                            )
                          },
                          child: Card(
                              elevation: 20,
                              margin: EdgeInsets.all(20),
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Image.asset(
                                      'assets/images/registervendor.png')
                              )
                          )

                      )),
                  Container(
                      child: GestureDetector(
                          onTap: () =>
                          {
                            Navigator.pushNamed(
                              context,
                              '/register',
                              arguments: {'title': 'Register-Vendor',
                                'name':'Enter  Name','address':'Enter Vehicle Number','pick':'pick shop image',
                                'userType':'driver'
                              },
                            )
                          },
                          child: Card(
                              elevation: 20,
                              margin: EdgeInsets.all(20),
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Image.asset(
                                      'assets/images/registerdriver.png')
                              )
                          )

                      )),
                ])));
  }
}
