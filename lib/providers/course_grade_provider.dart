import 'package:iscompanion/api/IsarService.dart';
import 'package:iscompanion/models/CourseGrade.dart';
import 'package:iscompanion/models/Subject.dart';
import 'package:flutter/foundation.dart';

class CourseGradeProvider with ChangeNotifier {
  late IsarService isarService;

  List<CourseGrade> _courseGrades = [];
  List<CourseGrade> get courseGrades => _courseGrades;

  CourseGradeProvider() {
    isarService = IsarService();
    init();
  }

  void load() {
    return;
  }

  void init() async {
    _courseGrades = await isarService.getAllCourseGrades();

    notifyListeners();
  }

  CourseGrade getCourseGradeById(int id) {
    return _courseGrades.firstWhere((cg) => cg.id! == id);
  }

  CourseGrade getCourseGradeByCourse(Subject course) {
    return _courseGrades.firstWhere((cg) =>
        cg.courseCode.toLowerCase() == course.courseCode.toLowerCase() &&
        cg.units == course.units &&
        cg.termId == course.termID &&
        cg.isCredited == course.credited);
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

  bool doesCourseGradeHaveDependency(
      CourseGrade courseGrade, List<Subject> courses) {
    return courses.any((c) =>
        c.units == courseGrade.units &&
        c.courseCode.toLowerCase() == courseGrade.courseCode.toLowerCase() &&
        c.termID == courseGrade.termId &&
        c.credited == courseGrade.isCredited);
  }

  bool doesCourseHaveCourseGrade(Subject course) {
    return _courseGrades.any((cg) =>
        cg.courseCode.toLowerCase() == course.courseCode.toLowerCase() &&
        cg.termId == course.termID &&
        cg.units == course.units &&
        cg.isCredited == course.credited);
  }

  bool doesCourseGradeExist(CourseGrade courseGrade) {
    return _courseGrades.any((cg) =>
        cg.courseCode.toLowerCase() == courseGrade.courseCode.toLowerCase() &&
        cg.termId == courseGrade.termId &&
        cg.units == courseGrade.units &&
        cg.isCredited == courseGrade.isCredited);
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

  Future<void> deleteCourseGrade(int id) async {
    await isarService.deleteCourseGrade(id);
    _courseGrades.removeWhere((e) => e.id! == id);

    notifyListeners();
  }
}
