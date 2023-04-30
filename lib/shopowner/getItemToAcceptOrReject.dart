import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:http/http.dart' as http;

class GetItemToAcceptOrReject extends StatefulWidget {
  const GetItemToAcceptOrReject({Key? key}) : super(key: key);

  @override
  GetItemToAcceptOrRejectState createState() {
    return GetItemToAcceptOrRejectState();
  }
}

class GetItemToAcceptOrRejectState extends State<GetItemToAcceptOrReject> {
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
          <String, String>{'customizeOrderId': Config.orderId.split(':')[1]}),
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
          <String, String>{'customizeOrderId': Config.orderId.split(':')[1]}),
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

  updateCustomizeOrderStatus(status) async {
    setState(() {
      _isLoading = true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/updateCustomizeOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customizeOrderId': Config.orderId.split(':')[1],
        'status': status
      }),
    );
    setState(() {
      _isLoading = false;
    });
  }

  updateCustomizePrice(total) async {
    setState(() {
      _isLoading = true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/updateCustomizePrice'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customizeOrderId': Config.orderId.split(':')[1],
        'total': total
      }),
    );
    setState(() {
      _isLoading = false;
    });
  }

  Widget AcceptCustomizeOrder(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do You Want Accept this order'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await updateCustomizeOrderStatus("Accepted");
            await updateCustomizePrice(price.value.text);
            await loadOrderDetails();
            await loadUser();

            setState(() {
              Config.orderStatus = 'Accepted';
            });
            Navigator.of(context).pop();
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

  Widget OngoingCustomizeOrder(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do You Want Accept these resent images'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await updateCustomizeOrderStatus("Ongoing");
            // await updateCustomizePrice(price.value.text);
            await loadOrderDetails();
            await loadUser();

            setState(() {
              Config.orderStatus = 'Ongoing';
            });
            Navigator.of(context).pop();
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
      title: const Text('Do You Want Reject this order'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await updateCustomizeOrderStatus("Rejected");
            await loadOrderDetails();
            await loadUser();
            setState(() {
              Config.orderStatus = 'Rejected';
            });
            Navigator.of(context).pop();

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

  Widget AskToResendImage(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Ask to resend image'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await updateCustomizeOrderStatus("Resend Image");
            await loadOrderDetails();
            await loadUser();
            setState(() {
              Config.orderStatus = 'Resend Image';
            });
            Navigator.of(context).pop();

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

  TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customized Order'),
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
                            Config.orderId,
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
              if (Config.orderStatus == 'Requested') ...[
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
                                  if (price.value.text == '') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Please Enter Price"),
                                    ));
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AcceptCustomizeOrder(context),
                                    );
                                  }
                                },
                                child: Text("Accept Order "))))),
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
                                child: Text("Reject Order ")))))
              ] else if (Config.orderStatus == 'Accepted') ...[
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
                                        AskToResendImage(context),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: Text("Ask To Resend Image ")))))
              ] else if (Config.orderStatus == 'Images Resent') ...[
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
                                  // if (price.value.text == '') {
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(SnackBar(
                                  //     content: Text("Please Enter Price"),
                                  //   ));
                                  // } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          OngoingCustomizeOrder(context),
                                    );
                                  }
                                ,
                                child: Text("Accept The Resent Images "))))),
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
                                        AskToResendImage(context),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: Text("Ask Again To Resend Image ")))))
              ]
            ]),
    );
  }
}
