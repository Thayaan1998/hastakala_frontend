import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/OrderDetails.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/customer/viewCustomizeItems.dart';


class GetCustomizeOrders extends StatefulWidget {
  const GetCustomizeOrders({Key? key}) : super(key: key);

  @override
  GetCustomizeOrdersState createState() {
    return GetCustomizeOrdersState();
  }
}

class GetCustomizeOrdersState extends State<GetCustomizeOrders> {
  bool _isLoading = false;
  List<OrderDetails>? orderDetails = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadOrderDetails();
    });
  }

  loadOrderDetails() async {
    setState(() {
      _isLoading=true;
    });

    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeOrdersByCustomerId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customerId': Config.customerId.toString(),
        'status': Config.orderStatus
      }),
    );
    setState(() {
      orderDetails = (jsonDecode(response.body) as List)
          .map((e) => OrderDetails.fromList(e))
          .cast<OrderDetails>()
          .toList();
      for(var i=0;i<orderDetails!.length;i++){
       if(orderDetails![i].orderId<10){
         orderDetails![i].orderId=00+  orderDetails![i].orderId;
       }else if(orderDetails![i].orderId<100){
         orderDetails![i].orderId=0+  orderDetails![i].orderId;
       }else{
         orderDetails![i].orderId= orderDetails![i].orderId;
       }
      }
      _isLoading=false;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Config.orderStatus),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : CustomScrollView(slivers: [
        SliverToBoxAdapter(
            child: SizedBox(
              // height: 100.0,
              child: ListView.builder(
                  itemCount: orderDetails!.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return new GestureDetector(
                        onTap: () => {

                        Config.orderId = orderDetails![index].orderId.toString(),
                        Config.orderStatus = orderDetails![index].status.toString(),
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) =>
                        const ViewCustomizeItems()),
                        ).then((value) async {
                        setState(()  {
                        orderDetails= [];

                        _isLoading=true;

                        });
                        await loadOrderDetails();
                        setState(()  {
                        _isLoading=false;

                        });
                        })

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
                                        child: Text("Order Id : "+orderDetails![index].orderId.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        //apply padding to all four sides
                                        child: Text(orderDetails![index].year.toString()+"/"+orderDetails![index].month.toString()+"/"+orderDetails![index].date.toString(),
                                            style: TextStyle(
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                      ),
                                      // Padding(
                                      //   padding: EdgeInsets.all(15),
                                      //   //apply padding to all four sides
                                      //   child: Text(
                                      //           orderDetails![index].status.toString(),
                                      //       textAlign: TextAlign.left),
                                      // )
                                    ])
                            ))));
                  })))

      ]),
    );
  }
}
