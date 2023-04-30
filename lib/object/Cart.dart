class Cart{
  int cartId;
  int itemId;
  String itemName;
  int quantity;
  String imageUrl;
  double price;
  double total;
  bool checked;
  int userId;
  String name;


  Cart(
      {required this.cartId,
        required this.itemId,
        required this.itemName,
        required this.quantity,
        required this.imageUrl,
        required this.price,
        required this.total,
        required this.checked,
        required this.userId,
        required this.name});

  factory Cart.fromList(List<dynamic>json) {
    return Cart(
        cartId: json[0],
        itemId: json[1],
        itemName: json[2],
        quantity: json[3],
        imageUrl: json[4],
        price: json[5],
        total: json[6],
        checked: false,
        userId:json[7],
        name:json[8],

    );
  }
}