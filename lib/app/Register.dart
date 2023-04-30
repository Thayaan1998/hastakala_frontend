import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/customer/home2.dart';
import 'package:fyp/db/User.dart';
import 'package:fyp/db/userDB.dart';
import 'package:fyp/drivers/home3.dart';
import 'package:fyp/shopowner/Home.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';



class Register extends StatefulWidget {



  const Register({Key? key}) : super(key: key);



  @override
  _RegisterState createState() =>
      _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController nameText = TextEditingController();
  TextEditingController addressText = TextEditingController();
  var phonenumber = TextEditingController();

  @override
  void initState() {
    phonenumber.text= Config.phonenumber;

    super.initState();

  }


  var imageFile;
  uploadUserImage(File imageFile, var id) async {
    try {
      var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse(Config.mainUrl+"/uploadUserImage");
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('photo', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        var response2 = await http.post(
          Uri.parse(Config.mainUrl+'/addUserImage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'userId': id, 'imageUrl': value}),
        );
        // return response2.body.toString();
      });
      return "success";
    } catch (e) {
      return "Unsuccess";
    }
  }

  addUser(name, phoneNumber, address, type) async {
    final response = await http.post(
      Uri.parse(Config.mainUrl+'/addUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name.toString(),
        'phoneNumber': phoneNumber.toString(),
        'address': address.toString(),
        'type': type.toString()
      }),
    );
    return response.body;
  }


  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;


    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:  Text(arguments['title'].toString()),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      // The validator receives the text that the user has entered.
                      // obscureText: true,
                        controller: nameText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: arguments['name'].toString(),
                          //hintText: 'Enter Item',
                        )
                    )),
                //
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      // The validator receives the text that the user has entered.
                      // obscureText: true,
                        controller: phonenumber,
                        enabled: false,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Phonumber",
                          //hintText: 'Enter Item',
                        )
                    )),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      // The validator receives the text that the user has entered.
                      // obscureText: true,
                        controller: addressText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: arguments['address'].toString(),
                          //hintText: 'Enter Item',
                        )
                    )),
                ElevatedButton(
                  // color: Colors.greenAccent,
                  onPressed: () {
                    _getFromGallery();
                  },
                  child: Text( arguments['pick'].toString()+" from gallery"),
                ),
                Container(
                  height: 40.0,
                ),
                ElevatedButton(
                  //color: Colors.lightGreenAccent,
                  onPressed: () {
                    _getFromCamera();
                  },
                  child: Text(arguments['pick'].toString()+" from camera"),
                ),
                imageFile != null
                    ? Container(
                  child: Image.file(
                    imageFile,
                    height: 200,
                    width: 200,
                    // fit: BoxFit.cover,
                  ),
                ) : Container(),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                      // width: 200, // <-- Your width
                      height: 40, // <-- Your height
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()  async {

                          if(nameText.value.text==''){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Please "+arguments['name'].toString()),
                            ));
                          }else
                          if(addressText.value.text.length<12){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  " Not Valid Phonenumber"),
                            ));
                          }else if(addressText.value.text==''){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Please "+arguments['address'].toString()),
                            ));
                          }else if(imageFile==null){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Please Select Image"),
                            ));
                          }else{
                            var id =  await addUser(nameText.value.text , phonenumber.value.text, addressText.value.text,arguments['userType'].toString());
                            await uploadUserImage( imageFile,  id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("User Registered successfully"),
                            ));

                            userDB userDb=new userDB();
                            userDb.insertUser(new User( userId:int.parse(id),type:arguments['userType'].toString()));

                            if(arguments['userType'].toString()=='vendor'){
                              Config.vendorId=int.parse(id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()
                                ),
                              );
                            }else if(arguments['userType'].toString()=='customer'){
                              Config.customerId=int.parse(id);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home2()
                                ),
                              );
                            }else if(arguments['userType'].toString()=='driver') {
                              Config.driverId=int.parse(id);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home3()
                                ),
                              );
                            }



                            }
                        },
                        child: const Text('Register'),
                      ),
                    ))

              ],
            )));


  }
  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
