import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:fyp/config.dart';
import 'package:fyp/object/Order.dart';
import 'package:fyp/shopowner/Orders.dart';
import 'package:fyp/shopowner/getItemToAcceptOrReject.dart';

import 'package:http/http.dart' as http;

class GetCustermizeProductOrders extends StatefulWidget {
  const GetCustermizeProductOrders({Key? key}) : super(key: key);

  @override
  GetCustermizeProductOrdersState createState() {
    return GetCustermizeProductOrdersState();
  }
}

class GetCustermizeProductOrdersState
    extends State<GetCustermizeProductOrders> {
  DateTime selectedDay = DateTime.now();

  List<CleanCalendarEvent> selectedEvent = [];

  Map<DateTime, List<CleanCalendarEvent>> events = {};

  void _handleData(date) {
    setState(() {
      selectedDay = date;

      selectedEvent = events[selectedDay] ?? [];
    });
    // print(selectedDay);
  }

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDatas();
    });
    super.initState();
  }

  List<Order>? orders = [];

  _loadDatas() async {
    var response2 = await http.post(
      Uri.parse(Config.mainUrl + '/getCustomizeProductOrders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'vendorId': Config.vendorId.toString()}),
    );

    setState(() {
      orders = (jsonDecode(response2.body) as List)
          .map((e) => Order.fromList(e))
          .cast<Order>()
          .toList();



      for (var i = 0; i < orders!.length; i++) {
        String orderId = '';
        if (orders![i].orderId < 10) {
          orderId = 'Order Id : 00' + orders![i].orderId.toString();
        } else if (orders![i].orderId < 100) {
          orderId = 'Order Id : 0' + orders![i].orderId.toString();
        } else {
          orderId = 'Order Id : ' + orders![i].orderId.toString();
        }
        Color color=Colors.green ;


        if(orders![i].status=='Requested'){
           color=Colors.yellow ;
        }else if(orders![i].status=='Accepted'){
           color=Colors.green ;
        }else if(orders![i].status=='Ongoing'){
           color=Colors.purple ;
        }else{
           color=Colors.red ;

        }

        if (i == 0) {
          events.addAll({
            DateTime(orders![i].year, orders![i].month, orders![i].day): [
              CleanCalendarEvent(orderId,
                  description: orders![i].status.toString(),
                  startTime: DateTime(orders![i].year, orders![i].month,
                      orders![i].day, 00, 00),
                  endTime: DateTime(orders![i].year, orders![i].month,
                      orders![i].day, 23, 59),
                  isAllDay: true,
                  color: color)
            ]
          });
        } else {
          String a = '';
          events.forEach((key, value) {
            if (key.year == orders![i].year &&
                key.month == orders![i].month &&
                key.day == orders![i].day) {
              events.addAll({
                DateTime(orders![i].year, orders![i].month, orders![i].day): [
                  ...value,
                  CleanCalendarEvent(orderId,
                      description: orders![i].status.toString(),
                      startTime: DateTime(orders![i].year, orders![i].month,
                          orders![i].day, 00, 00),
                      endTime: DateTime(orders![i].year, orders![i].month,
                          orders![i].day, 23, 59),
                      isAllDay: true,
                      color: color)
                ]
              });
            } else {
              a = 'not there';
            }
          });

          if (a == 'not there') {
            events.addAll({
              DateTime(orders![i].year, orders![i].month, orders![i].day): [
                CleanCalendarEvent(orderId,
                    description: orders![i].status.toString(),
                    startTime: DateTime(orders![i].year, orders![i].month,
                        orders![i].day, 00, 00),
                    endTime: DateTime(orders![i].year, orders![i].month,
                        orders![i].day, 23, 59),
                    isAllDay: true,
                    color:color)
              ]
            });
          }
        }
      }
      _isLoading = false;
    });
  }

  var _isLoading = true;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Product Orders'),
        //centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: _isLoading
              ? CircularProgressIndicator()
              : Calendar(
                  startOnMonday: true,
                  selectedColor: Colors.blue,
                  todayColor: Colors.black,
                  eventColor: Colors.red,
                  eventDoneColor: Colors.amber,
                  bottomBarColor: Colors.deepOrange,
                  initialDate: null,
                  onRangeSelected: (range) {
                    print('selected Day ${range.from},${range.to}');
                  },
                  onDateSelected: (date) {
                    return _handleData(date);
                  },
                  //allDayEventText: 'Ganztägig',
                  events: events,
                  onEventSelected: (event) async{
                    Config.orderId = event.summary;
                    Config.orderStatus = event.description;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const GetItemToAcceptOrReject()),
                    ).then((value) async {
                      setState(()  {
                        events= {};

                        _isLoading=true;

                      });
                      await _loadDatas();
                      setState(()  {
                        _isLoading=false;

                      });
                    });
                    //  print(events[selectedDay]![0]!.isDone);
                  },
                  isExpanded: true,
                  dayOfWeekStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black12,
                    fontWeight: FontWeight.w100,
                  ),
                  bottomBarTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hideBottomBar: false,
                  hideArrows: false,
                  // hideTodayIcon:true,
                  weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                ),
        ),
      ),
    );
  }
}
