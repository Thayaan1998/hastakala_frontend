import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/customer/getCustomizeOrders.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/drivers/getNormalOrder.dart';
import 'package:fyp/drivers/getCustomizeOrder.dart';

class GetPerticularDeliveryItem extends StatefulWidget {
  const GetPerticularDeliveryItem({Key? key}) : super(key: key);

  @override
  GetPerticularDeliveryItemState createState() {
    return GetPerticularDeliveryItemState();
  }
}

class GetPerticularDeliveryItemState extends State<GetPerticularDeliveryItem> {
  List<String> getNormalOrders = [];
  List<String> getCustomizeOrders = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();
    });
  }

  bool _isLoading = false;
  String name = '';
  String phonenumber = '';
  String address = '';
  String imageurl = '';
  String vendorId = '';
  String deliveryId = '';
  String date = '';
  String deliveryCost = '';

  _loadDatas() async {
    setState(() {
      _isLoading = true;
    });
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
      _isLoading = false;

      var list = (jsonDecode(response2.body) as List);
      vendorId = list[0][2].toString();
      deliveryId = "Delivery Id : " + list[0][0].toString();
      date = list[0][5].toString() +
          "/" +
          list[0][6].toString() +
          "/" +
          list[0][7].toString();
      deliveryCost = list[0][8].toString() + " Rs";

      getNormalOrders = list[0][3].toString().split(",");
      getNormalOrders.removeLast();

      getCustomizeOrders = list[0][4].toString().split(",");
      getCustomizeOrders.removeLast();
    });
    await loadUser();
  }

  loadUser() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getUserDetailsByUserId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'userId': vendorId}),
    );
    setState(() {
      var list = (jsonDecode(response2.body) as List);
      name = list[1];
      phonenumber = list[2];
      address = list[3];
      imageurl = list[5];
    });
  }

  Widget AcceptOrder(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do You Want Accept this Delivery'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await updateDeliverStatus("Accepted");
            // await _loadDatas();

            // setState(() {
            //   Config.orderStatus = 'Ongoing';
            // });
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

  Widget CancelCustomizeOrder(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do You Want Reject this Delivery'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await updateDeliverStatus("Rejected");
            // await loadOrderDetails();
            // await loadUser();
            // setState(() {
            //   Config.orderStatus = 'Rejected';
            // });
            Navigator.pushNamed(
              context,
              '/home3',
              arguments: {},
            );

            // await updateCustomizePrice(price);
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

  updateDeliverStatus(status) async {
    setState(() {
      _isLoading = true;
    });
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Item'),
        // automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : CustomScrollView(slivers: [
              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Vendor Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          )))),
              SliverToBoxAdapter(
                  child: SizedBox(
                      // height: 100.0,
                      child: Container(
                          child: Card(
                              elevation: 20,
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(children: <Widget>[
                                    imageurl == ''
                                        ? Container()
                                        : Container(
                                            child: CircleAvatar(
                                            radius: 70,
                                            child: ClipOval(
                                              child: Image.network(
                                                Config.mainUrl +
                                                    "/getFile?path=" +
                                                    imageurl,
                                                width: 500,
                                                height: 500,
                                              ),
                                            ),
                                          )),
                                    Container(
                                        // color: Colors.blue,
                                        //   width: 200,
                                        //   height: 150,

                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            //apply padding to all four sides
                                            child: Text(name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                textAlign: TextAlign.left),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            //apply padding to all four sides
                                            child: Text(phonenumber,
                                                textAlign: TextAlign.left),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            //apply padding to all four sides
                                            child: Text(address,
                                                textAlign: TextAlign.left),
                                          ),
                                        ]))
                                  ])))))),
              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Delivery Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          )))),
              SliverToBoxAdapter(
                  child: SizedBox(
                      // height: 100.0,
                      child: Container(
                          child: Card(
                              elevation: 20,
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          //apply padding to all four sides
                                          child: Text(deliveryId,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          //apply padding to all four sides
                                          child: Text(date,
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          //apply padding to all four sides
                                          child: Text(
                                              "Delivery Cost : " + deliveryCost,
                                              textAlign: TextAlign.left),
                                        ),
                                      ])))))),
        SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset('assets/images/map.png'),
            )),
              SliverToBoxAdapter(
                  child: Padding(
                padding: EdgeInsets.all(20),
                //apply padding to all four sides
                child: Text("Normal Orders",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.left),
              )),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                    itemCount: getNormalOrders!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return new GestureDetector(
                          onTap: () => {
                                Config.orderId = getNormalOrders[index],
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GetNormalOrder()),
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
                                              padding: EdgeInsets.all(5),
                                              //apply padding to all four sides
                                              child: Text(
                                                  "Order Id : " +
                                                      getNormalOrders[index],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.left),
                                            ),
                                          ])))));
                    }),
              )),

              SliverToBoxAdapter(
                  child: Padding(
                padding: EdgeInsets.all(20),
                //apply padding to all four sides
                child: Text("Customize Orders",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.left),
              )),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                    itemCount: getCustomizeOrders!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return new GestureDetector(
                          onTap: () => {
                                Config.orderId = getCustomizeOrders[index],
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GetCustomizeOrder(),
                                    ))
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
                                              padding: EdgeInsets.all(5),
                                              //apply padding to all four sides
                                              child: Text(
                                                  "Order Id : " +
                                                      getCustomizeOrders[index],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.left),
                                            ),
                                          ])))));
                    }),
              )),
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AcceptOrder(context),
                                );
                              },
                              child: Text("Accept Request"))))),
              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(15),
                      child: SizedBox(
                          // width: 200, // <-- Your width
                          height: 40, // <-- Your height
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CancelCustomizeOrder(context),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text("Reject Request")))))
            ]),
    );
  }
}
