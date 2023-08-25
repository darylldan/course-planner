import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/Subject.dart';
import '../../utils/constants.dart' as C;

class OverviewTodayCard extends StatelessWidget {
  final List<Subject> subjects;

  OverviewTodayCard({super.key, required this.subjects});

  final DateTime _now = DateTime.now();
  late final int lecClass;
  late final int labClass;

  @override
  Widget build(BuildContext context) {
    subjects.sort(
      (a, b) {
        return a.startDate.compareTo(b.startDate);
      },
    );

    labClass = subjects
        .where(
          (element) => element.isLaboratory,
        )
        .toList()
        .length;
    lecClass = subjects.length - labClass;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.calendar_today_rounded,
                size: C.cardIconSize,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              "Today",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: C.titleCardHeaderFontSize),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              DateFormat('EEEE, MMMM d').format(_now),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
        (subjects.isEmpty)
            ? _noSubjectsToday(context)
            : _scheduleSummary(context)
      ],
    );
  }

  Widget _noSubjectsToday(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Opacity(
                opacity: 0.5,
                child: Divider(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "Schedule Summary",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 14),
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: 0.5,
                child: Divider(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
         SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text(
              "🎉\nHooray! You have no classes today.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _scheduleSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Opacity(
                opacity: 0.5,
                child: Divider(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "Schedule Summary",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 14),
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: 0.5,
                child: Divider(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
       _classesAndBreaks(context)
      ],
    );
  }

  Widget _classesAndBreaks(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconTitleRow(context, Icons.book_rounded, "Classes"),
            Row(
              children: [
                _bigContentSmallLabel(context, "${subjects.length}", "Total"),
                const SizedBox(
                  width: 10,
                ),
                _bigContentSmallLabel(context, "$lecClass", "Lec",
                    isBold: false),
                const SizedBox(
                  width: 10,
                ),
                _bigContentSmallLabel(context, "$labClass", "Lab",
                    isBold: false),
              ],
            )
          ],
        ),
        Column(
          children: [
            _iconTitleRow(context, Icons.alarm_rounded, "Earliest Class"),
            _bigContentSmallLabel(
                context,
                DateFormat.jm().format(subjects[0].startDate),
                "${subjects[0].courseCode} ${subjects[0].isLaboratory ? "Lab" : "Lec"}")
          ],
        ),
        Column(
          children: [
            _iconTitleRow(context, Icons.check_circle_rounded, "Free By"),
            _bigContentSmallLabel(
                context,
                DateFormat.jm().format(subjects[subjects.length - 1].endDate),
                "After ${subjects[subjects.length - 1].courseCode} ${subjects[subjects.length - 1].isLaboratory ? "Lab" : "Lec"}")
          ],
        ),
      ],
    );
  }

  Widget _iconTitleRow(BuildContext context, IconData icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          size: 14,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 14),
        )
      ],
    );
  }

  Widget _bigContentSmallLabel(
      BuildContext context, String content, String label,
      {bool isBold = true}) {
    if (label.length > 20) {
      label = "${label.substring(0, 19)}...";
    }

    return Column(
      children: [
        Text(
          content,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
              fontSize: 20),
        ),
        Text(
          label,
          // "askdfjasldf",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
              fontSize: 10),
        )
      ],
    );
  }
}
