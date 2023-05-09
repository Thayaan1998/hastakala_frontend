import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/RowMaterial.dart';
import 'package:http/http.dart' as http;

class GetRowMaterials extends StatefulWidget {
  const GetRowMaterials({Key? key}) : super(key: key);

  @override
  GetRowMaterialsState createState() {
    return GetRowMaterialsState();
  }
}

class GetRowMaterialsState extends State<GetRowMaterials> {
  var _isLoading = false;

//  String dropdownvalue = 'Select a Category';

  List<RowMaterial>? jobs = [];

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
      Uri.parse(Config.mainUrl + '/getRowMaterials'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    setState(() {
      jobs = (jsonDecode(response2.body) as List)
          .map((e) => RowMaterial.fromList(e))
          .cast<RowMaterial>()
          .toList();
      _isLoading = false;
    });
  }

  _loadDatas2() async {
    setState(() {
      _isLoading = true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getFilterRowMaterials'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{ 'address': shopsSearch.value.text}),
    );
    setState(() {
      jobs = (jsonDecode(response2.body) as List)
          .map((e) => RowMaterial.fromList(e))
          .cast<RowMaterial>()
          .toList();
      _isLoading = false;
    });
  }

  TextEditingController shopsSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Row Materials'),
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
                                      labelText: 'Search by address',
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
                                       await _loadDatas2();
                                    },
                                    icon: Icon(Icons.search),
                                    //icon data for elevated button
                                    label: Text(""),
                                  )))
                        ])),
                    if (jobs!.length != 0) ...[
                      SliverToBoxAdapter(
                          child: SizedBox(
                        // height: 100.0,
                        child: ListView.builder(
                            itemCount: jobs!.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(20.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: InkWell(
                                    onTap: () => {
                                      // Config.getJobVacancyId =
                                      //     jobs![index].JobDescriptionId,
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const SendMyCV()),
                                      // )
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          //apply padding to all four sides
                                          child: Text(
                                              "Shop Name : " +
                                                  jobs![index].name,
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          //apply padding to all four sides
                                          child: Text(
                                              "Address : " +
                                                  jobs![index].address,
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          //apply padding to all four sides
                                          child: Text(
                                                  jobs![index].description,
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          //apply padding to all four sides
                                          child: Text(
                                              "Phonenumber : " +
                                                  jobs![index].phonenumber,
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.left),
                                        ),
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
                                                    // if(_itemCount==0){
                                                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    //     content: Text("Item quantity is empty"
                                                    //     ),
                                                    //   ));
                                                    // }else{
                                                    //   // showDialog(
                                                    //   //   context: context,
                                                    //   //   builder: (BuildContext context) =>
                                                    //   //       _buildPopupDialog2(context),
                                                    //   // );
                                                    // }

                                                  },
                                                  icon: Icon(Icons.phone),  //icon data for elevated button
                                                  label: Text("Call"),
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ))
                    ] else ...[
                      // SliverToBoxAdapter(
                      //     child: Padding(
                      //         padding: EdgeInsets.all(20),
                      //         child: Text(
                      //             dropdownvalue == 'Select a value' ? "" : "")))
                    ]
                  ])));
  }
}
