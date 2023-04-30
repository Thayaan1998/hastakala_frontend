import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Item.dart';
import 'package:http/http.dart' as http;

// Create a Form widget.
class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  FavouritesState createState() {
    return FavouritesState();
  }
}

class FavouritesState extends State<Favourites> {
  List<Item>? favourites = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavourites();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        automaticallyImplyLeading: false,
      ),
      body:
      Container(
      color: Colors.white,
    child:_isLoading
    ? CircularProgressIndicator():
     GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.6),
        ),
        itemCount: favourites!.length,
        itemBuilder: (context, index) {
          return new GestureDetector(
              onTap: () => {

                Config.itemId= favourites![index].itemId,
                Navigator.pushNamed(
                  context,
                  '/getItemForOrder',
                  arguments: {'itemId': favourites![index].itemId,
                    'itemName':favourites![index].itemName,
                    'description':favourites![index].description,
                    'price':favourites![index].price
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
                                      child: Image.network(Config.mainUrl +
                                          "/getFile?path=" +
                                          favourites![index].imageUrl),
                                    ))),
                            Container(
                                margin:
                                EdgeInsets.fromLTRB(70, 0, 0, 0),
                                child: IconButton(
                                    onPressed: () async{
                                      setState(() {
                                        _isLoading=true;
                                      });
                                      await _makeFavourite( favourites![index].itemId);
                                      await _loadFavourites();
                                      // await _loadLeatherItems();
                                      setState(() {
                                        _isLoading=false;
                                      });
                                    },
                                    icon: Icon(Icons.favorite),
                                    alignment: Alignment.topRight,
                                    color:Colors.red)),
                          ])))));
        },
      ),
    ));
  }
}
