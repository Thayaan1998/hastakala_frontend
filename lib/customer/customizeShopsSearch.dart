import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Shop.dart';
import 'package:http/http.dart' as http;

class CustomizeShopsSearch extends StatefulWidget {
  const CustomizeShopsSearch({Key? key}) : super(key: key);

  @override
  CustomizeShopsSearchState createState() {
    return CustomizeShopsSearchState();
  }
}

class CustomizeShopsSearchState extends State<CustomizeShopsSearch> {
  var _isLoading = false;
  String dropdownvalue = 'Select a Category';

  List<Shop>? customizeShops = [];

  _loadDatas(type) async {
    setState(() {
      _isLoading = true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeByTypeShops'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'type': type}),
    );
    setState(() {
      customizeShops = (jsonDecode(response2.body) as List)
          .map((e) => Shop.fromList(e))
          .cast<Shop>()
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Customize Products'),
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
                              padding: EdgeInsets.all(20),
                              child: SizedBox(
                                  width: 200,
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
                                    items: Config.items.map((String items) {
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
                                      await _loadDatas(dropdownvalue);
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
                                      Navigator.pushNamed(
                                    context,
                                    '/getPeticualarCustomizeShop',
                                    arguments: {'shopname':customizeShops![index].shopName},
                                    ),},
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
                              child: Text(dropdownvalue == 'Select a value'
                                  ? ""
                                  : "")))
                    ]
                  ])));
  }
}
