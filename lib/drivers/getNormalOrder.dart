import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Cart.dart';
import 'package:http/http.dart' as http;

class GetNormalOrder extends StatefulWidget {
  const GetNormalOrder({Key? key}) : super(key: key);

  @override
  GetNormalOrderState createState() {
    return GetNormalOrderState();
  }
}

class GetNormalOrderState extends State<GetNormalOrder> {
  bool _isLoading = false;
  List<Cart>? items = [];

  String customerId = '';
  String orderDescription = '';
  String name = '';
  String phonenumber = '';
  String address = '';
  String imageurl = '';
  String total = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDatas();
    });
  }

  loadDatas() async {
    setState(() {
      _isLoading = true;
    });

    await loadOrderItems();
    await loadOrderDetails();
    await loadUser();

    setState(() {
      print("object");
      _isLoading = false;
    });
  }



  loadOrderItems() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getPeticularOrderDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'orderId':Config.orderId}),
    );
    setState(() {
      items = (jsonDecode(response.body) as List)
          .map((e) => Cart.fromList(e))
          .cast<Cart>()
          .toList();
    });
  }

  loadOrderDetails() async {
    print(Config.orderStatus);
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getOrderDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'orderId': Config.orderId}),
    );
    setState(() {
      var list = (jsonDecode(response.body) as List);
      customerId = list[0][0].toString();
      orderDescription = list[0][2].toString();
      total = list[0][4].toString();
    });
  }

  loadUser() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getUserDetailsByUserId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'userId': customerId}),
    );
    setState(() {
      var list = (jsonDecode(response2.body) as List);
      name = list[1];
      phonenumber = list[2];
      address = list[3];
      imageurl = list[5];
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Peticular Order'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : CustomScrollView(slivers: [
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const Products()),
                      // );
                    },
                    child: Text(
                      "Order Id : "+Config.orderId,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30),
                    )))),
        SliverToBoxAdapter(
            child: SizedBox(
              // height: 100.0,
              child: ListView.builder(
                  itemCount: items!.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                        child: Card(
                            elevation: 20,
                            margin: EdgeInsets.all(20),
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(children: <Widget>[
                                  Container(
                                    // color: Colors.blue,
                                    //   width: 150,
                                    //   height: 150,
                                      child: Center(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(Config.mainUrl +
                                                "/getFile?path=" +
                                                items![index].imageUrl),
                                          ))),
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
                                              child: Text(
                                                  items![index].itemName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.left),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Row(children: <Widget>[
                                                  Text("Price: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 15),
                                                      textAlign:
                                                      TextAlign.left),
                                                  Text(
                                                      items![index]
                                                          .price
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      textAlign: TextAlign.left)
                                                ])),
                                            Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Row(children: <Widget>[
                                                  Text("Quantity: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 15),
                                                      textAlign:
                                                      TextAlign.left),
                                                  Text(
                                                      items![index]
                                                          .quantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      textAlign: TextAlign.left)
                                                ])),
                                            Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Row(children: <Widget>[
                                                  Text("Total: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 15),
                                                      textAlign:
                                                      TextAlign.left),
                                                  Text(
                                                      (items![index].price *
                                                          items![index]
                                                              .quantity)
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      textAlign: TextAlign.left)
                                                ])),
                                          ]))
                                ]))));
                  }),
            )),


        if (total != '') ...[
          SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                //apply padding to all four sides
                child: Text("Total Price : " + total + "Rs",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.left),
              )),
          SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                //apply padding to all four sides
                child: Text("Payment Type : " + orderDescription + " ",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.left),
              )),
        ],
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: InkWell(
                    onTap: () {

                    },
                    child: Text(
                      "Customer Details",
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
      ]),
    );
  }
}
