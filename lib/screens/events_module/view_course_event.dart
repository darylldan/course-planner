import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/deadlineevent_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/events_module/add_event.dart';
import 'package:course_planner/widgets/cards/error_card_no_action.dart';
import 'package:course_planner/widgets/cards/events_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class ViewCourseEvent extends StatefulWidget {
  final Subject? course;
  final Term? term;

  const ViewCourseEvent({super.key, this.course, this.term});

  @override
  State<ViewCourseEvent> createState() => _ViewCourseEventState();
}

class _ViewCourseEventState extends State<ViewCourseEvent> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Term term = widget.term == null
        ? context.read<TermProvider>().getTermByID(widget.course!.termID)
        : widget.term!;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
                title: widget.course == null
                    ? "View Unassigned Events"
                    : "View Course Events"),
            if (widget.course != null) ...[
              _classTitleDesc(context),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
            ],
            _body(context),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEvent(
                          currTerm: term,
                          course: widget.course,
                        )));
          },
          label: Row(
            children: [Icon(Icons.add), Text("Create Event")],
          )),
    );
  }

  Widget _body(BuildContext context) {
    List<DeadlineEvent> upcomingEvents = (widget.course != null)
        ? context
            .watch<DeadlineEventProvider>()
            .getAllUpcomingDeadlineEventsForSubject(widget.course!.id!)
        : context
            .watch<DeadlineEventProvider>()
            .getAllUpcomingUnassignedEvent(widget.term!.id!);

    List<DeadlineEvent> doneEvents = (widget.course != null)
        ? context
            .watch<DeadlineEventProvider>()
            .getAllDoneDeadlineEventsForSubject(widget.course!.id!)
        : context
            .watch<DeadlineEventProvider>()
            .getAllDoneUnassignedEvent(widget.term!.id!);

    if (upcomingEvents.isEmpty && doneEvents.isEmpty) {
      return InfoCard(content: "No events yet. Create one below.");
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                ),
                onChanged: (String val) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (_searchCtrl.text.isNotEmpty)
              IconButton(
                  onPressed: () => setState(() {
                        _searchCtrl.clear();
                      }),
                  icon: Icon(Icons.clear))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        if (_searchCtrl.text.isNotEmpty)
          _searchResults(context)
        else
          _eventsList(context, upcomingEvents, doneEvents)
      ],
    );
  }

  Widget _eventsList(BuildContext context, List<DeadlineEvent> upcomingEvents,
      List<DeadlineEvent> doneEvents) {
    List<DeadlineEvent> thisWeek = context
        .watch<DeadlineEventProvider>()
        .getAllDeadlineEventsOfSubjThisWeek(
            widget.course != null ? widget.course!.termID : widget.term!.id!,
            widget.course != null ? widget.course!.id! : -1);

    return Column(
      children: [
        _dividerWithTitle(context, title: "THIS WEEK"),
        if (thisWeek.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InfoCard(content: "No upcoming events this week."),
          )
        else ...[
          ...thisWeek.map((d) => EventsCard(event: d)),
          SizedBox(
            height: 8,
          ),
        ],
        _dividerWithTitle(context, title: "UPCOMING EVENTS"),
        if (upcomingEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InfoCard(content: "No upcoming events."),
          )
        else ...[
          ...upcomingEvents.map((d) => EventsCard(
                event: d,
              )),
          SizedBox(
            height: 8,
          ),
        ],
        _dividerWithTitle(context, title: "PAST EVENTS"),
        if (doneEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InfoCard(content: "No past events."),
          )
        else
          ...doneEvents.map((d) => EventsCard(event: d))
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

  Widget _searchResults(BuildContext context) {
    List<DeadlineEvent> results = widget.course != null
        ? context
            .watch<DeadlineEventProvider>()
            .getAllDeadlineEventByCourse(widget.course!.id!)
        : context
            .watch<DeadlineEventProvider>()
            .getUnassignedDeadlineEventByTerm(widget.term!.id!);

    results = results
        .where((de) => de.description
            .toLowerCase()
            .contains(_searchCtrl.text.trim().toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Column(
        children: [
          ErrorCardNoAction(
              title: "Search Results", content: "No result found.")
        ],
      );
    }

    return Column(
      children: [
        ...results.map((d) => EventsCard(
              event: d,
            )),
        Center(
          child: Text(
            "${results.length} ${results.length == 1 ? "Event" : "Events"}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onInverseSurface),
          ),
        ),
      ],
    );
  }

  Widget _classTitleDesc(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.book_rounded,
                      size: C.cardIconSize,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    "Class",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: C.titleCardHeaderFontSize),
                  ),
                ],
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(
                      widget.course!.color[0],
                      widget.course!.color[1],
                      widget.course!.color[2],
                      widget.course!.color[3],
                    )),
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "${widget.course!.courseCode} - ${widget.course!.isLaboratory ? "Laboratory" : "Lecture"}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: C.titleCardContentFontSize,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          if (!(widget.course!.description == null ||
              widget.course!.description == ""))
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.course!.description ?? "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            )
        ],
      ),
    );
  }
}
