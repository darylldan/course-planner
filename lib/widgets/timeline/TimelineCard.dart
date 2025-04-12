import 'package:iscompanion/models/Building.dart';
import 'package:iscompanion/models/Room.dart';
import 'package:iscompanion/models/Subject.dart';
import 'package:iscompanion/providers/building_provider.dart';
import 'package:iscompanion/providers/room_provider.dart';
import 'package:iscompanion/screens/classes_module/view_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimelineCard extends StatelessWidget {
  final Subject subject;

  const TimelineCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topCenter,
        children: [
          _subjectContainerClickable(context),
          Positioned(
            top: -15,
            child: Center(child: _startTimeHat(context)),
          ),
        ],
      ),
    );
  }

  String _getSubjectDuration() {
    Duration duration = subject.endDate!.difference(subject.startDate!);
    var durationString = "";

    if (duration.inHours > 0) {
      durationString =
          "$durationString${duration.inHours} ${duration.inHours == 1 ? 'hr' : 'hrs'}";
    }

    if (duration.inMinutes % 60 > 0) {
      durationString = "$durationString ${duration.inMinutes % 60} m";
    }

    return durationString;
  }

  Widget _subjectContainerClickable(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewClass(subjectID: subject.id!)));
          },
          child: _subjectContainer(context),
        ),
      ),
    );
  }

  Widget _subjectContainer(BuildContext context) {
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

    return Container(
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
                              color: Color.fromARGB(
                                  subject.color[0],
                                  subject.color[1],
                                  subject.color[2],
                                  subject.color[3])),
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
                        width: 220,
                        child: Text(
                          "${subject.courseCode} ${subject.isLaboratory ? "- Laboratory" : "- Lecture"}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: Text(
                          loc == null
                              ? "No location"
                              : loc is Building
                                  ? loc.buildingName
                                  : loc is Room
                                      ? loc.roomName
                                      : "Undetermined location",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
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
        DateFormat.jm().format(subject.startDate!),
        style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w800),
      ),
    );
  }
}
