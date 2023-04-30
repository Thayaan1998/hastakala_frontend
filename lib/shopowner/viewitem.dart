import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Item.dart';
import 'package:fyp/shopowner/additem.dart';
import 'package:http/http.dart' as http;

// Create a Form widget.
class ViewItem extends StatefulWidget {
  const ViewItem({Key? key}) : super(key: key);

  @override
  ViewItemState createState() {
    return ViewItemState();
  }
}

class ViewItemState extends State<ViewItem> {
  List<Item>? items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();
    });
  }

  _loadDatas() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemByVendor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'vendorId': Config.vendorId.toString()}),
    );
    setState(() {
      items = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Items'),
        ),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    onChanged: (content) async {
                      await _loadDatas();
                      setState(() {
                        items!.retainWhere((item) {
                          return item.itemName.toLowerCase().contains(
                              content.toString().toLowerCase().toLowerCase());
                          //you can add another filter conditions too
                        });
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: 'Search Item',
                    ),
                  ))),
          SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: SizedBox(
                      // width: 200, // <-- Your width
                      height: 40, // <-- Your height
                      width: 100,
                      child: ElevatedButton(
                        child: const Text('Add Item'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddItem()),
                          ).then((value) {
                            setState(() {
                              // refresh state of Page1
                              items = [];
                              _loadDatas();
                            });
                          });
                        },
                      )))),


          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 250.0,
          //     width: 500,
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount:   items!.length,
          //       itemBuilder: (context, index) {
          //         return SizedBox(
          //           // width: 100.0,
          //
          //           child:  Card(
          //               elevation: 20,
          //               margin: EdgeInsets.all(20),
          //               child: Padding(
          //                   padding: EdgeInsets.all(20),
          //                   child: Row(children: <Widget>[
          //                     Container(
          //                       // color: Colors.blue,
          //                       //   width: 150,
          //                       //   height: 150,
          //                         child: Center(
          //                             child: Container(
          //                               height: 100,
          //                               width: 100,
          //                               child: Image.network(Config.mainUrl +
          //                                   "/getFile?path=" +
          //                                   items![index].imageUrl),
          //                             ))),
          //                     Container(
          //                       // color: Colors.blue,
          //                       //   width: 200,
          //                       //   height: 150,
          //
          //                         child: Column(
          //                             crossAxisAlignment:
          //                             CrossAxisAlignment.start,
          //                             children: <Widget>[
          //                               Padding(
          //                                 padding: EdgeInsets.all(15),
          //                                 //apply padding to all four sides
          //                                 child: Text(items![index].itemName,
          //                                     style: TextStyle(
          //                                         fontWeight: FontWeight.bold,
          //                                         fontSize: 15),
          //                                     textAlign: TextAlign.left),
          //                               ),
          //                               Padding(
          //                                 padding: EdgeInsets.all(15),
          //                                 //apply padding to all four sides
          //                                 child: Text(
          //                                     "price:" +
          //                                         items![index].price.toString(),
          //                                     textAlign: TextAlign.left),
          //                               ),
          //                               Padding(
          //                                 padding: EdgeInsets.all(15),
          //                                 //apply padding to all four sides
          //                                 child: Text(
          //                                     "Quantity:" +
          //                                         items![index]
          //                                             .quantity
          //                                             .toString(),
          //                                     textAlign: TextAlign.left),
          //                               )
          //                             ]))
          //                   ]))),
          //         );
          //       },
          //     ),
          //   ),
          // ),
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
                                        padding: EdgeInsets.all(15),
                                        //apply padding to all four sides
                                        child: Text(items![index].itemName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        //apply padding to all four sides
                                        child: Text(
                                            "price:" +
                                                items![index].price.toString(),
                                            textAlign: TextAlign.left),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        //apply padding to all four sides
                                        child: Text(
                                            "Quantity:" +
                                                items![index]
                                                    .quantity
                                                    .toString(),
                                            textAlign: TextAlign.left),
                                      )
                                    ]))
                              ]))));
                }),
          ))
        ]));
  }
}
