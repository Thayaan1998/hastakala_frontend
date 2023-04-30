import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Cart.dart';
import 'package:fyp/shopowner/viewAppliedPeople.dart';
import 'package:fyp/object/Job.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';

// Create a Form widget.
class GetVacanciesByVendor extends StatefulWidget {
  const GetVacanciesByVendor({Key? key}) : super(key: key);

  @override
  GetVacanciesByVendorState createState() {
    return GetVacanciesByVendorState();
  }
}

class GetVacanciesByVendorState extends State<GetVacanciesByVendor> {
  static List<Job>? vacancies = [];

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
      Uri.parse(Config.mainUrl + '/getVacanciesByVendorId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'vendorId': Config.vendorId.toString()}),
    );
    setState(() {
      vacancies = (jsonDecode(response2.body) as List)
          .map((e) => Job.fromList(e))
          .cast<Job>()
          .toList();
      _isLoading = false;
    });
  }

  updateVacancies() async {
    setState(() {
      _isLoading = true;
    });
    for(int i=0;i<vacancies!.length;i++){
      if(vacancies![i].checked){
        final response = await http.post(
          Uri.parse(Config.mainUrl + '/updateVacancies'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'jobDescriptionId': vacancies![i].JobDescriptionId.toString()
          }),
        );
      }
      setState(() {
        _isLoading = false;
      });

    }


    // return response.body;
  }

  bool checkedValue = false;
  var _isLoading = false;

  Widget AskToResendImage(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Do You Want to Delete This Vacancy'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await updateVacancies();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Vacancies Deleted Successfully"),
            ));

            await _loadDatas();


            Navigator.of(context).pop();

          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Yes'),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('No'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Vacancies'),
          // automaticallyImplyLeading: false,
        ),
        body: _isLoading
            ? CircularProgressIndicator()
            : CustomScrollView(slivers: [
                SliverToBoxAdapter(
                    child: SizedBox(
                  // height: 100.0,
                  child: ListView.builder(
                      itemCount: vacancies!.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return new GestureDetector(
                            onTap: () => {
                                Config.getJobVacancyId =
                                      vacancies![index].JobDescriptionId,
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const ViewAppliedPeople()),
                                  )
                                },
                            child: Container(
                                child: Card(
                                    elevation: 20,
                                    margin: EdgeInsets.all(10),
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                // color: Colors.blue,
                                                //   width: 200,
                                                //   height: 150,

                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Row(children: <
                                                              Widget>[
                                                            Text("Job Title: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left),
                                                            Text(
                                                                vacancies![
                                                                        index]
                                                                    .jobTitle,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left)
                                                          ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Row(children: <
                                                              Widget>[
                                                            Text("Category: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left),
                                                            Text(
                                                                vacancies![
                                                                        index]
                                                                    .category,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left)
                                                          ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    vacancies![
                                                                                index]
                                                                            .year +
                                                                        '/' +
                                                                        vacancies![index]
                                                                            .month +
                                                                        '/' +
                                                                        vacancies![index]
                                                                            .day
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left)
                                                              ])),
                                                    ]),
                                              ),
                                              Checkbox(
                                                value:
                                                    vacancies![index].checked,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    vacancies![index].checked =
                                                        newValue!;
                                                  });
                                                },
                                              )
                                            ])))));
                      }),
                )),
          SliverToBoxAdapter(
              child: Padding(
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                AskToResendImage(context),
                          );


                        },
                        icon: Icon(Icons.delete),
                        //icon data for elevated button
                        label: Text("Delete Vacancies"),
                      ))))
              ]));
  }
}
