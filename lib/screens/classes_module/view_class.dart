import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../models/Term.dart';
import '../../utils/constants.dart' as C;
import '../../utils/enums.dart';
import 'edit_class.dart';
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
    subject = context.watch<SubjectProvider>().getSubjectByID(widget.subjectID);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EditClass(
                            subject: subject,
                          ),));
            },
            icon: const Icon(Icons.edit_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildClassInfo(context),
        ),
      ),
    );
  }

  Widget _buildClassInfo(BuildContext context) {
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
          child: _schedule(context),
        ),
        if (subject.instructor != "" && subject.instructor != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _instructor(),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _term(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _notesWrapper(context),
        ),
        const SizedBox(height: 150,)
      ],
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
          child: _room(context),
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

  Widget _section(BuildContext context) {
    return Container(
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
                  Icons.groups_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
              ),
              Text(
                "Section",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
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
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
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
                  Icons.apartment_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Text(
                "Room",
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
              subject.room,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          )
        ],
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
          color: Theme.of(context).colorScheme.surfaceVariant),
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
          _stringifyFrequency(),
          _stringifyTimeslot(),
          _scheduleSummary()
        ],
      ),
    );
  }

  Widget _scheduleSummary() {
    String summary = "Each session lasts";

    Duration duration = subject.endDate.difference(subject.startDate);
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
        "${DateFormat.jm().format(subject.startDate)} - ${DateFormat.jm().format(subject.endDate)}",
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
        color: Theme.of(context).colorScheme.surfaceVariant,
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

  Widget _term(BuildContext context) {
    Term term = context.read<TermProvider>().getTermByID(subject.termID);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(C.cardBorderRadius),
        color: Theme.of(context).colorScheme.surfaceVariant,
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

  Widget _notesWrapper(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditNotes(
                          subject: subject,
                        )));
          },
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          child: _notes(context),
        ),
      ),
    );
  }

  Widget _notes(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
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
                      Icons.format_list_bulleted_rounded,
                      size: C.cardIconSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    "Notes",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: C.titleCardHeaderFontSize),
                  ),
                ],
              ),
              Text(
                "Tap to Edit",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _notesContainer(context)
        ],
      ),
    );
  }

  Widget _notesContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(C.cardBorderRadius),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              (subject.notes == null || subject.notes!.isEmpty)
                  ? "No notes."
                  : subject.notes!,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.surfaceVariant),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
