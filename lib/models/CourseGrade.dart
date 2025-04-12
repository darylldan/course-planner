import 'package:iscompanion/utils/enums.dart';
import 'package:isar/isar.dart';

part 'CourseGrade.g.dart';

/*
 *  This object is automatically generated when a course is created.
 *  You can only link a course once the courseCode and units match. If it is
 *  the same courseCode, but different units, a new CourseGrade is created.
 *  
 */

@collection
class CourseGrade {
  Id? id = Isar.autoIncrement;
  late int units;

  late String courseCode;
  late int termId;
  late bool isCredited;

  @Enumerated(EnumType.name)
  NumericalGrade? grade;

  @Enumerated(EnumType.name)
  NonNumericalGrade? nonNumericalGrade;
}
