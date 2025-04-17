import 'package:iskotrack/models/CourseGrade.dart';
import 'package:iskotrack/models/Subject.dart';
import 'package:iskotrack/models/Term.dart';
import 'package:iskotrack/models/TermGrade.dart';
import 'package:iskotrack/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/IsarService.dart';

class TermGradeProvider with ChangeNotifier {
  late IsarService isarService;

  List<TermGrade> _termGrades = [];
  List<CourseGrade> _courseGrades = [];
  List<Term> _terms = [];
  List<Subject> _courses = [];
  List<TermGrade> get termGrades => _termGrades;
  int? _totalUnitsOverall;
  int? get totalUnitsOverall => _totalUnitsOverall;
  late SharedPreferences prefs;

  TermGradeProvider() {
    isarService = IsarService();
    init();
  }

  void load() {
    return;
  }

  void init() async {
    _termGrades = await isarService.getAllTermGrades();
    _courseGrades = await isarService.getAllCourseGrades();
    _terms = await isarService.getAllTerms();
    _courses = await isarService.getAllSubjects();
    prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("totalUnits")) {
      _totalUnitsOverall = prefs.getInt("totalUnits");
    }
    notifyListeners();
  }

  TermGrade getTermGradeById(int id) {
    return _termGrades.firstWhere((tg) => tg.id! == id);
  }

  Future<int?> createTermGrade(TermGrade termGrade) async {
    int? newId = await isarService.createTermGrade(termGrade);
    termGrade.id = newId;
    _termGrades.add(termGrade);

    notifyListeners();
    return newId;
  }

  Future<void> editTermGrade(TermGrade termGrade) async {
    await isarService.editTermGrade(termGrade);
    _termGrades[_termGrades.indexWhere((tg) => tg.id! == termGrade.id)] =
        termGrade;

    notifyListeners();
  }

  Future<void> deleteTermGrade(int id) async {
    await isarService.deleteTermGrade(id);
    _termGrades.removeWhere((tg) => tg.id == id);

    notifyListeners();
  }

  /* Utility functions */

  void updateState() async {
    _termGrades = await isarService.getAllTermGrades();
    _courseGrades = await isarService.getAllCourseGrades();

    notifyListeners();
  }

  void setTotalUnits(int totalUnits) {
    prefs.setInt("totalUnits", totalUnits);
    _totalUnitsOverall = totalUnits;

    notifyListeners();
  }

  List<CourseGrade> getGradedCourseGradeByTerm(int termId,
      {bool credited = true}) {
    return _courseGrades
        .where((cg) => cg.termId == termId)
        .where((cg) =>
            (cg.isCredited == credited) &&
            cg.nonNumericalGrade == null &&
            cg.grade != null)
        .toList();
  }

  int getGradedUnitsOfTerm(int termId, {bool credited = true}) {
    List<CourseGrade> courseGrade =
        getGradedCourseGradeByTerm(termId, credited: credited);

    if (courseGrade.isEmpty) {
      return 0;
    }

    return courseGrade.map((e) => e.units).reduce((a, b) => a + b);
  }

  bool isGradesEmpty() {
    if (_termGrades.isNotEmpty) {
      return false;
    }

    List<double> grades = [];

    for (Term t in _terms) {
      grades.add(getTermGWAFromCourses(t.id!));
    }

    if (grades.any((g) => g != 0.0)) {
      return false;
    }

    if (termGrades.any((tg) => tg.grade != 0.0)) {
      return false;
    }

    return true;
  }

  double getTermGWAFromCourses(int termId, {bool credited = true}) {
    List<CourseGrade> courseGrade =
        getGradedCourseGradeByTerm(termId, credited: credited);

    if (courseGrade.isEmpty) {
      return 0.0; // no grades encoded yet
    }

    // Now compute for the gwa of courses who already have a grade
    int totalUnit = courseGrade
        .where((cg) =>
            cg.grade != NumericalGrade.drp && cg.grade != NumericalGrade.inc)
        .map((e) => e.units)
        .reduce((a, b) => a + b);

    double gradeMultUnitsSum = courseGrade
        .where((cg) =>
            cg.grade != NumericalGrade.drp && cg.grade != NumericalGrade.inc)
        .map((cg) => GradeMethods.getValue(cg.grade!)! * cg.units)
        .reduce((a, b) => a + b);

    return gradeMultUnitsSum / totalUnit;
  }

  int getOverallUnitsTaken({bool credited = true}) {
    int totalUnitsTaken = 0;
    for (Term t in _terms) {
      totalUnitsTaken += getGradedUnitsOfTerm(t.id!, credited: true);
    }

    for (TermGrade tg in _termGrades) {
      totalUnitsTaken += tg.units;
    }

    return totalUnitsTaken;
  }

  Map<String, dynamic>? getGWAExtremes(bool lowest) {
    List<Map<String, dynamic>> gwas = [];

    for (Term t in _terms) {
      double grade = getTermGWAFromCourses(t.id!);
      if (grade == 0) {
        continue;
      }

      gwas.add({"gwa": grade, "obj": t});
    }

    for (TermGrade tg in _termGrades) {
      gwas.add({"gwa": tg.grade, "obj": tg});
    }

    if (gwas.isEmpty) {
      return null;
    }

    return lowest
        ? gwas.fold(
            gwas[0], (prev, curr) => prev?["gwa"] > curr["gwa"] ? prev : curr)
        : gwas.fold(
            gwas[0], (prev, curr) => prev?["gwa"] < curr["gwa"] ? prev : curr);
  }

  Map<dynamic, int> getGradeTally() {
    final tally = <dynamic, int>{
      // Numerical grades
      NumericalGrade.g1_00: 0,
      NumericalGrade.g1_25: 0,
      NumericalGrade.g1_50: 0,
      NumericalGrade.g1_75: 0,
      NumericalGrade.g2_00: 0,
      NumericalGrade.g2_25: 0,
      NumericalGrade.g2_50: 0,
      NumericalGrade.g2_75: 0,
      NumericalGrade.g3_00: 0,
      NumericalGrade.g4_00: 0,
      NumericalGrade.g5_00: 0,
      NumericalGrade.inc: 0,
      NumericalGrade.drp: 0,
      // Non-numerical grades
      NonNumericalGrade.s: 0,
      NonNumericalGrade.us: 0,
    };

    for (final cg in _courseGrades) {
      if (cg.nonNumericalGrade != null) {
        tally[cg.nonNumericalGrade] = tally[cg.nonNumericalGrade]! + 1;
      }

      if (cg.grade != null) {
        tally[cg.grade] = tally[cg.grade]! + 1;
      }
    }

    // Convert to String keys and double values (if needed)
    return tally;
  }

  Map<dynamic, int> getTermGradeTally(int termId) {
    final tally = <dynamic, int>{
      // Numerical grades
      NumericalGrade.g1_00: 0,
      NumericalGrade.g1_25: 0,
      NumericalGrade.g1_50: 0,
      NumericalGrade.g1_75: 0,
      NumericalGrade.g2_00: 0,
      NumericalGrade.g2_25: 0,
      NumericalGrade.g2_50: 0,
      NumericalGrade.g2_75: 0,
      NumericalGrade.g3_00: 0,
      NumericalGrade.g4_00: 0,
      NumericalGrade.g5_00: 0,
      NumericalGrade.inc: 0,
      NumericalGrade.drp: 0,
      // Non-numerical grades
      NonNumericalGrade.s: 0,
      NonNumericalGrade.us: 0,
    };

    List<CourseGrade> courseGrades =
        _courseGrades.where((cg) => cg.termId == termId).toList();

    for (final cg in courseGrades) {
      if (cg.nonNumericalGrade != null) {
        tally[cg.nonNumericalGrade] = tally[cg.nonNumericalGrade]! + 1;
      }

      if (cg.grade != null) {
        tally[cg.grade] = tally[cg.grade]! + 1;
      }
    }

    // Convert to String keys and double values (if needed)
    return tally;
  }

  double getOverallGWA({bool credited = true}) {
    // Compute the GWA of each terms

    // Get total units taken
    int totalUnitsTaken = 0;
    for (Term t in _terms) {
      totalUnitsTaken += getGradedUnitsOfTerm(t.id!, credited: true);
    }

    // Get grades * units from each term
    double gradeMultUnitSum = 0.0;
    for (Term t in _terms) {
      gradeMultUnitSum += getTermGWAFromCourses(t.id!, credited: true) *
          getGradedUnitsOfTerm(t.id!, credited: true);
    }

    // Now add up the computed gwa from termgrades
    for (TermGrade tg in _termGrades) {
      totalUnitsTaken += tg.units;
      gradeMultUnitSum += tg.grade * tg.units;
    }

    if (gradeMultUnitSum == 0 && totalUnitsTaken == 0) {
      return 0.0;
    }

    // Return GWA
    return gradeMultUnitSum / totalUnitsTaken;
  }

  // Functions for insights

  // Get current latin honor status
  // Source: https://uplbosa.org/page-handbook pg. 141
  Honors getLatinHonorStatus() {
    double gwa = getOverallGWA();

    if (gwa <= 1.2) {
      return Honors.summa;
    } else if (gwa <= 1.45) {
      return Honors.magna;
    } else if (gwa <= 1.75) {
      return Honors.cum;
    } else {
      return Honors.none;
    }
  }

  // Get gwa required for each status
  // This function assumes that the total units for degprog is already set
  Map<dynamic, dynamic>? getRequiredGWAForLatin() {
    if (!prefs.containsKey("totalUnits")) {
      return null;
    }

    int totalUnits = prefs.getInt("totalUnits")!;

    Map<dynamic, dynamic> gwaGoal = {
      "remainingUnits": 0,
      Honors.summa: 0,
      Honors.magna: 0,
      Honors.cum: 0
    };

    int takenUnits = getOverallUnitsTaken();
    int remainingUnits = totalUnits - takenUnits;

    if (remainingUnits == 0) {
      return gwaGoal;
    }

    final double minSummaGrade = 1.2 * totalUnits;
    final double minMagnaGrade = 1.45 * totalUnits;
    final double minCumGrade = 1.75 * totalUnits;

    double currentGradePoints = getOverallGWA() * takenUnits;

    gwaGoal["remainingUnits"] = remainingUnits;
    gwaGoal[Honors.summa] =
        (minSummaGrade - currentGradePoints) / remainingUnits;
    gwaGoal[Honors.magna] =
        (minMagnaGrade - currentGradePoints) / remainingUnits;
    gwaGoal[Honors.cum] = (minCumGrade - currentGradePoints) / remainingUnits;

    return gwaGoal;
  }

  // Number of encoded grades / total no of courses
  Map<String, int> encodedGradesCount(int termId) {
    Map<String, int> returnVal = {
      'c_encoded': 0,
      'c_total': 0,
      'nc_encoded': 0,
      'nc_total': 0
    };

    List<CourseGrade> gradedCourses = getGradedCourseGradeByTerm(termId);
    List<CourseGrade> ncGradedCourses =
        getGradedCourseGradeByTerm(termId, credited: false);
    returnVal['c_encoded'] = gradedCourses.length + ncGradedCourses.length;
    returnVal['c_total'] =
        _courseGrades.where((cg) => cg.termId == termId).length;
    returnVal['nc_encoded'] = ncGradedCourses.length;
    returnVal['nc_total'] = _courses
        .where((s) => s.termID == termId && !s.credited)
        .toList()
        .length;

    return returnVal;
  }

  // Get current honorific scholarship status
  // Source: https://uplbosa.org/page-handbook pg 138
  HonorificScholarship? getHonorificScholarshipStatus(int termId) {
    List<CourseGrade> courseGrade = getGradedCourseGradeByTerm(termId);

    if (courseGrade.isEmpty) {
      return null;
    }

    List<Subject> courses = _courses.where((c) => c.termID == termId).toList();

    if (courses.map((c) => c.units.toInt()).fold(0, (a, b) => a + b) < 15) {
      return HonorificScholarship.ineligibleUnderload;
    }

    if (courseGrade.any((cg) => GradeMethods.getValue(cg.grade!)! > 3.0)) {
      return HonorificScholarship.ineligibleLowGrade;
    }

    double gwa = getTermGWAFromCourses(termId);

    if (gwa <= 1.45) {
      return HonorificScholarship.university;
    } else if (gwa <= 1.75) {
      return HonorificScholarship.college;
    } else if (gwa <= 2.0) {
      return HonorificScholarship.honorRoll;
    } else if (gwa <= 3.0) {
      return HonorificScholarship.goodStanding;
    } else {
      return HonorificScholarship.ineligibleLowGrade;
    }
  }

  // Get gwa required for honorific scholarship status
  Map<dynamic, dynamic> getRequiredGWAForHonSch(int termId, int totalUnits) {
    List<CourseGrade> courseGrade = getGradedCourseGradeByTerm(termId);
    Map<dynamic, dynamic> gwaGoal = {
      "remainingUnits": 0,
      HonorificScholarship.university: 0.0,
      HonorificScholarship.college: 0.0,
    };

    int takenUnits = _courseGrades
        .where((c) => c.grade != null && c.termId == termId && c.isCredited)
        .map((c) => c.units.toInt())
        .fold(0, (a, b) => a + b);

    int remainingUnits = totalUnits - takenUnits;

    gwaGoal["remainingUnits"] = remainingUnits;

    double univScholGrade = 1.45 * totalUnits;
    double collScholGrade = 1.75 * totalUnits;

    if (courseGrade.isEmpty) {
      gwaGoal[HonorificScholarship.university] = 1.45;
      gwaGoal[HonorificScholarship.college] = 1.75;

      return gwaGoal;
    }

    double currGrade = courseGrade
        .map((cg) => GradeMethods.getValue(cg.grade!)! * cg.units)
        .reduce((a, b) => a + b);

    if (totalUnits < 15) {
      return gwaGoal;
    }

    gwaGoal[HonorificScholarship.university] =
        (univScholGrade - currGrade) / remainingUnits;
    gwaGoal[HonorificScholarship.college] =
        (collScholGrade - currGrade) / remainingUnits;

    return gwaGoal;
  }
}
