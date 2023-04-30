class Shop {
  int shopId;
  String shopName;
  String address;
  String imageUrl;

  Shop(
      {required this.shopId,
        required this.shopName,
        required this.address,
        required this.imageUrl
      });



  factory Shop.fromList(List<dynamic>json) {
    return Shop(
        shopId: json[0],
        shopName: json[1],
        address: json[2],
        imageUrl: json[3],
    );
  }


}
