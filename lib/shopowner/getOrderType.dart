import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/shopowner/getCustermizeProductOrders.dart';
import 'package:fyp/shopowner/Orders.dart';




class GetOrderType extends StatefulWidget {
  const GetOrderType({Key? key}) : super(key: key);

  @override
  GetOrderTypeState createState() {
    return GetOrderTypeState();
  }
}

class GetOrderTypeState extends State<GetOrderType> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        // automaticallyImplyLeading: false,
      ),
      body :_isLoading
          ? CircularProgressIndicator()
          : CustomScrollView(slivers: [
        SliverToBoxAdapter(
            child: Padding(
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

                          // Config.orderStatus="Added";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetCustermizeProductOrders()),
                          );

                        },
                        child: Text("Customize Product Orders"))))),

        SliverToBoxAdapter(
            child: Padding(
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
                          // Config.orderStatus="Ongoing";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const Orders()),
                          );


                        },
                        child: Text("Normal  Orders"))))),

      ]),
    );
  }
}
