import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/DeliveryItem.dart';
import 'package:fyp/drivers/onTrackDelivery.dart';

import 'package:http/http.dart' as http;



class AcceptedRequests extends StatefulWidget {
  const AcceptedRequests({Key? key}) : super(key: key);

  @override
  AcceptedRequestsState createState() {
    return AcceptedRequestsState();
  }
}

class AcceptedRequestsState extends State<AcceptedRequests> {
  List<DeliveryItem>? delieryItems = [];

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
      Uri.parse(Config.mainUrl + '/getDeliveryItemssByStatus'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'status':'Accepted','driverId':Config.driverId.toString()}),
    );
    // print(response2.body);
    setState(() {
      delieryItems = (jsonDecode(response2.body) as List)
          .map((e) => DeliveryItem.fromList(e))
          .cast<DeliveryItem>()
          .toList();
      _isLoading=false;
    });
  }
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Accepted Requests'),
          automaticallyImplyLeading: false,
        ),
        body:_isLoading
            ? CircularProgressIndicator():
        CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: SizedBox(
                // height: 100.0,
                child: ListView.builder(
                    itemCount: delieryItems!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return new GestureDetector(
                          onTap: () => {
                            Config.getPerticularDeliverId =
                                delieryItems![index].deliverId,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const OnTrackDelivery()),
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
                                              padding: EdgeInsets.all(15),
                                              //apply padding to all four sides
                                              child: Text("Delivery Id : "+delieryItems![index].deliverId.toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.left),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(15),
                                              //apply padding to all four sides
                                              child: Text(
                                                  delieryItems![index].year.toString()+"/"+
                                                      delieryItems![index].month.toString()+"/"+
                                                      delieryItems![index].date.toString(),
                                                  textAlign: TextAlign.left),
                                            )
                                          ])))));
                    }),
              ))
        ]));
  }
}
