import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Job.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/customer/sendMyCv.dart';


class GetJobByCatgory extends StatefulWidget {
  const GetJobByCatgory({Key? key}) : super(key: key);

  @override
  GetJobByCatgoryState createState() {
    return GetJobByCatgoryState();
  }
}

class GetJobByCatgoryState extends State<GetJobByCatgory> {
  var _isLoading = false;
  String dropdownvalue = 'Select a Category';

  List<Job>? jobs = [];

  _loadDatas(type) async {
    setState(() {
      _isLoading = true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getVacanciesByJobCategory'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'category': type}),
    );
    setState(() {
      jobs = (jsonDecode(response2.body) as List)
          .map((e) => Job.fromList(e))
          .cast<Job>()
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Job Vacancies'),
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
                              margin:EdgeInsets.all(20.0),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                child: InkWell(
                                  onTap: () => {
                                    Config.getJobVacancyId=jobs![index].JobDescriptionId,
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => const SendMyCV()),
                                  )
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        //apply padding to all four sides
                                        child: Text(jobs![index].jobTitle,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        //apply padding to all four sides
                                        child: Text("Shop Name : "+jobs![index].name,
                                            style: TextStyle(
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        //apply padding to all four sides
                                        child: Text(
                                            jobs![index].year.toString()+"/"+
                                                jobs![index].month.toString()+"/"+
                                                jobs![index].day.toString(),
                                            textAlign: TextAlign.left),
                                      )
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
