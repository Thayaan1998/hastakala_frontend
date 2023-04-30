import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Item.dart';
import 'package:fyp/object/Comments.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

// import 'package:badges/badges.dart';

class GetItemForOrder extends StatefulWidget {
  const GetItemForOrder({Key? key}) : super(key: key);

  @override
  _GetItemForOrderState createState() => _GetItemForOrderState();
}

class _GetItemForOrderState extends State<GetItemForOrder> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDatas();
      //
    });
    _pageController = PageController(viewportFraction: 0.8);
  }

  late PageController _pageController;
  List<String> images = [];
  List<Comments> comments = [];

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 10 : 20;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  Config.mainUrl + "/getFile?path=" + images[pagePosition]))),
    );
  }

  imageAnimation(PageController animation, images, pagePosition) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, widget) {
        print(pagePosition);

        return SizedBox(
          width: 200,
          height: 200,
          child: widget,
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Image.network(images[pagePosition]),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  loadDatas() async{
    setState(() {
      _isLoading = true;
    });
    await getItemByItemId();
    await getRating();
    await getAverageRating();
    await getCommentByItemId();
    await getPerticularCartForUser();
    setState(() {
      _isLoading = false;
    });
  }

  getItemByItemId() async {

    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getItemByItemId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemId': Config.itemId.toString()}),
    );
    // print(response.body);



    setState(() {
      var items = (jsonDecode(response.body) as List)
          .map((e) => Item.fromList(e))
          .cast<Item>()
          .toList();
      for (var j = 0; j < items!.length; j++) {
        images.add(items![j].imageUrl);
      }
    });

    return response.body;
  }

  getCommentByItemId() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getCommentByItem'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemId': Config.itemId.toString()}),
    );
    setState(() {
      comments = (jsonDecode(response.body) as List)
          .map((e) => Comments.fromList(e))
          .cast<Comments>()
          .toList();
    });

    return response.body;
  }

  int _itemCount = 0;

  itemIncrement() {
    setState(() => _itemCount++);
  }

  itemDicrease() {
    if (_itemCount == 0) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //       " ca"),
      // ));
    } else {
      setState(() => _itemCount--);
    }
  }

  String rating = '0';

  makeRating() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/makeRatingByUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemId': Config.itemId.toString(),
        'userId': Config.customerId.toString(),
        'rating': rating
      }),
    );
    print(response.body);
    return response.body;
  }

  addOrUpdateCart() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/addOrUpdateCart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemId': Config.itemId.toString(),
        'userId': Config.customerId.toString(),
        'quantity': _itemCount.toString()
      }),
    );
    print(response.body);
    return response.body;
  }

  enterComment(comment) async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/sendComment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemId': Config.itemId.toString(),
        'userId': Config.customerId.toString(),
        'sendComment': comment
      }),
    );
    print(response.body);
    return response.body;
  }

  getPerticularCartForUser() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getPerticularCartForUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemId': Config.itemId.toString(),
        'userId': Config.customerId.toString()
      }),
    );

    var getQuantity = (jsonDecode(response.body) as List);

    setState(() {
      if (getQuantity.length > 0) {
        _itemCount = getQuantity[0][0];
      }
    });

    return response.body;
  }


  getRating() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/getPerticularRating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'itemId': Config.itemId.toString(),
        'userId': Config.customerId.toString()
      }),
    );

    var getRating = (jsonDecode(response.body) as List);

    setState(() {
      if (getRating.length > 0) {
        rating = getRating[0][3];
      }
    });

    return response.body;
  }

  var averagerating = "0(0)";

  getAverageRating() async {
    final response = await http.post(
      Uri.parse(Config.mainUrl + '/avgRating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'itemId': Config.itemId.toString()}),
    );

    var getAverageRating = (jsonDecode(response.body) as List);

    setState(() {
      if (getAverageRating[0][0] > 0) {
        // rating=getRating[0][3];
        averagerating = getAverageRating[0][1].toString() +
            "(" +
            getAverageRating[0][0].toString() +
            ")";
      }
    });

    return response.body;
  }

  TextEditingController comment = TextEditingController();

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text('Rating Update'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: RatingBar.builder(
                  initialRating: double.parse(rating.toString()),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating1) {
                    setState(() {
                      rating = rating1.toString();
                      // _isLoading=true;
                    });
                  },
                )),
            // Text(rating, style: TextStyle(fontSize: 20)),
          ]),
          Text("Do you want to update this rating"),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            // Navigator.of(context).pop();

            await makeRating();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Rating Updated Successfully"),
            ));

            await getAverageRating();

            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Save'),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).secondaryHeaderColor),
        ),
      ],
    );
  }

  Widget _buildPopupDialog2(BuildContext context) {
    return new AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      title: const Text(''),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         Text("Do you want to update the cart"),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            await addOrUpdateCart();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Item Added To Cart"
              ),
            ));

          //  Navigator.of(context).pop();
            Navigator.pushNamed(
              context,
              '/home2',
            );
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Add'),
        ),
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).secondaryHeaderColor),
        ),
      ],
    );
  }

  var _isLoading = false;
  int activePage = 0;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(arguments['itemName'].toString()),
        ),
        body: Container(
            color: Colors.white,
            child: _isLoading
                ? CircularProgressIndicator()
                : CustomScrollView(slivers: [
                    SliverToBoxAdapter(
                        child: Card(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(
                              width: 300,
                              height: 200,
                              child: PageView.builder(
                                  itemCount: images.length,
                                  pageSnapping: true,
                                  controller: _pageController,
                                  onPageChanged: (page) {
                                    setState(() {
                                      activePage = page;
                                    });
                                  },
                                  itemBuilder: (context, pagePosition) {
                                    bool active = pagePosition == activePage;
                                    return slider(images, pagePosition, active);
                                  }),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    indicators(images.length, activePage)),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Text(
                                          arguments['price'].toString() + "/=",
                                          style: TextStyle(fontSize: 25))),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: Row(children: <Widget>[
                                        Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: IconButton(
                                                icon: new Icon(Icons.star,
                                                    size: 30.0),
                                                onPressed: () => itemDicrease(),
                                                color: Colors.yellow)),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Text(averagerating,
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white)))
                                      ]))
                                ]),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                child: Text(arguments['description'].toString(),
                                    style: TextStyle(fontSize: 15))),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: IconButton(
                                          icon: new Icon(Icons.remove,
                                              size: 30.0),
                                          onPressed: () => itemDicrease(),
                                          color: Colors.black)),
                                  badges.Badge(
                                    badgeContent: Text(_itemCount.toString(),
                                        style: TextStyle(
                                            color:
                                                Colors.white, //badge font color
                                            fontSize: 20 //badge font size
                                            )),
                                    child: Container(
                                        child: IconButton(
                                            icon: new Icon(Icons.shopping_cart,
                                                size: 40.0),
                                            onPressed: () =>
                                                setState(() => itemIncrement()),
                                            color: Colors.black)),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.fromLTRB(20, 0, 10, 10),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: IconButton(
                                          icon: new Icon(Icons.add, size: 30.0),
                                          onPressed: () =>
                                              setState(() => itemIncrement()),
                                          color: Colors.black)),
                                ]),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                      width: 145, // <-- Your width
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor),
                                        onPressed: () async {
                                          // Navigator.of(context).pop();

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(context),
                                          );
                                        },
                                        //textColor: Theme.of(context).primaryColor,
                                        child: const Text('Give Rating',
                                            style: TextStyle(fontSize: 20)),
                                      )),
                                ]),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 10))
                          ]),
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
                              if(_itemCount==0){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Item quantity is empty"
                                  ),
                                ));
                              }else{
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog2(context),
                                );
                              }

                            },
                              icon: Icon(Icons.shopping_cart),  //icon data for elevated button
                              label: Text("Add To Cart"),
                          )))),
              SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.all(15),
                      child: SizedBox(
                        // width: 200, // <-- Your width
                          height: 40, // <-- Your height
                          width: double.infinity,
                          child:ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme.of(context).primaryColor),
                            onPressed: () async {


                            },
                            icon: Icon(Icons.payment),  //icon data for elevated button
                            label: Text("Make Payment"),
                          ))
                  )
              ),
                    SliverToBoxAdapter(
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 250.0,
                                      child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: TextField(
                                            // The validator receives the text that the user has entered.
                                            // obscureText: true,
                                            controller: comment,
                                            // keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Enter Comment',
                                              //hintText: 'Enter Item',
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                        width: 100, // <-- Your width
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor),
                                          onPressed: () async {
                                            // Navigator.of(context).pop();

                                            if (comment.value.text == '') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    " Please enter comment"),
                                              ));
                                            } else {
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              await enterComment(
                                                  comment.value.text);
                                              await getCommentByItemId();


                                              setState(() {
                                                _isLoading = false;
                                                comment.clear();
                                              });
                                            }
                                          },
                                          //textColor: Theme.of(context).primaryColor,
                                          child: const Text('Send',
                                              style: TextStyle(fontSize: 20)),
                                        )),
                                  ])
                            ]))),

                    SliverToBoxAdapter(
                        child: SizedBox(
                      // height: 100.0,
                      child: ListView.builder(
                          itemCount: comments!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                                child: Card(
                                    elevation: 20,
                                    margin: EdgeInsets.all(20),
                                    child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      //apply padding to all four sides
                                                      child: Text(
                                                          comments[index].name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      //apply padding to all four sides
                                                      child: Text(
                                                          comments[index]
                                                              .sendDate,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ),
                                                  ]),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                //apply padding to all four sides
                                                child: Text(
                                                    comments[index].comment,
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                    textAlign: TextAlign.left),
                                              )
                                            ]))));
                          }),
                    )),

                  ])));
  }
}
