import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/deadlineevent_provider.dart';
import 'package:course_planner/screens/events_module/add_event.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/widgets/cards/error_card_no_action.dart';
import 'package:course_planner/widgets/cards/events_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class ViewAllEvents extends StatefulWidget {
  final ViewEventType eventType;
  final Term term;

  const ViewAllEvents({super.key, required this.eventType, required this.term});

  @override
  State<ViewAllEvents> createState() => _ViewAllEventsState();
}

class _ViewAllEventsState extends State<ViewAllEvents> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
                title: widget.eventType == ViewEventType.past
                    ? "Past Events"
                    : "Upcoming Events"),
            _body(context)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEvent(
                          currTerm: widget.term,
                        )));
          },
          label: Row(
            children: [Icon(Icons.add), Text("Create Event")],
          )),
    );
  }

  Widget _body(BuildContext context) {
    List<DeadlineEvent> events = widget.eventType == ViewEventType.past
        ? context
            .read<DeadlineEventProvider>()
            .getAllPastDeadlineEvents(widget.term.id!)
        : context
            .read<DeadlineEventProvider>()
            .getAllUpcomingDeadlineEvents(widget.term.id!);

    if (events.isEmpty) {
      return InfoCard(content: "No events yet. Create one below.");
    }

    if (_searchCtrl.text.isNotEmpty) {
      events = events
          .where((e) => e.description
              .toLowerCase()
              .contains(_searchCtrl.text.toLowerCase()))
          .toList();
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
        if (_searchCtrl.text.isNotEmpty && events.isEmpty)
          ErrorCardNoAction(
              title: "Search Resullt", content: "No result found.")
        else ...[
          ...events.map((e) => EventsCard(event: e)),
          Center(
            child: Text(
              "${events.length} ${events.length == 1 ? "Event" : "Events"}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onInverseSurface),
            ),
          ),
        ]
      ],
    );
  }
}
