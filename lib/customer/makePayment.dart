import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/customer/CartItems.dart';
import 'package:fyp/object/Cart.dart';
import 'package:fyp/shopowner/additem.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';

// Create a Form widget.
class MakePayment extends StatefulWidget {
  const MakePayment({Key? key}) : super(key: key);

  @override
  MakePaymentState createState() {
    return MakePaymentState();
  }
}

class MakePaymentState extends State<MakePayment> {
  List<Cart>? items = [];
  double total = 0;
  String vendorId="";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();
    });
  }

  _loadDatas() {
    setState(() {
      _isLoading = true;
      for (var i = 0; i < CartItemsState.items!.length; i++) {
        if (CartItemsState.items![i].checked) {
          items!.add(CartItemsState.items![i]);
          total = total + CartItemsState.items![i]
              .price *  CartItemsState.items![i]
              .quantity
          ;
          vendorId=CartItemsState.items![i].userId.toString();
        }
      }
      _isLoading = false;
    });
  }

  addOrders() async {
    DateTime now = new DateTime.now();

    final response = await http.post(
      Uri.parse(Config.mainUrl + '/addOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customerId': Config.customerId.toString(),
        'vendorId': vendorId,
        'total':total.toString(),
        'status':'added',
        'paymentType':'cash',
        'Month':now.month.toString(),
        'Year':now.year.toString(),
        'day':now.day.toString(),
      }),
    );

    return response.body;
  }
  deleteCartItems(cartId) async {

    final response1 = await http.post(
      Uri.parse(Config.mainUrl + '/deleteCartItems'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cartId': cartId.toString()
      }),
    );


    return response1.body;
  }

  addOrderItems(orderId,itemId,quantity,price,total) async {

    final response2 = await http.post(
      Uri.parse(Config.mainUrl + '/addOrdereditem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'orderId': orderId.toString(),
        'itemId': itemId.toString(),
        'quantity':quantity.toString(),
        'price':price.toString(),
        'total':total.toString(),

      }),
    );

    return response2.body;
  }

  Widget AskToResendImage(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do You Want to make  Payment'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {

            var orderId=await addOrders();
            for (var i = 0; i < items!.length; i++) {
              await deleteCartItems(items![i].cartId);
            }
            for (var i = 0; i < items!.length; i++) {
                    int orderId2=int.parse(orderId);
                    await addOrderItems(orderId2,items![i].itemId,items![i].quantity,items![i].price,items![i].total);
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Payment Made sucessfully"),
            ));
            Navigator.pushNamed(
              context,
              '/home2',
              arguments: {
              },
            );
           // Navigator.of(context).pop();
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

  bool checkedValue = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Make Payment'),
          // automaticallyImplyLeading: false,
        ),
        body: _isLoading
            ? CircularProgressIndicator()
            : CustomScrollView(slivers: [
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
                SliverToBoxAdapter(
                    child: Padding(
                  padding: EdgeInsets.all(20),
                  //apply padding to all four sides
                  child: Text("Total Price : " + total.toString() + " Rs",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.left),
                )),
                SliverToBoxAdapter(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: SizedBox(
                            // width: 200, // <-- Your width
                            height: 40, // <-- Your height
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AskToResendImage(context),
                                );


                              },
                              icon: Icon(Icons.payment),
                              //icon data for elevated button
                              label: Text("Make Payment"),
                            )))),
              ]));
  }
}
