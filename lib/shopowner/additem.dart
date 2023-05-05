import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:fyp/config.dart';

// Create a Form widget.
class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  AddItemState createState() {
    return AddItemState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddItemState extends State<AddItem> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles=[];

  // Initial Selected Value
  String dropdownvalue = 'Select a Category';

  // List of items in our dropdown menu
  var items = Config.items;

  final _formKey = GlobalKey<FormState>();
  TextEditingController itemName = TextEditingController();
  TextEditingController itemPrice = TextEditingController();
  TextEditingController itemQuantity = TextEditingController();
  TextEditingController itemDescription = TextEditingController();

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

  uploadImage(File imageFile, var id,var ids) async {
    try {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse(Config.mainUrl+"/uploadImage");

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
          Uri.parse(Config.mainUrl+'/addItemImage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'itemId': id, 'imageUrl': value,'id':ids.toString()}),
        );
        // return response2.body.toString();
      });

      return "success";
    } catch (e) {
      return "Unsuccess";
    }
  }

  uploadItem(itemName, price, quantity, description) async {
    final response = await http.post(
      Uri.parse(Config.mainUrl+'/addItem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemName': itemName.toString(),
        'price': price.toString(),
        'quantity': quantity.toString(),
        'itemType':dropdownvalue,
        'description': description.toString(),
        'vendorId': Config.vendorId.toString()
      }),
    );
    return response.body;
  }

  machinelearningimages(id) async {
    if(dropdownvalue=="Arts And Paintings"){
      final response = await http.post(
        Uri.parse(Config.mainUrl+'/addMachineLearingImages'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'itemId': id,
          'type':dropdownvalue2
        }),
      );
    }

  }

  String dropdownvalue2 = 'Select a Type';
  var jobTile=['Select a Type'];

  getJobTitle() async {
    setState(() {
      _isLoading=true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getJobTitle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'category':dropdownvalue}),
    );
    // print(response2.body);
    setState(() {
      var getJobTitle = (jsonDecode(response2.body) as List);
      jobTile=[];
      jobTile.add("Select a Type");
      for(var i=0;i<getJobTitle.length;i++){
        jobTile.add(getJobTitle[i][0]);
      }

      _isLoading=false;
    });
  }
  bool _isLoading=false;


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.


    return new Scaffold(

        appBar: new AppBar(
          title: new Text('Add Item'),
          elevation: 0.0,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    // The validator receives the text that the user has entered.
                    // obscureText: true,
                    controller: itemName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Item',
                      //hintText: 'Enter Item',
                    )
                  )),

              Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    // The validator receives the text that the user has entered.
                    // obscureText: true,
                    controller: itemPrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Price',
                      //hintText: 'Enter Item',
                    ),

                  )),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    // The validator receives the text that the user has entered.
                    // obscureText: true,
                    controller: itemQuantity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Quantity',
                      //hintText: 'Enter Item',
                    ),

                  )),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: itemDescription,
                  maxLines: 8, //or null
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Description',
                    //hintText: 'Enter Item',
                  ),

                ),
              ),
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
                onChanged: (String? newValue) async{
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                  await getJobTitle();
                },
              )),
              if(dropdownvalue=="Arts And Paintings")...[
              Padding(
                  padding: EdgeInsets.all(15),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),

                      //hintText: 'Enter Item',
                    ),
                    // Initial Value
                    value: dropdownvalue2,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: jobTile.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue2 = newValue!;
                      });
                    },
                  )),
              ],
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
                          child: Text("Open Images")
                      )
                  )
              ),

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
                  : Container(),

              Padding(
                  padding: EdgeInsets.all(15),
                  child: SizedBox(
                    // width: 200, // <-- Your width
                    height: 40, // <-- Your height
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        try {
                          if (itemName.value.text=='' && itemPrice.value.text=='' && itemDescription.value.text==''&& itemQuantity.value.text=='' ) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("item name , price , description,  Quantity fields are mendatory fields "
                                 ),
                            ));
                          }else if(imagefiles!.length==0){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  " Need to select minimum one image"),
                            ));
                          }else{
                            var id = await uploadItem(
                                itemName.value.text,
                                itemPrice.value.text,
                                itemQuantity.value.text,
                                itemDescription.value.text);
                            for (int i = 0; i < imagefiles!.length; i++) {
                              await uploadImage(File(imagefiles![i].path), id,i+1);
                            }

                            await machinelearningimages(id);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Item Added Successfully"),
                            ));
                            Navigator.pop(context);
                          }
                          // Navigator.pop(context);

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Item Not  Added"),
                          ));
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  )),

              //open button ----------------

              // Divider(),
              // Text("Picked Files:"),
              // Divider(),
            ],
          ),
        ));
  }
}
