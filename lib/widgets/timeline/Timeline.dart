import "package:course_planner/models/Subject.dart";
import "package:flutter/material.dart";

import "../../utils/enums.dart";

class Timeline extends StatelessWidget {
  List<Subject> subjects = [
    Subject(
        subjectID: "1",
        courseCode: "CMSC 124",
        isLaboratory: false,
        section: "CD",
        room: "ICS Megahall",
        termID: "1",
        frequency: [Day.tue, Day.thu],
        startDate: DateTime(2021, 8, 15, 8),
        endDate: DateTime(2021, 8, 15, 9),
        color: Colors.amber[800]!),
    Subject(
        subjectID: "2",
        courseCode: "CMSC 141",
        isLaboratory: true,
        section: "D - 2L",
        room: "ICS PC Lab 7",
        termID: "1",
        frequency: [Day.tue],
        startDate: DateTime(2021, 8, 15, 10),
        endDate: DateTime(2021, 8, 15, 13),
        color: Colors.green[800]!),
    Subject(
        subjectID: "3",
        courseCode: "CMSC 170",
        isLaboratory: false,
        section: "X",
        room: "ICS Megahall",
        termID: "1",
        frequency: [Day.tue, Day.thu],
        startDate: DateTime(2021, 8, 15, 15),
        endDate: DateTime(2021, 8, 15, 16),
        color: Colors.blue[800]!),
    Subject(
        subjectID: "4",
        courseCode: "CMSC 124",
        isLaboratory: true,
        section: "ST - 3L",
        room: "ICS PC Lab 8",
        termID: "1",
        frequency: [Day.tue],
        startDate: DateTime(2021, 8, 15, 16),
        endDate: DateTime(2021, 8, 15, 19),
        color: Colors.deepOrange[800]!),
  ];

  // Timeline({super.key, required this.subjects})
  Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
