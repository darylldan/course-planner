import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/providers/building_provider.dart';
import 'package:course_planner/providers/deadlineevent_provider.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:course_planner/screens/classes_module/view_class.dart';
import 'package:course_planner/widgets/cards/location_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../utils/constants.dart' as C;

class NextClassCard extends StatelessWidget {
  final Subject? nextClass;
  final bool isLastClass;
  final bool emptyMode;
  const NextClassCard(
      {super.key,
      this.nextClass,
      required this.isLastClass,
      this.emptyMode = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(C.cardBorderRadius),
      child: Ink(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(C.cardBorderRadius)),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () {
            if (nextClass != null && !isLastClass && !emptyMode) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewClass(subjectID: nextClass!.id!)),
              );
            }
          },
          child: _nextClassContainer(context),
        ),
      ),
    );
  }

  Widget _nextClassContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), _contentWrapper(context)],
      ),
    );
  }

  Widget _contentWrapper(BuildContext context) {
    if (emptyMode) {
      return Text(
        "--",
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      );
    }

    if (isLastClass) {
      return SizedBox(
        width: double.infinity,
        child: Text(
          "Current class is your last class.",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      );
    }

    return _content(context);
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.fast_forward_rounded,
                size: C.cardIconSize,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              "Next Class",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: C.titleCardHeaderFontSize),
            )
          ],
        ),
        if (!isLastClass && !emptyMode)
          Text(
            "${DateFormat.jm().format(nextClass!.startDate!)} - ${DateFormat.jm().format(nextClass!.endDate!)}",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: C.titleCardHeaderFontSize),
          )
      ],
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              "${nextClass!.courseCode} - ${nextClass!.isLaboratory ? "Laboratory" : "Lecture"}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _room(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _sectionInstructorRow(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _eventsToday(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _notes(context),
        )
      ],
    );
  }

  Widget _sectionInstructorRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: _section(context),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 2,
          child: _instructor(context),
        )
      ],
    );
  }

  Widget _eventsToday(BuildContext context) {
    List<DeadlineEvent> events = context
        .watch<DeadlineEventProvider>()
        .getAllCourseEventToday(nextClass!.termID, nextClass!.id!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.event,
                  size: 14,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              Expanded(
                child: Text(
                  "Events Today",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              if (events.isEmpty)
                Text(
                  "No events today.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ...events.take(3).map((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: _eventLet(context, e),
                  )),
              if (events.length > 3)
                Center(
                  child: Text(
                    "+${events.length - 3} more",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onInverseSurface),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  Widget _eventLet(BuildContext context, DeadlineEvent event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                height: 24,
                width: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  event.description,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onInverseSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Text(
            MaterialLocalizations.of(context).formatTimeOfDay(
              TimeOfDay.fromDateTime(event.date),
              alwaysUse24HourFormat: false,
            ),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface))
      ],
    );
  }

  Widget _instructor(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.person,
                  size: 14,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              Expanded(
                child: Text(
                  "Instructor",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              nextClass!.instructor == null || nextClass!.instructor!.isEmpty
                  ? "Not set."
                  : nextClass!.instructor!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _section(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.groups_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              Expanded(
                child: Text(
                  "Section",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              nextClass!.section,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _room(BuildContext context) {
    LatLng? coords;
    Object? loc;
    Building? suppl;

    if (nextClass!.locationType == "bldg") {
      Building bldg = context
          .watch<BuildingProvider>()
          .getBuildingByID(nextClass!.locationID!);

      if (bldg.latitude != null && bldg.longitude != null) {
        coords = LatLng(bldg.latitude!, bldg.longitude!);
        loc = bldg;
      }
    } else if (nextClass!.locationType == "room") {
      Room room =
          context.watch<RoomProvider>().getRoomByID(nextClass!.locationID!);
      Building bldg =
          context.watch<BuildingProvider>().getBuildingByID(room.buildingId);

      suppl = bldg;

      if (room.long != null && room.lat != null) {
        coords = LatLng(room.lat!, room.long!);
        loc = room;
      } else {
        // get bldg coords,
        if (bldg.latitude != null && bldg.longitude != null) {
          coords = LatLng(bldg.latitude!, bldg.longitude!);
          loc = room;
        }
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.location_pin,
                  size: 14,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              Text(
                "Location",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 12),
              ),
            ],
          ),
          if (coords != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LocationCard(coords: coords),
            ),
          SizedBox(
            width: double.infinity,
            child: Text(
              loc == null
                  ? "No location set."
                  : loc is Building
                      ? loc.buildingName
                      : loc is Room
                          ? loc.roomName
                          : "Unable to determine location.",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (loc is Room && suppl != null)
            SizedBox(
              width: double.infinity,
              child: Text(
                suppl.buildingName,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface),
              ),
            )
        ],
      ),
    );
  }

  Widget _notes(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.format_list_bulleted_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              Text(
                "Notes",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                nextClass!.notes == "" ? "No notes." : nextClass!.notes!,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onInverseSurface),
              ),
            ),
          )
        ],
      ),
    );
  }
}
