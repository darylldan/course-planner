import 'package:iscompanion/models/DeadlineEvent.dart';
import 'package:iscompanion/models/Term.dart';
import 'package:iscompanion/providers/deadlineevent_provider.dart';
import 'package:iscompanion/widgets/cards/events_card.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/constants.dart' as C;

class CalendarEvent {
  final DeadlineEvent deadlineEvent;

  CalendarEvent(this.deadlineEvent);

  @override
  String toString() => deadlineEvent.description;
}

class CalendarEventView extends StatefulWidget {
  final Term term;
  const CalendarEventView({super.key, required this.term});

  @override
  State<CalendarEventView> createState() => _CalendarEventViewState();
}

class _CalendarEventViewState extends State<CalendarEventView> {
  late final ValueNotifier<List<CalendarEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final provider = Provider.of<DeadlineEventProvider>(context, listen: false);
    final events = provider.getDeadlineEventByTerm(widget.term.id!);

    return events
        .where((event) => isSameDay(event.date, day))
        .map((event) => CalendarEvent(event))
        .toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: "Event Calendar"),
              TableCalendar<CalendarEvent>(
                firstDay: widget.term.startDate,
                lastDay: widget.term.endDate,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  // Customize marker appearance
                  markersAutoAligned: true,
                  markerSize: 6,
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 8.0),
              ValueListenableBuilder<List<CalendarEvent>>(
                valueListenable: _selectedEvents,
                builder: (context, events, _) {
                  if (events.isEmpty) {
                    return InfoCard(content: "No events for the selected day.");
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...events.map((event) => EventsCard(
                            event: event.deadlineEvent,
                            key: ValueKey(event.deadlineEvent.id),
                          )),
                      Center(
                        child: Text(
                          "${events.length} ${events.length == 1 ? "Event" : "Events"}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 150,
              )
            ],
          ),
        ));
  }
}
