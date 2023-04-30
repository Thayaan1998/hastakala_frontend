import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Cart.dart';
import 'package:fyp/customer/makePayment.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';

// Create a Form widget.
class CartItems extends StatefulWidget {
  const CartItems({Key? key}) : super(key: key);

  @override
  CartItemsState createState() {
    return CartItemsState();
  }
}

class CartItemsState extends State<CartItems> {
  static List<Cart>? items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();
    });
  }

  _loadDatas() async {
    setState(() {
      _isLoading=true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getAllCartForUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'userId': Config.customerId.toString()}),
    );
    setState(() {
      items = (jsonDecode(response2.body) as List)
          .map((e) => Cart.fromList(e))
          .cast<Cart>()
          .toList();
      _isLoading=false;
    });
  }

  addOrUpdateCart(itemId, itemCount) async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/addOrUpdateCart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemId': itemId.toString(),
        'userId': Config.customerId.toString(),
        'quantity': itemCount.toString()
      }),
    );

    return response.body;
  }

  bool checkedValue = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart Items'),
          automaticallyImplyLeading: false,
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
                          margin: EdgeInsets.all(10),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
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
                                            // Padding(
                                            //     padding: EdgeInsets.all(15),
                                            //     child: Row(children: <Widget>[
                                            //       Text("Quantity: ",
                                            //           style: TextStyle(
                                            //               fontWeight: FontWeight.bold,
                                            //               fontSize: 15),
                                            //           textAlign: TextAlign.left),
                                            //       Text(
                                            //           items![index]
                                            //               .quantity
                                            //               .toString(),
                                            //           style: TextStyle(fontSize: 15),
                                            //           textAlign: TextAlign.left)
                                            //     ])),
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 10, 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      child: IconButton(
                                                          icon: new Icon(
                                                              Icons.remove,
                                                              size: 15.0),
                                                          onPressed: () async {

                                                         int itemCount=   items![index]
                                                                .quantity - 1;

                                                         if(itemCount>0) {
                                                           setState(() {
                                                             _isLoading = true;
                                                             items![index]
                                                                 .quantity =
                                                                 items![index]
                                                                     .quantity -
                                                                     1;
                                                           });

                                                           await addOrUpdateCart(
                                                               items![index]
                                                                   .itemId,
                                                               items![index]
                                                                   .quantity);
                                                           setState(() {
                                                             _isLoading = false;
                                                           });
                                                         }
                                                          },
                                                          color: Colors.black)),
                                                  Text(
                                                      items![index]
                                                          .quantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 30)),
                                                  Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 0, 10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black)),
                                                      child: IconButton(
                                                          icon: new Icon(
                                                              Icons.add,
                                                              size: 15.0),
                                                          onPressed: () async {
                                                            setState(
                                                              () =>
                                                                  setState(() {
                                                                    _isLoading=true;
                                                                items![index]
                                                                        .quantity =
                                                                    items![index]
                                                                            .quantity +
                                                                        1;
                                                              }),
                                                            );
                                                            await addOrUpdateCart(
                                                                items![index]
                                                                    .itemId,
                                                                items![index]
                                                                    .quantity);
                                                            setState(() {
                                                              _isLoading=false;
                                                            });
                                                          },
                                                          color: Colors.black)),
                                                ]),
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
                                                  Text("Total: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 15),
                                                      textAlign:
                                                      TextAlign.left),
                                                  Text(
                                                      (items![index]
                                                          .price *  items![index]
                                                          .quantity).toString()
                                                          ,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      textAlign: TextAlign.left)
                                                ])),
                                            Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Row(children: <Widget>[
                                                  Text("Shop: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 15),
                                                      textAlign:
                                                      TextAlign.left),
                                                  Text(
                                                      items![index]
                                                          .name
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      textAlign: TextAlign.left)
                                                ]))
                                          ]),
                                    ),
                                    Checkbox(
                                      value: items![index].checked,
                                      onChanged: (newValue) {
                                        setState(() {
                                          items![index].checked = newValue!;
                                        });
                                      },
                                    )
                                  ]))));
                }),
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
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () async {
                          List<String>? userIds = [];
                          for(var i=0;i<items!.length;i++){

                             if(items![i].checked){
                               if(!userIds.contains(items![i].userId.toString())){
                                 userIds.add(items![i].userId.toString());
                               }
                             }
                          }
                          if(userIds.length==0){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("Please select one Item "),
                            ));
                          }else if(userIds.length==1){

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const MakePayment()),
                            );
                          }else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("can't select items from more shops"),
                            ));
                          }

                        },
                        icon: Icon(Icons.payment),
                        //icon data for elevated button
                        label: Text("Make Payment"),
                      )))),
        ]));
  }
}
