import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/Subject.dart';
import '../../providers/subject_provider.dart';
import '../../utils/constants.dart' as C;
import '../../utils/enums.dart';

class OverlapWarningCard extends StatelessWidget {
  final List<Subject> subjects;
  const OverlapWarningCard({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(C.cardBorderRadius)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.cancel_rounded,
                      size: C.cardIconSize,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  Text(
                    "Overlapping classes detected".toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: C.titleCardHeaderFontSize),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "This class overlaps with others. Please consider changing the timeslot. The following classes are affected:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onErrorContainer),
              ),
              SizedBox(height: 6,),
              _buildOverlappingClasses(context),
              if (subjects.length > 10)
                Text("and ${subjects.length - 10} more."),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOverlappingClasses(BuildContext context) {
    List<Subject> sublist =
        (subjects.length > 10) ? subjects.sublist(0, 10) : subjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: sublist.map<Widget>((s) {
        return _overlappedClass(context, s);
      }).toList(),
    );
  }

  Widget _overlappedClass(BuildContext context, Subject subject) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onErrorContainer,
            borderRadius: BorderRadius.circular(C.cardBorderRadius)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                "${subject.courseCode} - ${subject.isLaboratory ? "Lab" : "Lec"}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.errorContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                _stringifySubject(subject),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.errorContainer,
                    fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _stringifySubject(Subject subject) {
    String subTitle = "";

    for (var d in subject.frequency) {
      switch (d) {
        case Day.mon:
          subTitle = "${subTitle}Mo";
        case Day.tue:
          subTitle = "${subTitle}Tu";
        case Day.wed:
          subTitle = "${subTitle}We";
        case Day.thu:
          subTitle = "${subTitle}Th";
        case Day.fri:
          subTitle = "${subTitle}Fr";
        case Day.sat:
          subTitle = "${subTitle}Sa";
      }
    }

    String timeSlot =
        "${DateFormat.jm().format(subject.startDate)} - ${DateFormat.jm().format(subject.endDate)}";

    return "${subject.section} | $subTitle $timeSlot";
  }
}
