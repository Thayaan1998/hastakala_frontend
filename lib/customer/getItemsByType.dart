import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Item.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';

// Create a Form widget.
class GetItemsByType extends StatefulWidget {
  const GetItemsByType({Key? key}) : super(key: key);

  @override
  GetItemsByTypeState createState() {
    return GetItemsByTypeState();
  }
}

class GetItemsByTypeState extends State<GetItemsByType> {
  List<Item>? items = [];
  List<Item>? favourites = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();
    });
  }

  _loadDatas() async {
    setState(() {
      _isLoading = true;
    });

    await _loadFavourites();

    await _loadItems();

    setState(() {
      _isLoading = false;
    });
  }

  _loadFavourites() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemByFavourites'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'userId': Config.customerId.toString()}),
    );

    setState(() {
      favourites = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
    });
  }

  _loadItems() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemType2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemType': Config.itemType}),
    );

    setState(() {
      items = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for (var i = 0; i < favourites!.length; i++) {
        for (var j = 0; j < items!.length; j++) {
          if (favourites![i].itemId == items![j].itemId) {
            items![j].favourites = 'yes';
          }
        }
      }
    });
  }

  _loadDatas2(type) async {
    setState(() {
      _isLoading = true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemType3'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemType': Config.itemType,
        'itemName': itemSearch.value.text
      }),
    );
    setState(() {
      items = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for (var i = 0; i < favourites!.length; i++) {
        for (var j = 0; j < items!.length; j++) {
          if (favourites![i].itemId == items![j].itemId) {
            items![j].favourites = 'yes';
          }
        }
      }
      _isLoading = false;
    });
  }

  _loadDatas3(type) async {
    setState(() {
      _isLoading = true;
    });
    print(type);
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemType4'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemType': Config.itemType,
        'type': type
      }),
    );
    setState(() {
      items = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for (var i = 0; i < favourites!.length; i++) {
        for (var j = 0; j < items!.length; j++) {
          if (favourites![i].itemId == items![j].itemId) {
            items![j].favourites = 'yes';
          }
        }
      }
      _isLoading = false;
    });
  }


  var _isLoading = false;

  _makeFavourite(itemId) async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemByUserIdAndItemId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemId': itemId.toString(),
        'userId': Config.customerId.toString()
      }),
    );
    return response2.body.toString();
  }

  /// Get from gallery
  var imageFile;

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

  uploadSearchImage(File imageFile) async {
    try {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse(Config.mainUrl + "/predict");
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('photo', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        var type="";
        if(value=="0"){
          type="drawings";
        }else if(value=="1"){
          type="engraving";
        }else if(value=="2"){
          type="iconography";
        }else if(value=="3"){
          type="sculpture";
        }
        await _loadDatas3(type);
      });
      return "success";
    } catch (e) {
      return "Unsuccess";
    }
  }

  TextEditingController itemSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Config.itemType + " Items"),
          // automaticallyImplyLeading: false,
        ),
        body: Container(
            color: Colors.white,
            child: _isLoading
                ? CircularProgressIndicator()
                : CustomScrollView(slivers: [
                    SliverToBoxAdapter(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: SizedBox(
                                  width: 200, // <-- Your width
                                  height: 60,
                                  child: TextField(
                                    // The validator receives the text that the user has entered.
                                    // obscureText: true,
                                    controller: itemSearch,
                                    // keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Search Item',
                                      //hintText: 'Enter Item',
                                    ),
                                  ))),
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: SizedBox(
                                  width: 60, // <-- Your width
                                  height: 60, // <-- Your height
                                  // width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    onPressed: () async {
                                      if (itemSearch.value.text == "") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Please Enter Item Name"),
                                        ));
                                      } else {
                                        await _loadDatas2(itemSearch);
                                      }
                                    },
                                    icon: Icon(Icons.search),
                                    //icon data for elevated button
                                    label: Text(""),
                                  )))
                        ])),
                    if(Config.itemType=="Arts And Paintings")...[
                      SliverToBoxAdapter(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(15),
                                    child: SizedBox(
                                      // width: 200, // <-- Your width
                                      width: 200, // <-- Your width
                                      height: 60,

                                      child: ElevatedButton(
                                        onPressed: () {
                                          _getFromGallery();
                                        },
                                        child: const Text('Open Images'),
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: SizedBox(
                                        width: 60, // <-- Your width
                                        height: 60, // <-- Your height
                                        // width: double.infinity,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                              Theme.of(context).primaryColor),
                                          onPressed: () async {
                                            uploadSearchImage(imageFile);
                                          },
                                          icon: Icon(Icons.search),
                                          //icon data for elevated button
                                          label: Text(""),
                                        )))
                              ])),
                      imageFile != null
                          ? SliverToBoxAdapter(
                        child: Container(
                            child: Image.file(
                              imageFile,
                              height: 100,
                              width: 100,
                              // fit: BoxFit.cover,
                            )),
                      )
                          : SliverToBoxAdapter(child: Container()),
                    ],
                    SliverToBoxAdapter(
                        child: SizedBox(
                            child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.6),
                      ),
                      itemCount: items!.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return new GestureDetector(
                            onTap: () => {
                                  Config.itemId = items![index].itemId,
                                  Navigator.pushNamed(
                                    context,
                                    '/getItemForOrder',
                                    arguments: {
                                      'itemId': items![index].itemId,
                                      'itemName': items![index].itemName,
                                      'description': items![index].description,
                                      'price': items![index].price
                                    },
                                  )
                                },
                            child: SizedBox(
                                height: 100.0,
                                child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(children: <Widget>[
                                          Container(
                                              height: 150,

                                              // color: Colors.blue,
                                              //   width: 150,
                                              //   height: 150,
                                              child: Center(
                                                  child: Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                    Config.mainUrl +
                                                        "/getFile?path=" +
                                                        items![index].imageUrl),
                                              ))),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  70, 0, 0, 0),
                                              child: IconButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    await _makeFavourite(
                                                        items![index].itemId);
                                                    await _loadFavourites();
                                                    await _loadItems();
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  },
                                                  icon: Icon(Icons.favorite),
                                                  alignment: Alignment.topRight,
                                                  color: items![index]
                                                              .favourites ==
                                                          ''
                                                      ? Colors.black12
                                                      : Colors.red)),
                                        ])))));
                      },
                    ))),
                  ])));
  }
}
