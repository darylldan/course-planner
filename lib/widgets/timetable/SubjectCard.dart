import 'package:flutter/material.dart';
import '../../utils/constants.dart' as Constants;
import '../../models/Subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _getPositionOffset(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: Color.fromARGB(subject.color[0], subject.color[1],
                subject.color[2], subject.color[3])),
        width: Constants.subjectCardWidth,
        height: _computeCardHeight(),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subject.courseCode,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subject.section,
                  style: const TextStyle(fontSize: 9),
                ),
              ),
              FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.none,
                child: Text(
                  subject.room,
                  style: const TextStyle(fontSize: 7),
                  overflow: TextOverflow.fade,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  num _getMinutesDuration() {
    return subject.endDate.difference(subject.startDate).inMinutes;
  }

  double _computeCardHeight() {
    var minutesDuration = _getMinutesDuration();
    var hoursDuration = (minutesDuration / 60).floor();
    var remainingMinutesPercentage = (minutesDuration % 60) / 60;

    if (hoursDuration == 0) {
      return (Constants.oneHourHeight * remainingMinutesPercentage);
    }

    return 54 * hoursDuration -
        (hoursDuration - 1) +
        (Constants.oneHourHeight * remainingMinutesPercentage);
  }

  double _getPositionOffset() {
    var minutesDuration = _getMinutesDuration() % 60;
    var hourOffset = subject.startDate.hour - 7;

    if (subject.startDate.hour == 7) {
      return 7.5;
    }

    return 7.5 +
        (Constants.oneHourHeight * hourOffset - (hourOffset - 1)) -
        1 +
        (Constants.oneHourHeight * (minutesDuration / 60));
  }
}
