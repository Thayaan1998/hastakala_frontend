class OrderSend{
  int orderId;
  bool checked;


  OrderSend(
      {required this.orderId,

        required this.checked,
      });

  factory OrderSend.fromList(List<dynamic>json) {
    return OrderSend(
      orderId: json[0],
      checked: false
    );
  }
}