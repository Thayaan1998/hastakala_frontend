class RowMaterial {
  int rowmaterialId;
  String name;
  String address;
  String phonenumber;
  String description;


  RowMaterial(
      {required this.rowmaterialId,
        required this.name,
        required this.address,
        required this.phonenumber,
        required this.description
      });



  factory RowMaterial.fromList(List<dynamic>json) {
    return RowMaterial(
        rowmaterialId: json[0],
        name: json[1],
        address: json[2],
        phonenumber: json[3],
        description: json[4]
    );
  }


}
