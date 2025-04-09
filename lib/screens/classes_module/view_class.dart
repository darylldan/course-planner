import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/CourseGrade.dart';
import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/providers/building_provider.dart';
import 'package:course_planner/providers/course_grade_provider.dart';
import 'package:course_planner/providers/deadlineevent_provider.dart';
import 'package:course_planner/providers/note_provider.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/providers/todo_provider.dart';
import 'package:course_planner/screens/classes_module/add_class.dart';
import 'package:course_planner/screens/events_module/view_course_event.dart';
import 'package:course_planner/screens/grades_module/view_course_grade.dart';
import 'package:course_planner/screens/misc/view_location.dart';
import 'package:course_planner/screens/notes_module.dart/view_course_notes.dart';
import 'package:course_planner/screens/todo_module/view_course_todo.dart';
import 'package:course_planner/widgets/cards/events_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/location_card.dart';
import 'package:course_planner/widgets/cards/quick_notes_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../models/Term.dart';
import '../../utils/constants.dart' as C;
import '../../utils/enums.dart';
import 'edit_notes.dart';

class ViewClass extends StatefulWidget {
  final int subjectID;
  const ViewClass({super.key, required this.subjectID});

  @override
  State<ViewClass> createState() => _ViewClassState();
}

class _ViewClassState extends State<ViewClass> {
  final _screenTitle = "View Class";
  late Subject subject;

  @override
  Widget build(BuildContext context) {
    List<Term> terms = context.watch<TermProvider>().terms;
    subject = context.watch<SubjectProvider>().getSubjectByID(widget.subjectID);

    Term term = context.read<TermProvider>().getTermByID(subject.termID);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddClass(
                      terms: terms,
                      course: subject,
                      editMode: true,
                    ),
                  ));
            },
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () {},
            tooltip: "Share this Course",
            icon: Icon(Icons.share),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildClassInfo(context, term),
        ),
      ),
    );
  }

  Widget _buildClassInfo(BuildContext context, Term term) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _classTitleDesc(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _sectionRoomRow(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _room(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _schedule(context),
        ),
        if (subject.instructor != "" && subject.instructor != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _instructor(),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _term(context, term),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: QuickNotesCard(
            notes: subject.notes,
            id: subject.id!,
            type: "subject",
            name: subject.courseCode,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _dividerWithTitle(context, title: "EVENTS THIS WEEK"),
        ),
        _events(context),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _dividerWithTitle(context, title: "SHORTCUTS"),
        ),
        _shortcuts(context, term),
        const SizedBox(
          height: 150,
        )
      ],
    );
  }

  Widget _shortcuts(BuildContext context, Term term) {
    CourseGrade cg =
        context.watch<CourseGradeProvider>().getCourseGradeByCourse(subject);

    String grade = "";

    if (cg.grade != null) {
      String gs = GradeMethods.getStringValue(cg.grade!);

      if (gs == "Incomplete") {
        grade = "INC";
      } else if (gs == "Dropped") {
        grade = "DRP";
      } else {
        grade = gs;
      }
    } else if (cg.nonNumericalGrade != null) {
      grade = cg.nonNumericalGrade == NonNumericalGrade.s ? "S" : "US";
    } else {
      grade = "--";
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _shortcutButton(
                  context,
                  "Notes",
                  context
                      .watch<NoteProvider>()
                      .getNotesCountByCourse(subject.id!)
                      .toString(),
                  MaterialPageRoute(
                      builder: (context) => ViewCourseNotes(
                            termId: subject.termID,
                            subject: subject,
                          )),
                  Icons.library_books),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: _shortcutButton(
                  context,
                  "To-Do",
                  context
                      .watch<TodoProvider>()
                      .getAllUncompletedTodoByCourse(term.id!, subject.id!)
                      .length
                      .toString(),
                  MaterialPageRoute(
                      builder: (context) => ViewCourseTodo(
                            term: term,
                            course: subject,
                          )),
                  Icons.check_box_rounded),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _shortcutButton(
                  context,
                  "Events",
                  context
                      .watch<DeadlineEventProvider>()
                      .getAllUpcomingDeadlineEventsForSubject(subject.id!)
                      .length
                      .toString(),
                  MaterialPageRoute(
                      builder: (context) => ViewCourseEvent(
                            course: subject,
                            term: term,
                          )),
                  Icons.event),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: _shortcutButton(
                  context,
                  "Grade",
                  grade,
                  MaterialPageRoute(
                      builder: (context) => ViewCourseGrade(
                            term: term,
                          )),
                  Icons.grading),
            ),
          ],
        )
      ],
    );
  }

  Widget _shortcutButton(BuildContext context, String title, String bigText,
      Route route, IconData icon) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () => Navigator.push(context, route),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiaryContainer),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      bigText,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                    Row(
                      children: [
                        Icon(
                          icon,
                          size: 24,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 28,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _events(BuildContext context) {
    List<DeadlineEvent> events = context
        .watch<DeadlineEventProvider>()
        .getAllDeadlineEventsOfSubjThisWeek(subject.termID, subject.id!);

    if (events.isEmpty) {
      return InfoCard(content: "Course has no events this week.");
    }

    return Column(
      children: events.map((e) => EventsCard(event: e)).toList(),
    );
  }

  Widget _sectionRoomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: _section(context),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 2,
          child: _units(context),
        )
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
                      subject.color[0],
                      subject.color[1],
                      subject.color[2],
                      subject.color[3],
                    )),
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "${subject.courseCode} - ${subject.isLaboratory ? "Laboratory" : "Lecture"}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: C.titleCardContentFontSize,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          if (!(subject.description == null || subject.description == ""))
            SizedBox(
              width: double.infinity,
              child: Text(
                subject.description ?? "",
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

  Widget _units(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.secondaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.punch_clock,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Text(
                "Units",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "${subject.units} (${subject.credited ? "Credited" : "Non-Credited"})",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _section(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(subject.section)));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.secondaryContainer),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.groups_rounded,
                    size: C.cardIconSize,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  "Section",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: C.titleCardHeaderFontSize),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                subject.section,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _room(BuildContext context) {
    LatLng? coords;
    Object? loc;
    Building? suppl;

    if (subject.locationType == "bldg") {
      Building bldg =
          context.read<BuildingProvider>().getBuildingByID(subject.locationID!);

      if (bldg.latitude != null && bldg.longitude != null) {
        coords = LatLng(bldg.latitude!, bldg.longitude!);
        loc = bldg;
      }
    } else if (subject.locationType == "room") {
      Room room = context.read<RoomProvider>().getRoomByID(subject.locationID!);
      Building bldg =
          context.read<BuildingProvider>().getBuildingByID(room.buildingId);

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

    return Material(
      borderRadius: BorderRadius.circular(C.cardBorderRadius),
      clipBehavior: Clip.hardEdge,
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.onTertiaryContainer),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: coords != null
              ? () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewLocation(coords: coords!)));
                }
              : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(C.cardBorderRadius),
                color: Theme.of(context).colorScheme.tertiaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.apartment_rounded,
                        size: C.cardIconSize,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                    Text(
                      "Location",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          fontSize: C.titleCardHeaderFontSize),
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
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
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
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _schedule(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.onInverseSurface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.calendar_view_day_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                "Schedule",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          if (!haveSchedule)
            SizedBox(
              width: double.infinity,
              child: Text(
                "No schedule",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            )
          else ...[
            _stringifyFrequency(),
            _stringifyTimeslot(),
            _scheduleSummary()
          ]
        ],
      ),
    );
  }

  Widget _scheduleSummary() {
    String summary = "Each session lasts";

    Duration duration = subject.endDate!.difference(subject.startDate!);
    if (duration.inHours == 0) {
      summary =
          "$summary ${duration.inMinutes % 60} ${duration.inMinutes % 60 > 1 ? "minutes" : "minute"}";
    } else {
      summary =
          "$summary ${duration.inHours} ${duration.inHours > 1 ? "hours" : "hour"}";
      if (duration.inMinutes % 60 > 0) {
        summary =
            "$summary and ${duration.inMinutes % 60} ${duration.inMinutes % 60 > 1 ? "minutes" : "minute"}";
      }
    }

    switch (subject.frequency.length) {
      case 1:
        summary = "$summary, occuring once per week";
      case 2:
        summary = "$summary, occuring twice per week";
      case 3:
        summary = "$summary, occuring thrice per week";
      case 4:
        summary = "$summary, occuring four times per week";
      case 5:
        summary = "$summary, occuring five times per week";
      case 6:
        summary = "$summary, occuring every day of the week except Sunday";
    }

    int totalMinutes = duration.inMinutes * subject.frequency.length;
    if (totalMinutes ~/ 60 == 0) {
      summary =
          "$summary for a total of $totalMinutes ${totalMinutes > 1 ? "minutes" : "minute"}";
    } else {
      summary =
          "$summary for a total of ${totalMinutes ~/ 60} ${totalMinutes ~/ 60 > 1 ? "hours" : "hour"}";

      if (totalMinutes % 60 > 0) {
        summary =
            "$summary and ${totalMinutes % 60} ${totalMinutes % 60 > 1 ? "minutes" : "minute"}";
      }
    }

    summary = "$summary weekly.";

    return SizedBox(
      width: double.infinity,
      child: Text(
        summary,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _stringifyTimeslot() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        "${DateFormat.jm().format(subject.startDate!)} - ${DateFormat.jm().format(subject.endDate!)}",
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
    );
  }

  Widget _stringifyFrequency() {
    String freqString = "Every";

    switch (subject.frequency.length) {
      case 1:
        switch (subject.frequency[0]) {
          case Day.mon:
            freqString = "$freqString Monday";
          case Day.tue:
            freqString = "$freqString Tuesday";
          case Day.wed:
            freqString = "$freqString Wednesday";
          case Day.thu:
            freqString = "$freqString Thursday";
          case Day.fri:
            freqString = "$freqString Friday";
          case Day.sat:
            freqString = "$freqString Saturday";
        }
      case 2:
        for (int i = 0; i < 2; i++) {
          switch (subject.frequency[i]) {
            case Day.mon:
              freqString = "$freqString Monday";
            case Day.tue:
              freqString = "$freqString Tuesday";
            case Day.wed:
              freqString = "$freqString Wednesday";
            case Day.thu:
              freqString = "$freqString Thursday";
            case Day.fri:
              freqString = "$freqString Friday";
            case Day.sat:
              freqString = "$freqString Saturday";
          }

          if (i == 0) freqString = "$freqString and";
        }
      default:
        freqString = "$freqString ";
        for (var d in subject.frequency) {
          switch (d) {
            case Day.mon:
              freqString = "${freqString}Mo";
            case Day.tue:
              freqString = "${freqString}Tu";
            case Day.wed:
              freqString = "${freqString}We";
            case Day.thu:
              freqString = "${freqString}Th";
            case Day.fri:
              freqString = "${freqString}Fr";
            case Day.sat:
              freqString = "${freqString}Sa";
          }
        }
    }

    return SizedBox(
      width: double.infinity,
      child: Text(
        freqString,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 22),
      ),
    );
  }

  Widget _instructor() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(C.cardBorderRadius),
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.person_pin_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                "Instructor",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              subject.instructor!,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          )
        ],
      ),
    );
  }

  Widget _term(BuildContext context, Term term) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(C.cardBorderRadius),
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                "Term",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              term.semester,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              term.academicYear,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          )
        ],
      ),
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

  bool get haveSchedule =>
      subject.frequency.isNotEmpty &&
      subject.startDate != null &&
      subject.endDate != null;
}
