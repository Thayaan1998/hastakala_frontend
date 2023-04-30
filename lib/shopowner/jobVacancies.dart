import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';

import 'package:fyp/shopowner/addJobVacancies.dart';
import 'package:fyp/shopowner/getVacanciesByVendor.dart';





class JobVacancies extends StatefulWidget {
  const JobVacancies({Key? key}) : super(key: key);

  @override
  JobVacanciesState createState() {
    return JobVacanciesState();
  }
}

class JobVacanciesState extends State<JobVacancies> {
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Vacancies'),
        // automaticallyImplyLeading: false,
      ),
      body :_isLoading
          ? CircularProgressIndicator()
          : CustomScrollView(slivers: [
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  // width: 200, // <-- Your width
                    height: 40, // <-- Your height
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).primaryColor),
                        onPressed: () async {

                          // Config.orderStatus="Added";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const AddJobVacancies()),
                          );

                        },
                        child: Text("Add My Job Vacancies"))))),

        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  // width: 200, // <-- Your width
                    height: 40, // <-- Your height
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).primaryColor),
                        onPressed: () async {
                          // Config.orderStatus="Ongoing";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetVacanciesByVendor()),
                          );


                        },
                        child: Text("View My Job Vacancies"))))),

      ]),
    );
  }
}
