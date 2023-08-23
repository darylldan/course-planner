import 'package:course_planner/screens/classes_module/view_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(C.cardBorderRadius)),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () {
            if (nextClass != null && !isLastClass && !emptyMode) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewClass(subjectID: nextClass!.id!)),
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
        Text(
          "${DateFormat.jm().format(nextClass!.startDate)} - ${DateFormat.jm().format(nextClass!.endDate)}",
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
          child: _sectionRoomRow(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _notes(context),
        )
      ],
    );
  }

  Widget _sectionRoomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: _room(context),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 1,
          child: _section(context),
        ),
      ],
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
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
              Text(
                "Section",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  fontSize: 12,
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
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _room(BuildContext context) {
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
                  Icons.apartment_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
              Text(
                "Room",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              nextClass!.room,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
              Text(
                "Notes",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.surfaceVariant,
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
                    color: Theme.of(context).colorScheme.surfaceVariant),
              ),
            ),
          )
        ],
      ),
    );
  }
}
