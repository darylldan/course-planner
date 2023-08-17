import "package:course_planner/models/Subject.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../utils/enums.dart";
import "TimelineCard.dart";

/*
  Pass the filtered (by day) subject on this widget.
 */

class Timeline extends StatelessWidget {
  List<Subject> subjects;

  Timeline({super.key, required this.subjects});
  // Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildTimeline(context),
    );
  }

  List<Widget> _buildTimeline(BuildContext context) {
    List<Widget> timeline = [_startIndicator(context)];

    for (int i = 0; i < subjects.length; i++) {
      // Check if there is break in between subjects, if so adds a break card
      if (i > 0) {
        if (!subjects[i - 1].endDate.isAtSameMomentAs(subjects[i].startDate)) {
          timeline.addAll([
            _breakCard(
              context,
              subjects[i - 1].endDate,
              subjects[i].startDate.difference(subjects[i - 1].endDate),
            ),
            _verticalLine(context, 15, 1),
          ]);
        }
      }

      timeline.addAll(
          [TimelineCard(subject: subjects[i]), _verticalLine(context, 15, 1)]);

      if (i == subjects.length - 1) {
        timeline.addAll(
            [_freeCard(context, subjects[i].endDate), _endIndicator(context)]);
      }
    }

    return timeline;
  }

  Widget _endIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _verticalLine(context, 20, 1),
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface, width: 2.0)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "END",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _startIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "START",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
          ),
        ),
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface, width: 2.0)),
        ),
        _verticalLine(context, 20, 1)
      ],
    );
  }

  Widget _verticalLine(BuildContext context, double length, double thickness) {
    return Container(
      width: thickness,
      height: length,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  Widget _breakCard(
      BuildContext context, DateTime startDate, Duration duration) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topCenter,
        children: [
          _breakContainer(context, duration),
          Positioned(
            top: -15,
            child: _breakDurationHat(context, startDate),
          )
        ],
      ),
    );
  }

  Widget _breakDurationHat(BuildContext context, DateTime startTime) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: Text(
        DateFormat.jm().format(startTime),
        style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _breakContainer(BuildContext context, Duration duration) {
    var durationString = "";

    if (duration.inHours > 0) {
      durationString =
          "$durationString${duration.inHours} ${duration.inHours == 1 ? 'hr' : 'hrs'}";
    }

    if (duration.inMinutes % 60 > 0) {
      durationString =
          "$durationString ${duration.inMinutes % 60} ${duration.inMinutes & 60 == 1 ? 'mins' : 'mins'}";
    }

    return Container(
      height: 45,
      width: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: Center(
        child: Text(
          "BREAK - $durationString",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onTertiaryContainer),
        ),
      ),
    );
  }

  Widget _freeCard(BuildContext context, DateTime startTime) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 45,
            width: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Center(
              child: Text(
                "FREE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          Positioned(
            top: -15,
            child: _breakDurationHat(context, startTime),
          )
        ],
      ),
    );
  }
}
