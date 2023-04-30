import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';



class GetPeticualarCustomizeShop extends StatefulWidget {
  const GetPeticualarCustomizeShop({Key? key}) : super(key: key);

  @override
  GetPeticualarCustomizeShopState createState() {
    return GetPeticualarCustomizeShopState();
  }
}

class GetPeticualarCustomizeShopState
    extends State<GetPeticualarCustomizeShop> {
  List<String>? customizeImages = [];
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCustomizeImages();
    });
  }

  loadCustomizeImages() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeImages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'vendorId': Config.shopId.toString()}),
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

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles = [];

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

  uploadImage(File imageFile,var id, var ids) async {
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
            'customizeOrderId':id,
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

  addCustomizeOrders(year,month,date) async {
    String status='Requested';
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/addCustomizeOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customerId':Config.customerId.toString(),
        'vendorId': Config.shopId.toString(),
        'description': description.value.text.toString(),
        'total':"",
        'Month':month,
        'Year':year,
        'day':date,
        'status': status
      }),
    );
    return response.body;
  }


  TextEditingController description = TextEditingController();
  String date='';

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['shopname'].toString()),
        // automaticallyImplyLeading: false,
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
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const Products()),
                                // );
                              },
                              child: Text(
                                'Our Products',
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
                          padding: EdgeInsets.all(15),
                          child: TextField(
                              // The validator receives the text that the user has entered.
                              // obscureText: true,
                              controller: description,
                              maxLines: 6,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Description',
                                //hintText: 'Enter Item',
                              )))),
                  SliverToBoxAdapter(
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: DateTimePicker(
                            initialValue: '',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Request Date',
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
                            onPressed: () async{

                              if(description.value.text==''){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Please Enter description"),
                                ));
                              }else if(date==''){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Please Select Date"),
                                ));
                              }else if(imagefiles!.length==0){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      " Need to select minimum one image"),
                                ));
                              }else{

                                var now = new DateTime.now();
                                var dates= date.split('-');
                                DateTime dt = DateTime.parse(date);

                                if(now.isAfter(dt)){

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Request Date is should be greater than todays date"),
                                  ));
                                }else{
                                  // print(dates[1]);
                                  var id = await addCustomizeOrders(dates[0],dates[1],dates[2]);

                                  for (int i = 0; i < imagefiles!.length; i++) {
                                    await uploadImage(File(imagefiles![i].path), id,i+1);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Quotation Requested Successfully"),
                                  ));
                                  Navigator.of(context).pop();
                                }



                              }


                            },
                            child: Text("Request Quotation")))))
                ])),
    );
  }
}
