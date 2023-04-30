import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:http/http.dart' as http;

class OnTrackDelivery extends StatefulWidget {
  const OnTrackDelivery({Key? key}) : super(key: key);

  @override
  OnTrackDeliveryState createState() {
    return OnTrackDeliveryState();
  }
}

class OnTrackDeliveryState extends State<OnTrackDelivery> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();
    });
  }
  Widget FinishDelivery(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do You Want Finish this Delivery'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await updateOnTrackDeliverStatus("Finished");

            for (int i = 0; i < getNormalOrders.length; i++)
            {
              await updateOrderStatus(getNormalOrders[i], "Delivered");
            }

            for (int i = 0; i < getCustomizeOrders.length; i++)
            {
              await updateCustomizeOrderStatus(getCustomizeOrders[i], "Delivered");
            }

            Navigator.pushNamed(
              context,
              '/home3',
              arguments: {},
            );
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Yes'),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('No'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

  List<String> getNormalOrders = [];
  List<String> getCustomizeOrders = [];

  _loadDatas() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getPeticularDeliveryItem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'deliverId': Config.getPerticularDeliverId.toString()
      }),
    );

    setState(() {
      var list = (jsonDecode(response2.body) as List);

      getNormalOrders = list[0][3].toString().split(",");
      getNormalOrders.removeLast();

      getCustomizeOrders = list[0][4].toString().split(",");
      getCustomizeOrders.removeLast();
    });
  }

  updateOnTrackDeliverStatus(status) async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/updateDeliveryItem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'deliverId': Config.getPerticularDeliverId.toString(),
        'status': status
      }),
    );
  }

  updateOrderStatus(orderId, status) async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/updateOrders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'orderId': orderId.toString(), 'status': status}),
    );
  }

  updateCustomizeOrderStatus(orderId, status) async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/updateCustomizeOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customizeOrderId': orderId.toString(),
        'status': status
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('OnTrack Delivery'),
          // automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.asset('assets/images/map.png'),
                ),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                        // width: 200, // <-- Your width
                        height: 40, // <-- Your height
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    FinishDelivery(context),
                              );
                            },
                            child: Text("Finish")))),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                        // width: 200, // <-- Your width
                        height: 40, // <-- Your height
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) =>
                              //       CancelCustomizeOrder(context),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: Text("Report Damage"))))
              ],
            )));
  }
}
