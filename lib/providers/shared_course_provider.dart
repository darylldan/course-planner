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

  // Checking of internet connection is done through frontend
  Future<String?> uploadCourse(Subject course) async {
    int hash = SubjectMethods.getHash(course);

    // Serialize course into sharedcourse obj
    if (_uploadedCourses.isNotEmpty) {
      if (_uploadedCourses.map((u) => u.hash).contains(hash)) {
        return _uploadedCourses.firstWhere((u) => u.hash == hash).documentId;
      }
    }

    SharedCourse sc = SharedCourse(
        courseCode: course.courseCode,
        isLaboratory: course.isLaboratory,
        frequency: course.frequency.map((d) => DayMethods.dayToInt(d)).toList(),
        units: course.units,
        credited: course.credited,
        color: course.color);

    final String? id =
        await _firebaseService.uploadSharedCourse(SharedCourse.toJson(sc));

    if (id != null) {
      await _isarService.createUploadedCourse(UploadedCourse()
        ..documentId = id
        ..hash = hash);
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
    }
  }
}
