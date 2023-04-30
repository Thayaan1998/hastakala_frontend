class Job {

  int JobDescriptionId;
  int vendorId;
  String category;
  String jobTitle;
  String year;
  String month;
  String day;
  String name;
  bool checked;



  Job(
      {required this.JobDescriptionId,
        required this.vendorId,
        required this.category,
        required this.jobTitle,
        required this.year,
        required this.month,
        required this.day,
        required this.name,
        required this.checked
      });



  factory Job.fromList(List<dynamic>json) {
    return Job(
        JobDescriptionId: json[0],
        vendorId: json[1],
        category: json[2],
        jobTitle: json[3],
        year: json[4],
        month: json[5],
        day: json[6],
        name: json[7],
        checked:false

    );
  }


}
