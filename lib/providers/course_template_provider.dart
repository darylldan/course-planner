import 'dart:convert';

import 'package:iskotrack/models/CourseTemplate.dart';
import 'package:iskotrack/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../api/IsarService.dart';

class CourseTemplateProvider with ChangeNotifier {
  late IsarService isarService;

  static const _pageSize = 20;

  List<CourseTemplate> _courseTemplates = [];
  List<CourseTemplate> get courseTemplates => _courseTemplates;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  CourseTemplateProvider() {
    isarService = IsarService();
    init();
  }

  void init() async {
    try {
      _isLoading = true;

      final count = await isarService.getCourseTemplateCount();

      if (count == 0) {
        _loadFromJson();
      } else {
        _courseTemplates = await isarService.getAllCourseTemplate();
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void loadTemplates() {
    return;
  }

  Future<void> _loadFromJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/courses.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);

      List<CourseTemplate> allItems = [];

      // Process in batches to avoid UI freezes with large datasets
      const int batchSize = 100;
      for (int i = 0; i < jsonList.length; i += batchSize) {
        final int end =
            (i + batchSize < jsonList.length) ? i + batchSize : jsonList.length;
        final List<dynamic> batch = jsonList.sublist(i, end);

        List<CourseTemplate> parsedItems =
            batch.map((j) => CourseTemplateMethods.fromJson(j)).toList();

        allItems.addAll(parsedItems);

        await isarService.addAllCourseTemplates(parsedItems);
      }

      _courseTemplates.addAll(allItems);
    } catch (e) {
      throw Exception('Failed to load course data: ${e.toString()}');
    }
  }

  CourseTemplate? findCourse(String courseCode) {
    if (courseCode.isEmpty) {
      return null;
    }

    List<CourseTemplate> res = _courseTemplates
        .where((ct) => ct.courseCode
            .toLowerCase()
            .trim()
            .contains(courseCode.trim().toLowerCase()))
        .toList();

    if (res.isEmpty) {
      return null;
    }

    return res.first;
  }

// Add a method for paginated data access
  List<CourseTemplate> getPagedData(int offset, {String? searchQuery}) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      List<CourseTemplate> res = _courseTemplates
          .where((ct) =>
              ct.courseCode
                  .toLowerCase()
                  .trim()
                  .contains(searchQuery.trim().toLowerCase()) ||
              ct.courseCode.toLowerCase() == searchQuery.trim().toLowerCase())
          .skip(offset)
          .take(_pageSize)
          .toList();

      return res;
    }

    return _courseTemplates.skip(offset).take(_pageSize).toList();
  }
}
