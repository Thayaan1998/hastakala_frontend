class Item {
  int itemId;
  String itemName;
  double price;
  double quantity;
  String description;
  int itemimageId;
  String imageUrl;
  String favourites;


  Item(
      {required this.itemId,
      required this.itemName,
      required this.price,
      required this.quantity,
      required this.description,
      required this.itemimageId,
      required this.imageUrl,
      required this.favourites
      });



  factory Item.fromList(List<dynamic>json) {
    return Item(
        itemId: json[0],
        itemName: json[1],
        price: json[2],
        quantity: json[3],
        description: json[4],
        itemimageId: json[5],
        imageUrl: json[6],
        favourites: '');
  }


}
