import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Cart.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

class ViewOrderedItems extends StatefulWidget {
  const ViewOrderedItems({Key? key}) : super(key: key);

  @override
  ViewOrderdItemState createState() {
    return ViewOrderdItemState();
  }
}

class ViewOrderdItemState extends State<ViewOrderedItems> {
  bool _isLoading = false;
  List<Cart>? items = [];
  String vendorId = '';
  String total = '';
  String orderDescription = '';
  String name = '';
  String phonenumber = '';
  String address = '';
  String imageurl = '';
  String orderStatus = '';

  @override
  void initState() {
    super.initState();
    orderStatus = Config.orderStatus;

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
      _isLoading = false;
    });
  }

  loadOrderItems() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getPeticularOrderDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'orderId': Config.orderId}),
    );
    setState(() {
      items = (jsonDecode(response.body) as List)
          .map((e) => Cart.fromList(e))
          .cast<Cart>()
          .toList();
    });
  }

  loadOrderDetails() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getOrderDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'orderId': Config.orderId}),
    );
    setState(() {
      var list = (jsonDecode(response.body) as List);
      vendorId = list[0][1].toString();
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
      body: jsonEncode(<String, String>{'userId': vendorId}),
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
        'customizeOrderId': Config.orderId,
        'status': status
      }),
    );
    setState(() {
      _isLoading = false;
    });
  }

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles = [];

  uploadImage(File imageFile, var id, var ids) async {
    try {
      var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse(Config.mainUrl + "/uploadCustomizeOrderImage");

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('photo', stream, length,
          filename: basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFile);

      // send
      var response = await request.send();

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) async {
        var response2 = await http.post(
          Uri.parse(Config.mainUrl + '/addCustomizeordersimage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'customizeOrderId': id,
            'imageUrl': value,
            'id': ids.toString()
          }),
        );
        // return response2.body.toString();
      });

      return "success";
    } catch (e) {
      return "Unsuccess";
    }
  }


  addDamageItem() async {
    setState(() {
      _isLoading = true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/addDamageItem1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customerId': Config.customerId.toString(),
        'vendorId': vendorId,
        'type': 'Normal Items'
      }),
    );
    setState(() {
      _isLoading = false;
    });
  }


  Widget UploadDamageItem(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do You Want to add damage image'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await  addDamageItem();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Damage Item Added Successfully"),
            ));
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
                            "Order Id : " + Config.orderId,
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
                                            child: Text(items![index].itemName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                                    textAlign: TextAlign.left),
                                                Text(
                                                    items![index]
                                                        .price
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 15),
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
                                                    textAlign: TextAlign.left),
                                                Text(
                                                    items![index]
                                                        .quantity
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 15),
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
                                                    textAlign: TextAlign.left),
                                                Text(
                                                    (items![index].price *
                                                            items![index]
                                                                .quantity)
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 15),
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
                  child: Text("Total Price : " + total + " Rs",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.left),
                )),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: EdgeInsets.all(20),
                  //apply padding to all four sides
                  child: Text("Payment Type : " + orderDescription + "",
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const Products()),
                            // );
                          },
                          child: Text(
                            "Vendor Details",
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
              if (orderStatus == 'Ongoing') ...[
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
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) =>
                                  //       AcceptCustomizeOrder(context),
                                  // );
                                },
                                child: Text("Ontrack Orders"))))),
              ] else if (orderStatus == 'Delivered') ...[
                SliverToBoxAdapter(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: SizedBox(
                            // width: 200, // <-- Your width
                            height: 40, // <-- Your height
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  openImages();
                                },
                                child: Text("Open Images"))))),
                imagefiles != null
                    ? SliverToBoxAdapter(
                        child: Wrap(
                        children: imagefiles!.map((imageone) {
                          return Container(
                              child: Card(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.file(File(imageone.path)),
                            ),
                          ));
                        }).toList(),
                      ))
                    : SliverToBoxAdapter(child: Container()),
                SliverToBoxAdapter(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: SizedBox(
                            // width: 200, // <-- Your width
                            height: 40, // <-- Your height
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (imagefiles!.length == 0) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          " Need to select minimum one image"),
                                    ));
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          UploadDamageItem(context),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: Text("Upload DamageItem")))))
              ]
            ]),
    );
  }
}
