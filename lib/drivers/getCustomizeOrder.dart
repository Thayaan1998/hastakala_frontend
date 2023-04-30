import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:http/http.dart' as http;

class GetCustomizeOrder extends StatefulWidget {
  const GetCustomizeOrder({Key? key}) : super(key: key);

  @override
  GetCustomizeOrderState createState() {
    return GetCustomizeOrderState();
  }
}

class GetCustomizeOrderState extends State<GetCustomizeOrder> {
  bool _isLoading = false;
  List<String>? customizeImages = [];

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

    await loadCustomizeImages();
    await loadOrderDetails();
    await loadUser();

    setState(() {
      _isLoading = false;
    });
  }

  loadCustomizeImages() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeOrderImages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'customizeOrderId': Config.orderId}),
    );
    setState(() {
      List<dynamic> map = [];
      map = List<dynamic>.from(jsonDecode(response.body));
      for (var j = 0; j < map!.length; j++) {
        customizeImages!
            .add(Config.mainUrl + "/getFile?path=" + map[j][0].toString());
      }
    });
  }

  loadOrderDetails() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeOrderDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'customizeOrderId': Config.orderId}),
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
        title: const Text('Get Perticular  Order'),
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
            height: 250.0,
            width: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: customizeImages!.length,
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
                                    height: 150,
                                    width: 150,
                                    child: Center(
                                        child: Container(
                                          height: 150,
                                          width: 150,
                                          child: Image.network(
                                              customizeImages![index],
                                              fit: BoxFit.fill),
                                        ))),
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const Products()),
                      // );
                    },
                    child: Text(
                      orderDescription,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    )))),
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
        ],

      ]),
    );
  }
}
