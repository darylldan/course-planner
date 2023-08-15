import 'package:flutter/material.dart';
import '../../models/Subject.dart';
import 'DayLabelRow.dart';
import 'GridTimeBackground.dart';
import '../../utils/constants.dart' as Constants;
import 'TimetableSubjects.dart';

class Timetable extends StatelessWidget {
  List<Subject> subjects;

  Timetable({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DayLabelRow(),
        Stack(
          children: [
            GridTimeBackground(hours: Constants.gridHours),
            TimetableSubjects(subjects: subjects)
          ],
        )
      ],
    );
  }
}
