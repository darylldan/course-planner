import 'package:isar/isar.dart';

part 'TermGrade.g.dart';

@collection
class TermGrade {
  Id? id = Isar.autoIncrement;

  late String semester;
  late String academicYear;
  late int units;

  late double grade;
}
