import '../utils/enums.dart';
import 'package:isar/isar.dart';

part 'Subject.g.dart';

@collection
class Subject {
  Id? id = Isar.autoIncrement;

  late String subjectID;
  late String courseCode;
  late bool isLaboratory;
  String? description;
  late String section;
  late String room;
  late String? instructor;
  late int termID;

  @Enumerated(EnumType.name)
  late List<Day> frequency;
  String? notes;

  late DateTime startDate;
  late DateTime endDate;

  late List<int> color;
}
