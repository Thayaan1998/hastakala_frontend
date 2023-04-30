import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/db/userDB.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/shopowner/makeCustomize.dart';
import 'package:fyp/shopowner/jobVacancies.dart';



// Create a Form widget.
class Accounts2 extends StatefulWidget {
  const Accounts2({Key? key}) : super(key: key);

  @override
  Accounts2State createState() {
    return Accounts2State();
  }
}

class Accounts2State extends State<Accounts2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUser();
    });
  }

  String name = '';
  String phonenumber = '';
  String address = '';
  String imageurl = '';

  _loadUser() async {
    setState(() {

      _isLoading=true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getUserDetailsByUserId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
      jsonEncode(<String, String>{'userId': Config.vendorId.toString()}),
    );
    setState(() {
      var list = (jsonDecode(response2.body) as List);
      name = list[1];
      phonenumber = list[2];
      address = list[3];
      imageurl = list[5];
      _isLoading=false;
    });
  }
  var _isLoading = false;

  Widget logoutDialog(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Logout System'),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: ()  {
            userDB userDb=new userDB();
            userDb.deleteUser(Config.vendorId);
            Navigator.pushNamed(
                context,
                '/'
            );

          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('yes'),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('cancel'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        automaticallyImplyLeading: false,
      ),
      body:
      _isLoading
          ? CircularProgressIndicator()
          : CustomScrollView(slivers: [
        SliverToBoxAdapter(
            child: SizedBox(
              // height: 100.0,
                child: Container(
                    child: Card(
                        elevation: 20,
                        margin: EdgeInsets.all(10),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(children: <Widget>[
                              imageurl==''
                                  ? Container()
                                  :
                              Container(
                                  child: CircleAvatar(
                                    radius: 70,
                                    child: ClipOval(
                                      child: Image.network(
                                        Config.mainUrl +
                                            "/getFile?path=" +
                                            imageurl,
                                        width: 500,
                                        height: 500,
                                      ),
                                    ),
                                  )
                              ),
                              Container(
                                // color: Colors.blue,
                                //   width: 200,
                                //   height: 150,

                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          //apply padding to all four sides
                                          child: Text(name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          //apply padding to all four sides
                                          child: Text(phonenumber,
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          //apply padding to all four sides
                                          child: Text(address,
                                              textAlign: TextAlign.left),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child: ButtonTheme(
                                                minWidth: 100.0,
                                                child: ElevatedButton.icon(

                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: Theme
                                                          .of(context)
                                                          .primaryColor),

                                                  onPressed: () async {
                                                    print("thayaan");
                                                  },
                                                  icon: Icon(Icons.edit),
                                                  //icon data for elevated button
                                                  label: Text("Edit Profile"),
                                                )
                                            )
                                        ),]))
                            ])))))),
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  // width: 200, // <-- Your width
                    height: 40, // <-- Your height
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              logoutDialog(context),
                        );
                      },
                      icon: Icon(Icons.logout),
                      //icon data for elevated button
                      label: Text("Logout"),
                    )))),
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  // width: 200, // <-- Your width
                    height: 40, // <-- Your height
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MakeCustomize()),
                        );
                      },
                      icon: Icon(Icons.dashboard_customize),
                      //icon data for elevated button
                      label: Text("Customize Product"),
                    )))),
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  // width: 200, // <-- Your width
                    height: 40, // <-- Your height
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JobVacancies()),
                        );
                      },
                      icon: Icon(Icons.work),
                      //icon data for elevated button
                      label: Text("Job Vacancies"),
                    ))))
      ]),
    );
  }
}
