import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/shopowner/pdfViewer.dart';
import 'package:fyp/object/Driver.dart';

import 'package:http/http.dart' as http;

class ViewAppliedPeople extends StatefulWidget {
  const ViewAppliedPeople({Key? key}) : super(key: key);

  @override
  ViewAppliedPeopleState createState() {
    return ViewAppliedPeopleState();
  }
}

class ViewAppliedPeopleState extends State<ViewAppliedPeople> {
  List<Driver>? userDetails = [];

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
      Uri.parse(Config.mainUrl + '/getAppliedPeople'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'jobDescriptionId': Config.getJobVacancyId.toString()
      }),
    );
    // print(response2.body);
    setState(() {
      userDetails = (jsonDecode(response2.body) as List)
          .map((e) => Driver.fromList(e))
          .cast<Driver>()
          .toList();
      _isLoading = false;
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Applied Peoples'),
          // automaticallyImplyLeading: false,
        ),
        body: _isLoading
            ? CircularProgressIndicator()
            : CustomScrollView(slivers: [
                SliverToBoxAdapter(
                    child: SizedBox(
                  // height: 100.0,
                  child: ListView.builder(
                      itemCount: userDetails!.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return new GestureDetector(
                            onTap: () => {
                                  // Config.getPerticularDeliverId =
                                  //     userDetails![index].deliverId,
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //       const OnTrackDelivery()),
                                  // )
                                },
                            child: Container(
                                child: Card(
                                    elevation: 20,
                                    margin: EdgeInsets.all(20),
                                    child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(15),
                                                //apply padding to all four sides
                                                child: Text(
                                                    "Name : " +
                                                        userDetails![index]
                                                            .name
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                    textAlign: TextAlign.left),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(15),
                                                //apply padding to all four sides
                                                child: Text(
                                                    "Address : " +
                                                        userDetails![index]
                                                            .address
                                                            .toString(),
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.left),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(15),
                                                //apply padding to all four sides
                                                child: Text(
                                                    "Phonenumber : " +
                                                        userDetails![index]
                                                            .phoneNumber
                                                            .toString(),
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.left),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(15),
                                                  //apply padding to all four sides
                                                  child: SizedBox(
                                                      // width: 200, // <-- Your width
                                                      height: 40,
                                                      // <-- Your height
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                          onPressed: () async {
                                                            // Config.orderStatus="Ongoing";

                                                            Config.cvUrl=Config.mainUrl+"/getFile2?path="+ userDetails![index]
                                                                .imageUrl;

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const PdfViewer()),
                                                            );
                                                          },
                                                          child: Text(
                                                              "View Cv"))))
                                            ])))));
                      }),
                ))
              ]));
  }
}
