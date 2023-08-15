import 'package:flutter/material.dart';
import '../utils/enums.dart';

class Subject {
  String subjectID;
  String courseCode;
  bool isLaboratory;
  String? description;
  String section;
  String room;
  String? instructor;
  String termID;
  List<Day> frequency;
  String? notes;

  DateTime startDate;
  DateTime endDate;

  Color color;

  Subject({
    required this.subjectID,
    required this.courseCode,
    required this.isLaboratory,
    this.description,
    required this.section,
    required this.room,
    this.instructor,
    required this.termID,
    required this.frequency,
    this.notes,
    required this.startDate,
    required this.endDate,
    required this.color,
  });
}
