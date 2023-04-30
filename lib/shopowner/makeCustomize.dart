import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:fyp/config.dart';

// Create a Form widget.
class MakeCustomize extends StatefulWidget {
  const MakeCustomize({Key? key}) : super(key: key);

  @override
  MakeCustomizeState createState() {
    return MakeCustomizeState();
  }
}

class MakeCustomizeState extends State<MakeCustomize> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles = [];

  // Initial Selected Value
  String dropdownvalue = 'Select a Category';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkCustomizeVendorIsThere();
    });
  }

  String showItem = '';
  String makeCustomize = 'yes';
  bool makeCustomizeBool = false;

  var items =Config.items;

  checkCustomizeVendorIsThere() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/checkCustomizeVendorIsThere'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'vendorId': Config.vendorId.toString()}),
    );

    if (jsonDecode(response.body) == "No Customize") {
      setState(() {
        showItem = 'no';
      });
    } else if (jsonDecode(response.body) == "Cannot Make") {
      setState(() {
        showItem = 'yes';
        makeCustomize = 'no';
        makeCustomizeBool = false;
      });
      await setCustomizeImagesType();
    } else {
      setState(() {
        showItem = 'yes';
        makeCustomize = 'yes';
        makeCustomizeBool = true;
      });

      await setCustomizeImagesType();
    }
  }

  deleteCustomizeImage() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/deleteCustomizeImages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'vendorId': Config.vendorId.toString()}),
    );
  }

  List<String> images = [];

  setCustomizeImagesType() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeImages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'vendorId': Config.vendorId.toString()}),
    );


    final response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeType'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'vendorId': Config.vendorId.toString()}),
    );

    setState(() {
      List<dynamic> map = [];
      map = List<dynamic>.from(jsonDecode(response.body));
      for (var j = 0; j < map!.length; j++) {
        images!.add(Config.mainUrl + "/getFile?path=" + map[j][0].toString());
      }
      map = [];
      map = List<dynamic>.from(jsonDecode(response2.body));
      dropdownvalue=map[0].toString();
    });
  }

  updateCustomizeStatus(status, type) async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/updateCustomizeStatus'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'vendorId': Config.vendorId.toString(),
        'status': status,
        'type': type
      }),
    );
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

  uploadImage(File imageFile, var ids) async {
    try {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse(Config.mainUrl + "/addCustomizeImage");

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
          Uri.parse(Config.mainUrl + '/addCustomizeImages'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'vendorId': Config.vendorId.toString(),
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

  addCustomizeVendor() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/addCustomizeVendor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'vendorId': Config.vendorId.toString(),
        'type': "no type",
        'status': "Cannot Make"
      }),
    );
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Make Customize'),
          elevation: 0.0,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (showItem == 'yes') ...[
                ListTile(
                    title: const Text('Make Customize'),
                    leading: Checkbox(
                      value: makeCustomizeBool,
                      onChanged: (newValue) {
                        setState(() {
                          makeCustomizeBool = newValue!;
                          makeCustomize = makeCustomizeBool ? "yes" : "no";
                        });
                      },
                    )),
                if (makeCustomize == 'yes') ...[
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),

                          //hintText: 'Enter Item',
                        ),
                        // Initial Value
                        value: dropdownvalue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: SizedBox(
                          // width: 200, // <-- Your width
                          height: 40, // <-- Your height
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                openImages();
                              },
                              child: Text("Open Images")))),
                  imagefiles != null
                      ? Wrap(
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
                        )
                      : Container(
                        ),
                  if (imagefiles!.length == 0) ...[
                    Wrap(
                      children: images!.map((imageone) {
                        return Container(
                            child: Card(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.network(imageone),
                          ),
                        ));
                      }).toList(),
                    )
                  ],

                ],
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                      // width: 200, // <-- Your width
                        height: 40, // <-- Your height
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Theme.of(context).primaryColor),
                          onPressed: () async {
                            if (makeCustomize == "no") {
                              await updateCustomizeStatus(
                                  "Cannot Make", dropdownvalue);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(" customize item Saved Successfully"),
                              ));
                            } else {
                              if (imagefiles!.length == 0) {

                                if(images.length>0){
                                  await updateCustomizeStatus(
                                      "Can Make", dropdownvalue);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(" customize item Saved Successfully"),
                                  ));
                                }else{
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        " Need to select minimum one image"),
                                  ));
                                }

                              } else {
                                await deleteCustomizeImage();
                                for (int i = 0; i < imagefiles!.length; i++) {
                                  await uploadImage(
                                      File(imagefiles![i].path), i + 1);
                                }
                                await updateCustomizeStatus(
                                    "Can Make", dropdownvalue);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(" customize item Saved Successfully"),
                                ));
                              }
                            }
                          },
                          icon: Icon(Icons.save),
                          //icon data for elevated button
                          label: Text("Save"),
                        ))),
              ] else if (showItem == 'no') ...[
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                        // width: 200, // <-- Your width
                        height: 40, // <-- Your height
                        width: double.infinity,
                        child: Text("Do You want to create cutomize Products",
                            style: TextStyle(fontSize: 17)))),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                        height: 40, // <-- Your height
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () async {
                            setState(() {
                              showItem = 'yes';
                            });

                            await addCustomizeVendor();
                          },
                          //textColor: Theme.of(context).primaryColor,
                          child: const Text('yes'),
                        ))),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                        height: 40, // <-- Your height
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            //textColor: Theme.of(context).primaryColor,
                            child: const Text('No'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ))))
              ]
            ],
          ),
        ));
  }
}
