import 'package:course_planner/models/Subject.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineCard extends StatelessWidget {
  Subject subject;

  TimelineCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topCenter,
        children: [
          _subjectContainer(context),
          Positioned(
            top: -15,
            child: Center(child: _startTimeHat(context)),
          ),
        ],
      ),
    );
  }

  String _getSubjectDuration() {
    Duration duration = subject.endDate.difference(subject.startDate);
    var durationString = "";

    if (duration.inHours > 0) {
      durationString =
          "$durationString${duration.inHours} ${duration.inHours == 1 ? 'hr' : 'hrs'}";
    }

    if (duration.inMinutes % 60 > 0) {
      durationString =
          "$durationString ${duration.inMinutes % 60} ${duration.inMinutes & 60 == 1 ? 'mins' : 'mins'}";
    }

    return durationString;
  }

  Widget _subjectContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      height: 80,
      width: 350,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color.fromARGB(subject.color[0], subject.color[1], subject.color[2], subject.color[3])),
                          width: 4,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 230,
                        child: Text(
                          "CMSC 124 ${subject.isLaboratory ? "- Laboratory" : "Lecture"}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 230,
                        child: Text(
                          subject.room,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                      )
                    ])
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getSubjectDuration(),
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  textAlign: TextAlign.right,
                ),
                Text(
                  subject.section,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.right,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _startTimeHat(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: Text(
        DateFormat.jm().format(subject.startDate),
        style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w800),
      ),
    );
  }
}
