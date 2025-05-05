class SharedCourse {
  String? id;

  String courseCode;
  bool isLaboratory;
  String? description; 
  String section;
  String? instructor;
  List<int> frequency;
  String? notes;

  DateTime? startDate;
  DateTime? endDate;
  int units;
  bool credited;

  List<int> color;

  SharedCourse(
      {this.id,
      required this.courseCode,
      required this.isLaboratory,
      required this.section,
      this.description,
      this.instructor,
      required this.frequency,
      this.notes,
      this.startDate,
      this.endDate,
      required this.units,
      required this.credited,
      required this.color});

  factory SharedCourse.fromJson(Map<String, dynamic> json) {
    return SharedCourse(
        courseCode: json["courseCode"],
        isLaboratory: json["isLaboratory"],
        description: json["description"],
        instructor: json["instructor"],
        section: json["section"],
        frequency: (json["frequency"] as List<dynamic>).cast<int>(),
        notes: json["notes"],
        startDate: json["startDate"]?.toDate(),
        endDate: json["endDate"]?.toDate(),
        units: json["units"],
        credited: json["credited"],
        color: (json["color"] as List<dynamic>).cast<int>());
  }

  // assumes frequency is serialized
  static Map<String, dynamic> toJson(SharedCourse sc) {
    return {
      'courseCode': sc.courseCode,
      'isLaboratory': sc.isLaboratory,
      'description': sc.description,
      'section': sc.section,
      'instructor': sc.instructor,
      'frequency': sc.frequency,
      'notes': sc.notes,
      'startDate': sc.startDate,
      'endDate': sc.endDate,
      'units': sc.units,
      'credited': sc.credited,
      'color': sc.color
    };
  }
}
