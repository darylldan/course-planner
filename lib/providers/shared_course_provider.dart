import 'package:course_planner/api/FirebaseAPI.dart';
import 'package:course_planner/api/IsarService.dart';
import 'package:course_planner/models/SharedCourse.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/UploadedCourse.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/utils/extensions.dart';
import 'package:flutter/material.dart';

class ShareCourseProvider with ChangeNotifier {
  late FirebaseAPI _firebaseService;
  late IsarService _isarService;
  List<UploadedCourse> _uploadedCourses = [];

  ShareCourseProvider() {
    _firebaseService = FirebaseAPI();
    _isarService = IsarService();
    init();
  }

  void init() async {
    _uploadedCourses = await _isarService.getAllUploadedCourses();
  }

  void load() {
    return;
  }

  UploadedCourse? getUcOrNull(Subject course) {
    String hash = SubjectMethods.getStableHash(course);
    return _uploadedCourses.where((u) => u.hash == hash).firstOrNull;
  }

  // Checking of internet connection is done through frontend
  Future<String?> uploadCourse(Subject course) async {
    String hash = SubjectMethods.getStableHash(course);

    // check if course is already uploaded
    UploadedCourse? uc =
        _uploadedCourses.where((u) => u.hash == hash).firstOrNull;

    if (uc != null) {
      return uc.documentId;
    }

    SharedCourse sc = SharedCourse(
        courseCode: course.courseCode,
        isLaboratory: course.isLaboratory,
        description: course.description,
        instructor: course.instructor,
        frequency: course.frequency.map((d) => DayMethods.dayToInt(d)).toList(),
        notes: course.notes,
        startDate: course.startDate,
        endDate: course.endDate,
        units: course.units,
        credited: course.credited,
        color: course.color);

    final String? id =
        await _firebaseService.uploadSharedCourse(SharedCourse.toJson(sc));

    if (id != null) {
      UploadedCourse newUc = UploadedCourse()
        ..documentId = id
        ..hash = hash;
      int? newId = await _isarService.createUploadedCourse(newUc);

      newUc.id = newId;

      _uploadedCourses.add(newUc);
    }

    return id;
  }

  Future<SharedCourse?> downloadCourse(String id) async {
    try {
      final data = await _firebaseService.downloadCourse(id);

      if (data == null) {
        debugPrint("Document not found");
        return null;
      }

      final SharedCourse sc = SharedCourse.fromJson(data);

      return sc;
    } catch (e) {
      debugPrint("Error downloading course: $e");
      return null;
    }
  }
}
