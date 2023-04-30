import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/shopowner/sendOrderToDriver.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/object/Driver.dart';

class Drivers extends StatefulWidget {
  const Drivers({Key? key}) : super(key: key);

  @override
  DriversState createState() {
    return DriversState();
  }
}

class DriversState extends State<Drivers> {
  List<Driver>? drivers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();
    });
  }

  _loadDatas() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getDrivers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    // print(response2.body);
    setState(() {
      drivers = (jsonDecode(response2.body) as List)
          .map((e) => Driver.fromList(e))
          .cast<Driver>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Drivers'),
          automaticallyImplyLeading: false,
        ),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: SizedBox(
            // height: 100.0,
            child: ListView.builder(
                itemCount: drivers!.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return new GestureDetector(
                      onTap: () => {
                            Config.getPerticularDriverId =
                                drivers![index].userId,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SendOrderToDriver()),
                            )
                          },
                      child: Container(
                          child: Card(
                              elevation: 20,
                              margin: EdgeInsets.all(20),
                              child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          //apply padding to all four sides
                                          child: Text(drivers![index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          //apply padding to all four sides
                                          child: Text(
                                              "Phone Number: " +
                                                  drivers![index]
                                                      .phoneNumber
                                                      .toString(),
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          //apply padding to all four sides
                                          child: Text(
                                              "Vehicle Number:" +
                                                  drivers![index]
                                                      .address
                                                      .toString(),
                                              textAlign: TextAlign.left),
                                        )
                                      ])))));
                }),
          ))
        ]));
  }
}
