import 'package:iscompanion/models/DeadlineEvent.dart';
import 'package:iscompanion/models/Subject.dart';
import 'package:iscompanion/models/Term.dart';
import 'package:iscompanion/providers/deadlineevent_provider.dart';
import 'package:iscompanion/providers/subject_provider.dart';
import 'package:iscompanion/providers/term_provider.dart';
import 'package:iscompanion/screens/events_module/add_event.dart';
import 'package:iscompanion/screens/events_module/view_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class EventsCard extends StatefulWidget {
  final DeadlineEvent event;

  const EventsCard({super.key, required this.event});

  @override
  State<EventsCard> createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewEvent(
                            event: widget.event,
                          )));
            },
            onLongPress: () => _showActions(context),
            child: _subjectContainer(context),
          ),
        ),
      ),
    );
  }

  Widget _subjectContainer(BuildContext context) {
    Subject? course = widget.event.courseId != -1
        ? context.read<SubjectProvider>().getSubjectByID(widget.event.courseId)
        : null;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: course != null
                            ? Color.fromARGB(
                                course.color[0],
                                course.color[1],
                                course.color[2],
                                course.color[3],
                              )
                            : Theme.of(context).colorScheme.inverseSurface),
                    width: 4,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.description,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      Row(children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              borderRadius: BorderRadius.circular(4)),
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                formatDateTime(widget.event.date, context),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            course != null
                                ? "${course.courseCode} - ${course.isLaboratory ? "Laboratory" : "Lecture"}"
                                : "Unassigned Event",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Row(
            children: [
              Text(formatDaysUntil(widget.event.date)),
              Icon(Icons.chevron_right)
            ],
          )
        ],
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text("Edit Event"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    Term term = context
                        .read<TermProvider>()
                        .getTermByID(widget.event.termId);

                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEvent(
                                  currTerm: term,
                                  editMode: true,
                                  deadlineEvent: widget.event,
                                )));
                  },
                ),
                ListTile(
                  title: const Text("Delete Event"),
                  leading: const Icon(Icons.delete_forever_rounded),
                  onTap: () {
                    context
                        .read<DeadlineEventProvider>()
                        .deleteDeadlineEvent(widget.event.id!);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Event deleted."),
                      ));
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDaysUntil(DateTime input) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(input.year, input.month, input.day);

    final difference = inputDate.difference(today).inDays;

    return (difference >= 1 && difference <= 7) ? "${difference}d" : "";
  }

  String formatDateTime(DateTime input, BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(input.year, input.month, input.day);

    // Use user's locale for time formatting
    final timeFormat =
        DateFormat.jm(Localizations.localeOf(context).toString());

    // Check if time is midnight (00:00)
    final isMidnight = input.hour == 0 && input.minute == 0;

    // Force English for day/month (3-letter format)
    const englishLocale = 'en_US';
    final dayFormat = DateFormat('EEE', englishLocale).format(input); // "THU"
    final monthFormat =
        DateFormat('MMM dd', englishLocale).format(input); // "NOV 22"

    if (inputDate == today) {
      return isMidnight ? "TODAY" : timeFormat.format(input);
    } else if (inputDate
            .isAfter(today.subtract(Duration(days: today.weekday - 1))) &&
        inputDate.isBefore(today.add(Duration(days: 8 - today.weekday)))) {
      // Current week (Monday-Sunday)
      return isMidnight
          ? dayFormat
          : "$dayFormat | ${timeFormat.format(input)}";
    } else {
      // Older date
      return isMidnight
          ? monthFormat
          : "$monthFormat | ${timeFormat.format(input)}";
    }
  }
}
