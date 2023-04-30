import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/customer/getItemForOrder.dart';
import 'package:fyp/customer/getItemsByType.dart';

import 'package:fyp/object/Comments.dart';
import 'package:fyp/object/Item.dart';
import 'package:http/http.dart' as http;

// Create a Form widget.
class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  ProductsState createState() {
    return ProductsState();
  }
}

class ProductsState extends State<Products> {
  List<Item>? favourites = [];

  List<Item>? itemsLeather = [];

  List<Item>? itemsGlasses = [];

  List<Item>? itemWoods = [];

  List<Item>? itemPapers = [];

  List<Item>? itemClayAndPotery = [];




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();

    });
  }

  _loadDatas() async {

    setState(() {
      _isLoading=true;
    });

    await _loadFavourites();

    await _loadLeatherItems();

    await _loadGlassItems();

    await _loadWoodItems();

    await _loadPaperItems();

    await _loadClayAndPotery();

    setState(() {
      _isLoading=false;
    });


  }

  _loadFavourites() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemByFavourites'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'userId': Config.customerId.toString()}),
    );


    setState(()  {
      favourites = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();


    });

  }



   var _isLoading=false;
  _makeFavourite(itemId) async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemByUserIdAndItemId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemId': itemId.toString(),'userId': Config.customerId.toString()}),
    );
    return response2.body.toString();
  }

  _loadLeatherItems() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemType'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemType': 'leather'}),
    );


    setState(() {
      itemsLeather = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for(var i=0;i<favourites!.length;i++){
        for(var j=0;j<itemsLeather!.length;j++) {
          if(favourites![i].itemId==itemsLeather![j].itemId){
            itemsLeather![j].favourites='yes';
          }

        }
      }

    });
  }

  _loadGlassItems() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemType'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemType': 'Glass Crafts'}),
    );


    setState(() {
      itemsGlasses = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for(var i=0;i<favourites!.length;i++){
        for(var j=0;j<itemsGlasses!.length;j++) {
          if(favourites![i].itemId==itemsGlasses![j].itemId){
            itemsGlasses![j].favourites='yes';
          }

        }
      }

    });
  }

  _loadWoodItems() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemType'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemType': 'Woods Crafts'}),
    );


    setState(() {
      itemWoods = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for(var i=0;i<favourites!.length;i++){
        for(var j=0;j<itemWoods!.length;j++) {
          if(favourites![i].itemId==itemWoods![j].itemId){
            itemWoods![j].favourites='yes';
          }

        }
      }

    });
  }

  _loadPaperItems() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemType'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemType': 'Paper Crafts'}),
    );


    setState(() {
      itemPapers = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for(var i=0;i<favourites!.length;i++){
        for(var j=0;j<itemPapers!.length;j++) {
          if(favourites![i].itemId==itemPapers![j].itemId){
            itemPapers![j].favourites='yes';
          }

        }
      }

    });
  }

  _loadClayAndPotery() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getItemType'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemType': 'Clay and Pottery'}),
    );


    setState(() {
      itemClayAndPotery = (jsonDecode(response2.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for(var i=0;i<favourites!.length;i++){
        for(var j=0;j<itemClayAndPotery!.length;j++) {
          if(favourites![i].itemId==itemClayAndPotery![j].itemId){
            itemClayAndPotery![j].favourites='yes';
          }

        }
      }

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          // automaticallyImplyLeading: false,

        ),
        body: Container(
            color: Colors.white,
            child:_isLoading
                ? CircularProgressIndicator()
                : CustomScrollView(slivers: [
              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child:InkWell(
                        onTap: () {
                          Config.itemType='Leather';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GetItemsByType()),
                          );
                        },
                      child: Text(
                        'Leathers ➩',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )))),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 228.0,
                  width: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemsLeather!.length,
                    itemBuilder: (context2, index) {
                      return new GestureDetector(
                          onTap: () => {

                            Config.itemId= itemsLeather![index].itemId,
                            Navigator.pushNamed(
                              context,
                              '/getItemForOrder',
                              arguments: {'itemId': itemsLeather![index].itemId,
                                'itemName':itemsLeather![index].itemName,
                                'description':itemsLeather![index].description,
                                'price':itemsLeather![index].price
                              },
                            )
                          },
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
                                          //   width: 150,
                                          //   height: 150,
                                          child: Center(
                                              child: Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(Config.mainUrl +
                                            "/getFile?path=" +
                                            itemsLeather![index].imageUrl),
                                      ))),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(70, 0, 0, 0),
                                          child: IconButton(
                                              onPressed: () async{
                                                setState(() {
                                                  _isLoading=true;
                                                });
                                                await _makeFavourite( itemsLeather![index].itemId);
                                                await _loadFavourites();
                                                await _loadLeatherItems();
                                                setState(() {
                                                  _isLoading=false;
                                                });
                                              },
                                              icon: Icon(Icons.favorite),
                                              alignment: Alignment.topRight,
                                              color:itemsLeather![index].favourites==''? Colors.black12:Colors.red)
                                      ),
                                    ]))),
                          ));
                    },
                  ),
                ),
              ),


              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child:InkWell(
                          onTap: () {
                            Config.itemType='Glass Crafts';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GetItemsByType()),
                            );
                          },
                          child: Text(
                            'Glass Crafts ➩',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )))),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 228.0,
                  width: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemsGlasses!.length,
                    itemBuilder: (context2, index) {
                      return new GestureDetector(
                          onTap: () => {

                            Config.itemId= itemsGlasses![index].itemId,
                            Navigator.pushNamed(
                              context,
                              '/getItemForOrder',
                              arguments: {'itemId': itemsGlasses![index].itemId,
                                'itemName':itemsGlasses![index].itemName,
                                'description':itemsGlasses![index].description,
                                'price':itemsGlasses![index].price
                              },
                            )
                          },
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
                                        //   width: 150,
                                        //   height: 150,
                                          child: Center(
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(Config.mainUrl +
                                                    "/getFile?path=" +
                                                    itemsGlasses![index].imageUrl),
                                              ))),
                                      Container(
                                          margin:
                                          EdgeInsets.fromLTRB(70, 0, 0, 0),
                                          child: IconButton(
                                              onPressed: () async{
                                                setState(() {
                                                  _isLoading=true;
                                                });
                                                await _makeFavourite( itemsGlasses![index].itemId);
                                                await _loadFavourites();
                                                await _loadGlassItems();
                                                setState(() {
                                                  _isLoading=false;
                                                });
                                              },
                                              icon: Icon(Icons.favorite),
                                              alignment: Alignment.topRight,
                                              color:itemsGlasses![index].favourites==''? Colors.black12:Colors.red)
                                      ),
                                    ]))),
                          ));
                    },
                  ),
                ),
              ),


              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child:InkWell(
                          onTap: () {
                            Config.itemType='Woods Crafts';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GetItemsByType()),
                            );
                          },
                          child: Text(
                            'Woods Crafts ➩',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )))),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 228.0,
                  width: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemWoods!.length,
                    itemBuilder: (context2, index) {
                      return new GestureDetector(
                          onTap: () => {

                            Config.itemId= itemWoods![index].itemId,
                            Navigator.pushNamed(
                              context,
                              '/getItemForOrder',
                              arguments: {'itemId': itemWoods![index].itemId,
                                'itemName':itemWoods![index].itemName,
                                'description':itemWoods![index].description,
                                'price':itemWoods![index].price
                              },
                            )
                          },
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
                                        //   width: 150,
                                        //   height: 150,
                                          child: Center(
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(Config.mainUrl +
                                                    "/getFile?path=" +
                                                    itemWoods![index].imageUrl),
                                              ))),
                                      Container(
                                          margin:
                                          EdgeInsets.fromLTRB(70, 0, 0, 0),
                                          child: IconButton(
                                              onPressed: () async{
                                                setState(() {
                                                  _isLoading=true;
                                                });
                                                await _makeFavourite( itemWoods![index].itemId);
                                                await _loadFavourites();
                                                await _loadWoodItems();
                                                setState(() {
                                                  _isLoading=false;
                                                });
                                              },
                                              icon: Icon(Icons.favorite),
                                              alignment: Alignment.topRight,
                                              color:itemWoods![index].favourites==''? Colors.black12:Colors.red)
                                      ),
                                    ]))),
                          ));
                    },
                  ),
                ),
              ),



              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child:InkWell(
                          onTap: () {
                            Config.itemType='Paper Crafts';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GetItemsByType()),
                            );
                          },
                          child: Text(
                            'Paper Crafts ➩',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )))),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 228.0,
                  width: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemPapers!.length,
                    itemBuilder: (context2, index) {
                      return new GestureDetector(
                          onTap: () => {

                            Config.itemId= itemPapers![index].itemId,
                            Navigator.pushNamed(
                              context,
                              '/getItemForOrder',
                              arguments: {'itemId': itemPapers![index].itemId,
                                'itemName':itemPapers![index].itemName,
                                'description':itemPapers![index].description,
                                'price':itemPapers![index].price
                              },
                            )
                          },
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
                                        //   width: 150,
                                        //   height: 150,
                                          child: Center(
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(Config.mainUrl +
                                                    "/getFile?path=" +
                                                    itemPapers![index].imageUrl),
                                              ))),
                                      Container(
                                          margin:
                                          EdgeInsets.fromLTRB(70, 0, 0, 0),
                                          child: IconButton(
                                              onPressed: () async{
                                                setState(() {
                                                  _isLoading=true;
                                                });
                                                await _makeFavourite( itemPapers![index].itemId);
                                                await _loadFavourites();
                                                await _loadPaperItems();
                                                setState(() {
                                                  _isLoading=false;
                                                });
                                              },
                                              icon: Icon(Icons.favorite),
                                              alignment: Alignment.topRight,
                                              color:itemPapers![index].favourites==''? Colors.black12:Colors.red)
                                      ),
                                    ]))),
                          ));
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child:InkWell(
                          onTap: () {
                            Config.itemType='Clay and Pottery';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GetItemsByType()),
                            );
                          },
                          child: Text(
                            'Clay and Pottery ➩',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )))),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 228.0,
                  width: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemClayAndPotery!.length,
                    itemBuilder: (context2, index) {
                      return new GestureDetector(
                          onTap: () => {

                            Config.itemId= itemClayAndPotery![index].itemId,
                            Navigator.pushNamed(
                              context,
                              '/getItemForOrder',
                              arguments: {'itemId': itemClayAndPotery![index].itemId,
                                'itemName':itemClayAndPotery![index].itemName,
                                'description':itemClayAndPotery![index].description,
                                'price':itemClayAndPotery![index].price
                              },
                            )
                          },
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
                                        //   width: 150,
                                        //   height: 150,
                                          child: Center(
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(Config.mainUrl +
                                                    "/getFile?path=" +
                                                    itemClayAndPotery![index].imageUrl),
                                              ))),
                                      Container(
                                          margin:
                                          EdgeInsets.fromLTRB(70, 0, 0, 0),
                                          child: IconButton(
                                              onPressed: () async{
                                                setState(() {
                                                  _isLoading=true;
                                                });
                                                await _makeFavourite( itemClayAndPotery![index].itemId);
                                                await _loadFavourites();
                                                await _loadClayAndPotery();
                                                setState(() {
                                                  _isLoading=false;
                                                });
                                              },
                                              icon: Icon(Icons.favorite),
                                              alignment: Alignment.topRight,
                                              color:itemClayAndPotery![index].favourites==''? Colors.black12:Colors.red)
                                      ),
                                    ]))),
                          ));
                    },
                  ),
                ),
              ),

            ])));
  }
}
