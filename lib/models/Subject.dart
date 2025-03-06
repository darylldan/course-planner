import '../utils/enums.dart';
import 'package:isar/isar.dart';

part 'Subject.g.dart';

@collection
class Subject {
  Id? id = Isar.autoIncrement;

  late String courseCode;
  late bool isLaboratory;
  String? description;
  late String section;
  late String? instructor;
  late int termID;
  late int? locationID;
  late String? locationType; // "room" or "bldg"

  @Enumerated(EnumType.name)
  late List<Day> frequency;
  String? notes;

  late DateTime startDate;
  late DateTime endDate;

  late double units;
  late double? grade;

  // List because the Color class is not serializable
  late List<int> color;
}
