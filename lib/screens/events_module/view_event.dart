import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/deadlineevent_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/events_module/add_event.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/constants.dart' as C;

class ViewEvent extends StatefulWidget {
  final DeadlineEvent event;
  const ViewEvent({super.key, required this.event});

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  late DeadlineEvent event;

  @override
  void initState() {
    event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Term term = context.read<TermProvider>().getTermByID(widget.event.termId);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEvent(
                              currTerm: term,
                              editMode: true,
                              deadlineEvent: event,
                            )));

                if (result is DeadlineEvent) {
                  setState(() {
                    event = result;
                  });
                }
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "View Event"),
            _mainEventCard(context),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),
            _dateCard(context),
            _calendar(context, term),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }

  Widget _dateCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      padding: EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.calendar_today,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Text(
                "Date and Time",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          Text(
            DateFormat('MMMM d, y').format(event.date),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: C.titleCardContentFontSize),
          ),
          Row(
            children: [
              Text(
                "${(event.date.hour != 0 && event.date.minute != 0) ? "${TimeOfDay.fromDateTime(event.date).format(context)}, " : ""}${DateFormat('EEEE').format(event.date)}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w300),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _calendar(BuildContext context, Term term) {
    return TableCalendar(
      focusedDay: event.date,
      currentDay: event.date,
      firstDay: term.startDate,
      lastDay: term.endDate,
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
      eventLoader: (day) {
        final allEvents =
            Provider.of<DeadlineEventProvider>(context, listen: false)
                .getDeadlineEventByTerm(widget.event.termId);
        return allEvents.where((event) => isSameDay(event.date, day)).toList();
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
        markerDecoration: BoxDecoration(color: Theme.of(context).colorScheme.onTertiaryContainer, shape: BoxShape.circle)
      ),
    );
  }

  Widget _mainEventCard(BuildContext context) {
    Subject? course = event.courseId == -1
        ? null
        : context.read<SubjectProvider>().getSubjectByID(event.courseId);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      padding: EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.calendar_month,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                "Event",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          Text(
            event.description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: C.titleCardContentFontSize),
          ),
          Text(
            course == null
                ? "Unassigned Event"
                : "${course.courseCode} - ${course.isLaboratory ? "Laboratory" : "Lecture"}",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}
