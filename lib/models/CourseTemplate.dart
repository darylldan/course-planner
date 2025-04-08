import 'package:isar/isar.dart';

part 'CourseTemplate.g.dart';

@collection
class CourseTemplate {
  Id? id = Isar.autoIncrement;

  late String courseCode;
  late String description;
  late int? units;
}
