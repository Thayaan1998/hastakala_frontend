import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/shopowner/sendOrderToDriver.dart';
import 'package:fyp/object/OrderSend.dart';
import 'package:date_time_picker/date_time_picker.dart';


// Create a Form widget.
class SendOrderToDriver extends StatefulWidget {
  const SendOrderToDriver({Key? key}) : super(key: key);

  @override
  SendOrderToDriverState createState() {
    return SendOrderToDriverState();
  }
}

class SendOrderToDriverState extends State<SendOrderToDriver> {
  bool _isLoading = false;
  String name = '';
  String phonenumber = '';
  String address = '';
  String imageurl = '';
  String total = '';

  List<String> orderList = [];
  List<String> customozeOrderList = [];
  List<OrderSend> _isChecked = [];
  List<OrderSend> _isChecked2 = [];



  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDatas();
    });
    super.initState();
  }

  loadDatas() async {
    setState(() {
      _isLoading = true;
    });

    await loadUser();
    await loadOrders();
    await  loadCustomizeOrderDetails();
    setState(() {
      _isLoading = false;
    });
  }

  loadUser() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getUserDetailsByUserId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'userId': Config.getPerticularDriverId.toString()}),
    );
    setState(() {
      var list = (jsonDecode(response2.body) as List);
      name = list[1];
      phonenumber = list[2];
      address = list[3];
      imageurl = list[5];
    });
  }

  loadOrders() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getPeticularOrderDetailsByStatus'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    setState(() {
      orderList=[];
      var list = (jsonDecode(response2.body) as List);

      _isChecked = (jsonDecode(response2.body) as List)
          .map((e) => OrderSend.fromList(e))
          .cast<OrderSend>()
          .toList();

      for (var i = 0; i < list.length; i++) {
        if (list[i][0] < 10) {
          orderList.add('Order Id : 00' + list[i][0].toString());
        } else if (list[i][0] < 100) {
          orderList.add('Order Id : 0' + list[i][0].toString());
        } else {
          orderList.add('Order Id : ' + list[i][0].toString());
        }

      }
      // _isChecked = List<bool>.filled(orderList.length, false);

    });
  }

  loadCustomizeOrderDetails() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getPeticularCustomozeOrderDetailsByStatus'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    setState(() {
      customozeOrderList=[];

      var list = (jsonDecode(response2.body) as List);
      _isChecked2 = (jsonDecode(response2.body) as List)
          .map((e) => OrderSend.fromList(e))
          .cast<OrderSend>()
          .toList();
      print(list);
      for (var i = 0; i < list.length; i++) {
        if (list[i][0] < 10) {
          customozeOrderList.add('Order Id : 00' + list[i][0].toString());
        } else if (list[i][0] < 100) {
          customozeOrderList.add('Order Id : 0' + list[i][0].toString());
        } else {
          customozeOrderList.add('Order Id : ' + list[i][0].toString());
        }

      }

    });
  }

  WidgetDeliverItem(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do you want to Deliver these Orders'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            var normalOrders='';
            for(var i=0;i<_isChecked.length;i++){
              if(_isChecked[i].checked){
                normalOrders=normalOrders+_isChecked[i].orderId.toString()+",";
                await updateOrderStatus("Delivery Ongoing",_isChecked[i].orderId);
              }
            }

            var customizeOrders='';
            for(var i=0;i<_isChecked2.length;i++){
              if(_isChecked2[i].checked){
                customizeOrders=customizeOrders+_isChecked2[i].orderId.toString()+",";
                await updateCustomizeOrderStatus("Delivery Ongoing",_isChecked2[i].orderId);

              }
            }

            await addDelivery(normalOrders,customizeOrders);

            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Successfully Orders send for the deliver"),
            ));
            Navigator.pushNamed(
              context,
              '/home',
              arguments: {
              },
            );

            //
            //
            // await loadUser();
            // await loadOrders();
            // await  loadCustomizeOrderDetails();


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

  updateCustomizeOrderStatus(status,orderId) async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/updateCustomizeOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customizeOrderId': orderId.toString(),
        'status': status
      }),
    );
  }
  updateOrderStatus(status,orderId) async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/updateOrders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'orderId': orderId.toString(),
        'status': status
      }),
    );
  }
  String date='';

  addDelivery(normalItems,customizeItems) async {
    var dates= date.split('-');

    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/addDeliver'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'driverId': Config.getPerticularDriverId.toString(),
        'vendorId':  Config.vendorId.toString(),
        'normalItems': normalItems,
        'customizeItems':  customizeItems,
        'deliveryCost':price.value.text.toString(),
        'month':dates[1],
        'year':dates[0],
        'day':dates[2],
        'status':'Requested'
      }),
    );
  }

  TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Orders'),
        // automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : CustomScrollView(slivers: [
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
              //apply padding to all four sides
              child: Text("Normal Orders" ,
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.left),
            )),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                    itemCount: orderList!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                          child: Card(
                              elevation: 20,
                              margin: EdgeInsets.all(5),
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CheckboxListTile(
                                    title: Text(orderList[index]),
                                    value: _isChecked[index].checked,
                                    onChanged: (val) {
                                      setState(
                                        () {
                                          _isChecked![index].checked = val!;
                                        },
                                      );
                                    },
                                  ))));
                    }),
              )),
        SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              //apply padding to all four sides
              child: Text("Customize Orders" ,
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.left),
            )),
        SliverToBoxAdapter(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                  itemCount: customozeOrderList!.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                        child: Card(
                            elevation: 20,
                            margin: EdgeInsets.all(5),
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: CheckboxListTile(
                                  title: Text(customozeOrderList[index]),
                                  value: _isChecked2[index].checked,
                                  onChanged: (val) {
                                    setState(
                                          () {
                                        _isChecked2![index].checked = val!;
                                      },
                                    );
                                  },
                                ))));
                  }),
            )),
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: DateTimePicker(
                  initialValue: '',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Deliver Date',
                    //hintText: 'Enter Item',
                  ),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Date',
                  onChanged: (val) => {
                    // print(val),
                    date=val
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ))),
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  // The validator receives the text that the user has entered.
                  // obscureText: true,
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Price',
                      //hintText: 'Enter Item',
                    )))),
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
                          DateTime dt = DateTime.parse(date);
                          var now = new DateTime.now();

                          print(date);

                          if(now.isAfter(dt)){

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Deliver Date is should be greater than todays date"),
                            ));
                          }else if(price.value.text==''){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Please enter Deliver Cost"),
                            ));
                          }else{

                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  WidgetDeliverItem(context),
                            );

                          }

                        },
                        child: Text("Deliver Item")))
            )
        )
            ]),
    );
  }
}
