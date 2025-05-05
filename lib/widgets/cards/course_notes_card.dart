import 'package:iskotrack/models/Subject.dart';
import 'package:iskotrack/providers/note_provider.dart';
import 'package:iskotrack/screens/notes_module.dart/view_course_notes.dart';
import 'package:iskotrack/utils/enums.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassNotesCard extends StatefulWidget {
  final Subject subject;
  const ClassNotesCard({super.key, required this.subject});

  @override
  State<ClassNotesCard> createState() => _ClassNotesCardState();
}

class _ClassNotesCardState extends State<ClassNotesCard> {
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
                      builder: (context) => ViewCourseNotes(
                            subject: widget.subject,
                            termId: widget.subject.termID,
                          )));
            },
            child: _subjectContainer(context),
          ),
        ),
      ),
    );
  }

  Widget _subjectContainer(BuildContext context) {
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
                        color: Color.fromARGB(
                          widget.subject.color[0],
                          widget.subject.color[1],
                          widget.subject.color[2],
                          widget.subject.color[3],
                        )),
                    width: 4,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.subject.courseCode} - ${widget.subject.isLaboratory ? 'Laboratory' : 'Lecture'}",
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
                          constraints: BoxConstraints(maxWidth: 60),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              borderRadius: BorderRadius.circular(4)),
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                widget.subject.section,
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
                        _buildSubjectSubtitle(context),
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
          _notesCount(context)
        ],
      ),
    );
  }

  Widget _notesCount(BuildContext context) {
    int count =
        context.watch<NoteProvider>().getNotesCountByCourse(widget.subject.id!);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inverseSurface),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Text(
        count > 99 ? "99+" : count.toString(),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).colorScheme.onInverseSurface),
      ),
    );
  }

  Widget _buildSubjectSubtitle(BuildContext context) {
    String subTitle = "";

    if (!haveSchedule) {
      return SizedBox(
        width: 155,
        child: Text(
          "No schedule",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12),
        ),
      );
    }

    for (var d in widget.subject.frequency) {
      switch (d) {
        case Day.mon:
          subTitle = "${subTitle}Mo";
        case Day.tue:
          subTitle = "${subTitle}Tu";
        case Day.wed:
          subTitle = "${subTitle}We";
        case Day.thu:
          subTitle = "${subTitle}Th";
        case Day.fri:
          subTitle = "${subTitle}Fr";
        case Day.sat:
          subTitle = "${subTitle}Sa";
      }
    }

    String startDate = DateFormat.jm().format(widget.subject.startDate!);
    String endDate = DateFormat.jm().format(widget.subject.endDate!);

    subTitle = "$subTitle $startDate - $endDate";

    return SizedBox(
      width: 155,
      child: Text(
        subTitle,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12),
      ),
    );
  }

  bool get haveSchedule =>
      widget.subject.frequency.isNotEmpty &&
      widget.subject.startDate != null &&
      widget.subject.endDate != null;
}
