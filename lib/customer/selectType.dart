import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/customer/customizeShopsSearch.dart';
import 'package:fyp/customer/products.dart';
import 'package:fyp/customer/normalShopsSearch.dart';

import 'package:fyp/object/Item.dart';
import 'package:fyp/object/Shop.dart';
import 'package:http/http.dart' as http;

class SelectType extends StatefulWidget {
  const SelectType({Key? key}) : super(key: key);

  @override
  SelectTypeState createState() {
    return SelectTypeState();
  }
}

class SelectTypeState extends State<SelectType> {
  var _isLoading = false;

  List<Item>? items = [];

  List<Shop>? shops = [];

  List<Shop>? customizeShops = [];

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
    await _loadItems();
    await _loadShops();
    await _loadCustomizeShops();
    setState(() {
      _isLoading=false;
    });
  }

  _loadItems() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItems'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );

    setState(() {
      items = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
    });
  }

  _loadShops() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getShops2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );

    setState(() {
      shops = (jsonDecode(response2.body) as List)
          .map((e) => Shop.fromList(e))
          .cast<Shop>()
          .toList();
    });
  }

  _loadCustomizeShops() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeShops'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );

    setState(() {
      customizeShops = (jsonDecode(response2.body) as List)
          .map((e) => Shop.fromList(e))
          .cast<Shop>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
      ),
      body: Container(
          color: Colors.white,
          child: _isLoading
              ? CircularProgressIndicator()
              : CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Products()),
                                );
                                },
                              child: Text(
                                'Items ➩',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              )))),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 250.0,
                      width: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items!.length,
                        itemBuilder: (context2, index) {
                          return new GestureDetector(
                              onTap: () => {

                                Config.itemId= items![index].itemId,
                                Navigator.pushNamed(
                                  context,
                                  '/getItemForOrder',
                                  arguments: {'itemId': items![index].itemId,
                                    'itemName':items![index].itemName,
                                    'description':items![index].description,
                                    'price':items![index].price
                                  },
                                )
                              },
                              child: SizedBox(
                            // width: 100.0,

                            child: Card(
                                elevation: 20,
                                margin: EdgeInsets.all(20),
                                child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(children: <Widget>[
                                      Container(
                                          // color: Colors.blue,
                                          height: 127,
                                          width: 150,
                                          child: Center(
                                              child: Container(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(
                                                Config.mainUrl +
                                                    "/getFile?path=" +
                                                    items![index].imageUrl),
                                          ))),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 10, 10),
                                        child: Text(
                                          items![index].itemName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ]))),
                          ));
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const NormalShopsSearch()),
                                );
                              },
                              child: Text(
                                'Shops ➩',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              )))),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 250.0,
                      width: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: shops!.length,
                        itemBuilder: (context2, index) {
                          return new GestureDetector(
                              child: SizedBox(
                            // width: 100.0,

                            child: Card(
                                elevation: 20,
                                margin: EdgeInsets.all(20),
                                child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(children: <Widget>[
                                      Container(
                                          // color: Colors.blue,
                                          //   width: 150,
                                          //   height: 150,
                                          child: Center(
                                              child: Container(
                                        height: 127,
                                        width: 150,
                                        child: Image.network(Config.mainUrl +
                                            "/getFile?path=" +
                                            shops![index].imageUrl),
                                      ))),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 10, 10),
                                        child: Text(
                                          shops![index].shopName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ]))),
                          ));
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CustomizeShopsSearch()),
                                );
                              },
                              child: Text(
                                'Customize Shops ➩',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              )))),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 250.0,
                      width: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: customizeShops!.length,
                        itemBuilder: (context2, index) {
                          return new GestureDetector(
                              child: SizedBox(
                            // width: 100.0,

                            child: Card(
                                elevation: 20,
                                margin: EdgeInsets.all(20),
                                child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(children: <Widget>[
                                      Container(
                                          // color: Colors.blue,
                                          //   width: 150,
                                          //   height: 150,
                                          child: Center(
                                              child: Container(
                                        height: 127,
                                        width: 150,
                                        child: Image.network(Config.mainUrl +
                                            "/getFile?path=" +
                                            customizeShops![index].imageUrl),
                                      ))),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 10, 10, 10),
                                        child: Text(
                                          customizeShops![index].shopName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ]))),
                          ));
                        },
                      ),
                    ),
                  ),
                ])),
    );
  }
}
