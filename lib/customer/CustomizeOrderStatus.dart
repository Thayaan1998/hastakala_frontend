import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/customer/getCustomizeOrders.dart';



class CustomizeOrderStatus extends StatefulWidget {
  const CustomizeOrderStatus({Key? key}) : super(key: key);

  @override
  CustomizeOrderStatusState createState() {
    return CustomizeOrderStatusState();
  }
}

class CustomizeOrderStatusState extends State<CustomizeOrderStatus> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Products'),
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

                          Config.orderStatus="Requested";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetCustomizeOrders()),
                          );

                        },
                        child: Text("Requested Order "))))),
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
                          Config.orderStatus="Accepted";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetCustomizeOrders()),
                          );

                        },
                        child: Text("Accepted Order "))))),
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
                                const GetCustomizeOrders()),
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
                                const GetCustomizeOrders()),
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
                          Config.orderStatus="Resend Image";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetCustomizeOrders()),
                          );
                        },
                        child: Text("Resend Orders"))))),
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
                                const GetCustomizeOrders()),
                          );
                        },
                        child: Text("Rejected Orders"))))),
      ]),
    );
  }
}
