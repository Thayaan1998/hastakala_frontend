class Order{
  int orderId;
  String status;
  int month;
  int year;
  int day;

  Order({required this.orderId, required this.status,required this.month, required this.year,required this.day});

  factory Order.fromList(List<dynamic>json) {
    return Order(
        orderId:json[0],
        status:json[1],
        month: json[2],
        year: json[3],
        day: json[4]);
  }
}