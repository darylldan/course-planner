import 'package:flutter/material.dart';
import '../../models/Subject.dart';
import '../../utils/enums.dart';
import 'SubjectCard.dart';
import '../../utils/constants.dart' as Constants;

class TimetableSubjects extends StatelessWidget {
  List<Subject> subjects;

  Map<Day, List<Widget>> _timeslots = {
    Day.mon: [],
    Day.tue: [],
    Day.wed: [],
    Day.thu: [],
    Day.fri: [],
    Day.sat: []
  };

  TimetableSubjects({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    _placeSubjects();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _timetableColumns(),
    );
  }

  void _placeSubjects() {
    for (var s in subjects) {
      for (var d in s.frequency) {
        switch (d) {
          case Day.mon:
            _timeslots[Day.mon]?.add(SubjectCard(subject: s));
          case Day.tue:
            _timeslots[Day.tue]?.add(SubjectCard(subject: s));
          case Day.wed:
            _timeslots[Day.wed]?.add(SubjectCard(subject: s));
          case Day.thu:
            _timeslots[Day.thu]?.add(SubjectCard(subject: s));
          case Day.fri:
            _timeslots[Day.fri]?.add(SubjectCard(subject: s));
          case Day.sat:
            _timeslots[Day.sat]?.add(SubjectCard(subject: s));
        }
      }
    }
  }

  List<Widget> _timetableColumns() {
    List<Widget> columns = [SizedBox(width: Constants.timeLabelOffset)];

    for (var i in _timeslots.keys) {
      columns.add(
        Container(
          height: Constants.columnHeight,
          width: Constants.columnWidth,
          child: Stack(
            children: _timeslots[i]!,
          ),
        ),
      );
    }

    return columns;
  }
}
