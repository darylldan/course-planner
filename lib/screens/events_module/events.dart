import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/deadlineevent_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/events_module/add_event.dart';
import 'package:course_planner/screens/events_module/calendar_event_view.dart';
import 'package:course_planner/screens/events_module/view_all_events.dart';
import 'package:course_planner/screens/events_module/view_course_event.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/widgets/cards/current_term_selected.dart';
import 'package:course_planner/widgets/cards/event_course_card.dart';
import 'package:course_planner/widgets/cards/events_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/unassigned_card.dart';
import 'package:course_planner/widgets/elements/drawer.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Term term;
  const CustomAppBar({super.key, required this.term});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _showText = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) setState(() => _showText = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        AnimatedSize(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: _showText
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CalendarEventView(term: widget.term)));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 10),
                      Text("Calendar View"),
                    ],
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CalendarEventView(term: widget.term)));
                  },
                  tooltip: "Calendar View",
                  icon: Icon(Icons.calendar_month), // Just the icon
                ),
        ),
      ],
    );
  }
}

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Term? _termSelectorValue;
  Term? _currentTerm;
  bool _onCurrentTerm = true;

  @override
  Widget build(BuildContext context) {
    Term? currentTerm = context.watch<TermProvider>().currentTerm;
    _currentTerm ??= currentTerm;
    return Scaffold(
      appBar: CustomAppBar(term: _currentTerm!,),
      drawer: SideDrawer(parent: "/events"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Events"),
            _body(context, currentTerm),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
      floatingActionButton: currentTerm != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEvent(
                              currTerm:
                                  _onCurrentTerm ? currentTerm : _currentTerm!,
                            )));
              },
              label: Row(
                children: [Icon(Icons.add), Text("Create Event")],
              ))
          : null,
    );
  }

  Widget _body(BuildContext context, Term? currentTerm) {
    if (currentTerm == null) {
      return InfoCard(
          content: "There are no terms yet. Create one via the terms screen.");
    }

    if (_onCurrentTerm == true) {
      _currentTerm = currentTerm;
    }

    List<Subject> courses =
        context.watch<SubjectProvider>().getSubjectsByTerm(_currentTerm!.id!);

    return Column(
      children: [
        _buildCurrentTerm(context),
        SizedBox(
          height: 10,
        ),
        _dividerWithTitle(context, title: "THIS WEEK"),
        _thisWeekEvents(context),
        SizedBox(
          height: 10,
        ),
        _dividerWithTitle(context, title: "COURSES"),
        if (courses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InfoCard(
                content: "No courses yet. Create one via the Courses screen."),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: UnassignedCard(
            count: context
                .watch<DeadlineEventProvider>()
                .getUnassignedDeadlineEventByTerm(_currentTerm!.id!)
                .length,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewCourseEvent(
                            term: _currentTerm!,
                          )));
            },
          ),
        ),
        if (courses.isNotEmpty) _courses(context, courses),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        _options(context)
      ],
    );
  }

  Widget _courses(BuildContext context, List<Subject> courses) {
    return Column(
      children: [
        ...courses.map((c) => EventCourseCard(subject: c)),
        Center(
          child: Text(
            "${courses.length} ${courses.length == 1 ? "Course" : "Courses"}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onInverseSurface),
          ),
        ),
      ],
    );
  }

  Widget _thisWeekEvents(BuildContext context) {
    List<DeadlineEvent> events = context
        .watch<DeadlineEventProvider>()
        .getAllDeadlineEventsThisWeek(_currentTerm!.id!);

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InfoCard(content: "You don't have any events this week."),
      );
    }

    return Column(
      children: [
        ...events.map((e) => EventsCard(
              event: e,
            )),
      ],
    );
  }

  Widget _dividerWithTitle(BuildContext context, {required String title}) {
    return Row(
      children: [
        const Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onInverseSurface,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
      ],
    );
  }

  Widget _options(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewAllEvents(
                        eventType: ViewEventType.upcoming,
                        term: _currentTerm!)));
          },
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.tertiaryContainer),
              foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onTertiaryContainer)),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upcoming),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "View All Upcoming Events",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Icon(Icons.chevron_right)
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewAllEvents(
                        eventType: ViewEventType.past, term: _currentTerm!)));
          },
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.tertiaryContainer),
              foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onTertiaryContainer)),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "View All Past Events",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Icon(Icons.chevron_right)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTerm(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () {
            _showTermChanger(context);
          },
          child: CurrentTermSelectedCard(
            term: _currentTerm!,
            editMode: false,
            onCurrentTerm: _currentTerm!.isCurrentTerm,
          ),
        ),
      ),
    );
  }

  void _showTermChanger(BuildContext context) {
    _termSelectorValue = _currentTerm;
    List<Term> terms = context.read<TermProvider>().terms;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Select Term",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _termSelector(context, terms),
                const SizedBox(
                  height: 15,
                ),
                InfoCard(
                  content:
                      "To change the current term, go to the Terms screen.",
                  fontSize: 14,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _termSelector(BuildContext context, List<Term> terms) {
    List<DropdownMenuEntry<int>> entries = [];

    for (var t in terms) {
      // Needed because the new dropdown menu does not catch text overflows
      String label = "${t.semester}, ${t.academicYear}";

      if (label.length > 36) {
        label = "${label.substring(0, 37)}...";
      }
      entries.add(
        DropdownMenuEntry(
          value: t.id!,
          label: label,
          trailingIcon: t.isCurrentTerm ? Icon(Icons.star_rounded) : null,
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: 343,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownMenu<int>(
              width: 343,
              initialSelection: _currentTerm!.id,
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              label: const Text("Terms"),
              dropdownMenuEntries: entries,
              onSelected: (int? termID) {
                _termSelectorValue =
                    context.read<TermProvider>().getTermByID(termID!);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer),
                foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentTerm = _termSelectorValue;
                _onCurrentTerm = _termSelectorValue!.isCurrentTerm;
              });
            },
            child: const Text(
              "View Term's Classes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
