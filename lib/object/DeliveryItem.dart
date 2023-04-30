class DeliveryItem{
  int deliverId;
  String year;
  String month;
  String date;



  DeliveryItem(
      {required this.deliverId,
        required this.year,
        required this.month,
        required this.date
      });

  factory DeliveryItem.fromList(List<dynamic>json) {
    return DeliveryItem(
      deliverId: json[0],
      year: json[1],
      month: json[2],
      date: json[3]
    );
  }
}