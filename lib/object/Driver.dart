class Driver {
  int userId;
  String name;
  String address;
  String phoneNumber;
  String imageUrl;


  Driver(
      {required this.userId,
        required this.name,
        required this.address,
        required this.phoneNumber,
        required this.imageUrl
      });



  factory Driver.fromList(List<dynamic>json) {
    return Driver(
        userId: json[0],
        name: json[1],
        address: json[2],
        phoneNumber: json[3],
        imageUrl: json[4]
      );
  }


}
