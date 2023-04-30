import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';

class SendMyCV extends StatefulWidget {
  const SendMyCV({Key? key}) : super(key: key);

  @override
  SendMyCVState createState() {
    return SendMyCVState();
  }
}

class SendMyCVState extends State<SendMyCV> {
  bool _isLoading = false;

  String vendorId = '';
  String vacancyCategory = '';
  String vacancyJobTitle = '';
  String vacancyDescription = '';

  String name = '';
  String phonenumber = '';
  String address = '';
  String imageurl = '';

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
    await loadVacanciesDetails();
    await loadUser();

    setState(() {
      _isLoading = false;
    });
  }

  deleteCustomizeOrderImages() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/deleteCustomizeordersimage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'customizeOrderId': Config.orderId}),
    );
  }

  loadVacanciesDetails() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getVacanciesByJobDescriptionId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'jobDescriptionId': Config.getJobVacancyId.toString()
      }),
    );
    setState(() {
      var list = (jsonDecode(response.body) as List);
      vendorId = list[0][1].toString();
      vacancyCategory = list[0][2].toString();
      vacancyJobTitle = list[0][3].toString();
      vacancyDescription = list[0][4].toString();
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

  // Widget AcceptCustomizeOrder(BuildContext context) {
  //   return new AlertDialog(
  //     scrollable: true,
  //     insetPadding: EdgeInsets.all(10),
  //     title: const Text('Do You Want Accept this order'),
  //     actions: <Widget>[
  //       new ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //             backgroundColor: Theme.of(context).primaryColor),
  //         onPressed: () async {
  //           await updateCustomizeOrderStatus("Ongoing");
  //           await loadOrderDetails();
  //           await loadUser();
  //
  //           // await updateCustomizePrice(price.value.text);
  //
  //           setState(() {
  //             orderStatus = 'Ongoing';
  //           });
  //           Navigator.of(context).pop();
  //         },
  //         //textColor: Theme.of(context).primaryColor,
  //         child: const Text('Yes'),
  //       ),
  //       new ElevatedButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         //textColor: Theme.of(context).primaryColor,
  //         child: const Text('No'),
  //         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //       ),
  //     ],
  //   );
  // }

  //TextEditingController price = TextEditingController();

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

  uploadImage(File imageFile) async {
    try {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse(Config.mainUrl + "/cvUpload");

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
          Uri.parse(Config.mainUrl + '/addJobcvs'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'customerId': Config.customerId.toString(),
            'JobDescriptionId': Config.getJobVacancyId.toString(),
            'fileUrl': value
          }),
        );
        // return response2.body.toString();
      });

      return "success";
    } catch (e) {
      return "Unsuccess";
    }
  }

  /// Get from gallery
  var cv = null;

  _getFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    print(result);

    if (result != null) {
      //File file = File(result.files.single.path);
      setState(() {
        cv = File(result.files.single.path.toString());
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Whole Details'),
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
                            "Vacancy Id : " + Config.getJobVacancyId.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          )))),
              SliverToBoxAdapter(
                  child: Padding(
                padding: EdgeInsets.all(20),
                //apply padding to all four sides
                child: Text("Job Title : " + vacancyJobTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    textAlign: TextAlign.left),
              )),
              SliverToBoxAdapter(
                  child: Padding(
                padding: EdgeInsets.all(20),
                //apply padding to all four sides
                child: Text("Category : " + vacancyCategory,
                    style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
              )),
              SliverToBoxAdapter(
                  child: Padding(
                padding: EdgeInsets.all(20),
                //apply padding to all four sides
                child: Text(vacancyDescription,
                    style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
              )),
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
              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(15),
                      child: SizedBox(
                          // width: 200, // <-- Your width
                          height: 40, // <-- Your height
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                _getFromGallery();
                              },
                              child: Text("Select Cv File"))))),
              if (cv != null) ...[
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
                              "Selected cv File",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )))),
              ],
              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(15),
                      child: SizedBox(
                          // width: 200, // <-- Your width
                          height: 40, // <-- Your height
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                if(cv==null){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        " want to Selct Cv"),
                                  ));
                                }else{
                                  await uploadImage(cv);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Cv Uploaded Successfully"),
                                  ));
                                  Navigator.pop(context);

                                }
                              },
                              child: Text("Upload Cv"))))),
            ]),
    );
  }
}
