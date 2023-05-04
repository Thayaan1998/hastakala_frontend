import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Shop.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/customer/getItemsByShop.dart';


class NormalShopsSearch extends StatefulWidget {
  const NormalShopsSearch({Key? key}) : super(key: key);

  @override
  NormalShopsSearchState createState() {
    return NormalShopsSearchState();
  }
}

class NormalShopsSearchState extends State<NormalShopsSearch> {
  var _isLoading = false;
  // String dropdownvalue = 'Select a Category';

  List<Shop>? customizeShops = [];

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
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getShops'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    setState(() {
      customizeShops = (jsonDecode(response2.body) as List)
          .map((e) => Shop.fromList(e))
          .cast<Shop>()
          .toList();
      _isLoading = false;
    });
  }

  _loadDatas2(type) async {
    setState(() {
      _isLoading = true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getShopsByName'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name':type}),
    );
    setState(() {
      customizeShops = (jsonDecode(response2.body) as List)
          .map((e) => Shop.fromList(e))
          .cast<Shop>()
          .toList();
      _isLoading = false;
    });
  }

  TextEditingController shopsSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shops'),
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
                  controller: shopsSearch,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search Shops',
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
                                    await _loadDatas2(shopsSearch.value.text);
                                  },
                                  icon: Icon(Icons.search),
                                  //icon data for elevated button
                                  label: Text(""),
                                )))
                      ])),
              if (customizeShops!.length != 0) ...[

                SliverToBoxAdapter(
                    child: SizedBox(
                      // height: 100.0,
                      child: ListView.builder(
                          itemCount: customizeShops!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin:EdgeInsets.all(20.0),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                child: InkWell(
                                  onTap: () => {
                                    Config.shopId=customizeShops![index].shopId,
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => const GetItemsByShop()),
                                  ),
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        child: Image.network(
                                            Config.mainUrl +
                                                "/getFile?path=" +
                                                customizeShops![index].imageUrl,
                                            // width: 300,
                                            height: 200,
                                            fit:BoxFit.fill

                                        ),
                                      ),
                                      ListTile(
                                        title: Text(  customizeShops![index]
                                            .shopName),
                                        subtitle: Text(   customizeShops![index]
                                            .address),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ))
              ] else ...[
                SliverToBoxAdapter(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("")))
              ]
            ])));
  }
}
