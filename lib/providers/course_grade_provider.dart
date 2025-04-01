import 'package:course_planner/api/IsarService.dart';
import 'package:course_planner/models/CourseGrade.dart';
import 'package:flutter/foundation.dart';

class CourseGradeProvider with ChangeNotifier {
  late IsarService isarService;

  List<CourseGrade> _courseGrades = [];
  List<CourseGrade> get courseGrades => _courseGrades;

  CourseGradeProvider() {
    isarService = IsarService();
    init();
  }

  void init() async {
    _courseGrades = await isarService.getAllCourseGrades();

    notifyListeners();
  }

  CourseGrade getCourseGradeById(int id) {
    return _courseGrades.firstWhere((cg) => cg.id! == id);
  }

  List<CourseGrade> getCourseGradeByTerm(int termId) {
    return _courseGrades.where((cg) => cg.termId == termId).toList();
  }

  Future<int?> createCourseGrade(CourseGrade courseGrade) async {
    int? newId = await isarService.createCourseGrade(courseGrade);
    courseGrade.id = newId;
    _courseGrades.add(courseGrade);

    notifyListeners();
    return newId;
  }

  bool doesCourseGradeExist(CourseGrade courseGrade) {
    return _courseGrades.any((cg) =>
        cg.courseCode.toLowerCase() == courseGrade.courseCode.toLowerCase() &&
        cg.termId == courseGrade.termId &&
        cg.units == courseGrade.units);
  }

  Future<void> editCourseGrade(CourseGrade courseGrade) async {
    await isarService.editCourseGrade(courseGrade);
    _courseGrades[_courseGrades.indexWhere((cg) => cg.id == courseGrade.id)] =
        courseGrade;

    notifyListeners();
  }

  Future<void> clearCourseGrade(CourseGrade courseGrade) async {
    courseGrade.grade = null;
    courseGrade.nonNumericalGrade = null;

    await isarService.editCourseGrade(courseGrade);
    _courseGrades[_courseGrades.indexWhere((cg) => cg.id == courseGrade.id)] =
        courseGrade;

    notifyListeners();
  }

  // The only way to delete a coursegrade is to delete a subject
}
