import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:fyp/config.dart';

// Create a Form widget.
class AddJobVacancies extends StatefulWidget {
  const AddJobVacancies({Key? key}) : super(key: key);

  @override
  AddJobVacanciesState createState() {
    return AddJobVacanciesState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddJobVacanciesState extends State<AddJobVacancies> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles=[];

  // Initial Selected Value
  String dropdownvalue = 'Select a Category';

  String dropdownvalue2 = 'Select a JobTitle';


  // List of items in our dropdown menu
  var items = Config.items;

  var jobTile=['Select a JobTitle'];

  final _formKey = GlobalKey<FormState>();
  TextEditingController itemName = TextEditingController();
  TextEditingController itemPrice = TextEditingController();
  TextEditingController itemQuantity = TextEditingController();
  TextEditingController itemDescription = TextEditingController();



  uploadJobvacancies() async {
    DateTime now = new DateTime.now();

    final response = await http.post(
      Uri.parse(Config.mainUrl+'/addJobVacancies'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'vendorId': Config.vendorId.toString(),
        'description': itemDescription.value.text,
        'vendorId': Config.vendorId.toString(),
        'category': dropdownvalue,
        'jobTitle': dropdownvalue2,
        'status': 'Active',
        'Month':now.month.toString(),
        'Year':now.year.toString(),
        'day':now.day.toString(),

      }),
    );
    return response.body;
  }

  getJobTitle() async {
    setState(() {
      _isLoading=true;
    });
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getJobTitle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'category':dropdownvalue}),
    );
    // print(response2.body);
    setState(() {
      var getJobTitle = (jsonDecode(response2.body) as List);
      jobTile=[];
      jobTile.add("Select a JobTitle");
      for(var i=0;i<getJobTitle.length;i++){
        jobTile.add(getJobTitle[i][0]);
      }

      _isLoading=false;
    });
  }
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.


    return new Scaffold(

        appBar: new AppBar(
          title: new Text('Add Job Vacancies'),
          elevation: 0.0,
          backgroundColor: Colors.blue,
        ),
        body: _isLoading
            ? CircularProgressIndicator():
        SingleChildScrollView(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


              Padding(
                  padding: EdgeInsets.all(15),
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
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) async{
                      setState(()  {
                        dropdownvalue = newValue!;

                      });
                      await getJobTitle();
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),

                      //hintText: 'Enter Item',
                    ),
                    // Initial Value
                    value: dropdownvalue2,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: jobTile.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue2 = newValue!;
                      });
                    },
                  )),

              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: itemDescription,
                  maxLines: 8, //or null
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Description',
                    //hintText: 'Enter Item',
                  ),

                ),
              ),


              Padding(
                  padding: EdgeInsets.all(15),
                  child: SizedBox(
                    // width: 200, // <-- Your width
                    height: 40, // <-- Your height
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () async {
                        // // Validate returns true if the form is valid, or false otherwise.
                        try {
                           if(dropdownvalue=="Select a Category"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  " Need to select Category"),
                            ));
                          }else if(dropdownvalue2=="Select a JobTitle"){
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                               content: Text(
                                   " Need to select JobTitle"),
                             ));
                           }else if(itemDescription.value.text==""){
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                               content: Text(
                                   "Please Enter Description"),
                             ));
                           }
                           else{
                            var id = await uploadJobvacancies();

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Job Vacancies Added Successfully"),
                            ));
                            Navigator.pop(context);
                          }
                          // Navigator.pop(context);

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Item Not  Added"),
                          ));
                        }
                      },
                      child: const Text('Add Job Vacancies'),
                    ),
                  )),

              //open button ----------------

              // Divider(),
              // Text("Picked Files:"),
              // Divider(),
            ],
          ),
        ));
  }
}
