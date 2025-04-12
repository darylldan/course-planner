import 'package:iscompanion/models/Building.dart';
import 'package:iscompanion/models/Room.dart';
import 'package:iscompanion/providers/building_provider.dart';
import 'package:iscompanion/providers/room_provider.dart';
import 'package:iscompanion/screens/classes_module/view_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as Constants;
import '../../models/Subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _getPositionOffset(), child: _subjectCardClickable(context));
  }

  Widget _subjectCardClickable(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(6),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: Color.fromARGB(subject.color[0], subject.color[1],
              subject.color[2], subject.color[3]),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewClass(subjectID: subject.id!)));
          },
          child: _subjectCardContainer(context),
        ),
      ),
    );
  }

  Widget _subjectCardContainer(BuildContext context) {
    Object? loc;

    if (subject.locationType == "bldg") {
      Building bldg = context
          .watch<BuildingProvider>()
          .getBuildingByID(subject.locationID!);

      if (bldg.latitude != null && bldg.longitude != null) {
        loc = bldg;
      }
    } else if (subject.locationType == "room") {
      Room room =
          context.watch<RoomProvider>().getRoomByID(subject.locationID!);

      loc = room;
    }

    Duration diff = subject.endDate!.difference(subject.startDate!);
    return Container(
      width: Constants.subjectCardWidth,
      height: _computeCardHeight(),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              subject.courseCode,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            Text(
              subject.section,
              style: const TextStyle(fontSize: 9),
            ),
            if (diff.inHours >= 1 && diff.inMinutes % 60 >= 30)
              Text(
                loc == null
                    ? "No location"
                    : loc is Building
                        ? loc.buildingName
                        : loc is Room
                            ? loc.roomName
                            : "Undetermined location",
                style: const TextStyle(fontSize: 7),
                overflow: TextOverflow.clip,
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 3,
              )
          ],
        ),
      ),
    );
  }

  num _getMinutesDuration() {
    return subject.endDate!.difference(subject.startDate!).inMinutes;
  }

  double _computeCardHeight() {
    var minutesDuration = _getMinutesDuration();
    var hoursDuration = (minutesDuration / 60).floor();
    var remainingMinutesPercentage = (minutesDuration % 60) / 60;

    if (hoursDuration == 0) {
      return (Constants.oneHourHeight * remainingMinutesPercentage);
    }

    var minuteHeight = remainingMinutesPercentage == 0
        ? 0
        : Constants.oneHourHeight * remainingMinutesPercentage - 1;

    return 54 * hoursDuration - (hoursDuration - 1) + minuteHeight * 1.0;
  }

  double _getPositionOffset() {
    var minutesDuration = _getMinutesDuration() % 60;
    var hourOffset = subject.startDate!.hour - 6;

    if (subject.startDate!.minute == 0) {
      minutesDuration = 0;
    }

    if (subject.startDate!.hour == 6) {
      return 7.5;
    }

    return 7.5 +
        (Constants.oneHourHeight * hourOffset - (hourOffset - 1)) -
        1 +
        (Constants.oneHourHeight * (minutesDuration / 60));
  }
}
