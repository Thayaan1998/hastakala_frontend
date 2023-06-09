import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Item.dart';
import 'package:http/http.dart' as http;

// Create a Form widget.
class GetItemsByShop extends StatefulWidget {
  const GetItemsByShop({Key? key}) : super(key: key);

  @override
  GetItemsByShopState createState() {
    return GetItemsByShopState();
  }
}

class GetItemsByShopState extends State<GetItemsByShop> {
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
      Uri.parse(Config.mainUrl + '/getItemByVendor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'vendorId': Config.shopId.toString()}),
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
