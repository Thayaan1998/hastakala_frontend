class OrderDetails{
  int orderId;
  int customerId;
  int vendorId;
  String description;
  String status;
  int year;
  int month;
  int date;


  OrderDetails({required this.orderId,required this.customerId, required this.vendorId,required this.description, required this.status,
    required this.year,required this.month, required this.date});

  factory OrderDetails.fromList(List<dynamic>json) {
    return OrderDetails(
        orderId:json[0],
        customerId:json[1],
        vendorId:json[2],
        description: json[3],
        status: json[4],
        year:json[5],
        month: json[6],
        date: json[7]
    );
  }
}