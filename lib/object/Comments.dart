class Comments{
  String name;
  String comment;
  String sendDate;


  Comments(
      {required this.name,
        required this.comment,
        required this.sendDate});

  factory Comments.fromList(List<dynamic>json) {
    return Comments(
        name: json[0],
        comment: json[1],
        sendDate: json[2]);
  }
}