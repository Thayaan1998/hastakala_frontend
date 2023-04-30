import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/customer/getNormalOrders.dart';



class NormalOrderStatus extends StatefulWidget {
  const NormalOrderStatus({Key? key}) : super(key: key);

  @override
  NormalOrderStatusState createState() {
    return NormalOrderStatusState();
  }
}

class NormalOrderStatusState extends State<NormalOrderStatus> {
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

                          Config.orderStatus="Added";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetNormalOrders()),
                          );

                        },
                        child: Text("Added Orders "))))),

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
                          Config.orderStatus="Ongoing";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetNormalOrders()),
                          );


                        },
                        child: Text("Ongoing Orders"))))),


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

                          Config.orderStatus="Delivered";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetNormalOrders()),
                          );

                        },
                        child: Text("Delivered Orders"))))),

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
                          Config.orderStatus="Rejected";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetNormalOrders()),
                          );
                        },
                        child: Text("Rejected Orders"))))),
      ]),
    );
  }
}
