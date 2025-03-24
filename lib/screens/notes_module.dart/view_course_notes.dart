import 'package:course_planner/models/Note.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/note_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/misc/edit_quick_notes.dart';
import 'package:course_planner/screens/notes_module.dart/view_note.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/note_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class ViewCourseNotes extends StatefulWidget {
  final Subject? subject;
  final int termId;

  const ViewCourseNotes({super.key, this.subject, required this.termId});

  @override
  State<ViewCourseNotes> createState() => _ViewCourseNotesState();
}

class _ViewCourseNotesState extends State<ViewCourseNotes> {
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
                title:
                    widget.subject != null ? "View Notes" : "Unassigned Notes"),
            if (widget.subject != null) ...[
              _classTitleDesc(context),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
            ],
            _buildNotesCard(context)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Note newNote = Note()
              ..content = ""
              ..title = ""
              ..courseId = widget.subject == null ? -1 : widget.subject!.id!
              ..termId = widget.termId
              ..created = DateTime.now()
              ..updated = DateTime.now();

            int? newId = await context.read<NoteProvider>().createNote(newNote);
            newNote.id = newId;

            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewNote(note: newNote, subject: widget.subject,)));
            }
          },
          label: Row(
            children: [Icon(Icons.add), Text("Create Note")],
          )),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    List<Note> notes = widget.subject == null
        ? context.watch<NoteProvider>().getAllUnassignedNotes(widget.termId)
        : context.watch<NoteProvider>().getNotesBySubject(widget.subject!.id!);

    if (notes.isEmpty) {
      return InfoCard(content: "No notes yet. Create one below.");
    }

    notes.sort((a, b) => b.updated.compareTo(a.updated));

    return Column(
      children: [
        ...notes.map(
          (n) => NotesCard(note: n),
        ),
        Center(
          child: Text(
            "${notes.length} ${notes.length == 1 ? "Note" : "Notes"}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onInverseSurface),
          ),
        ),
        SizedBox(
          height: 150,
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
                      widget.subject!.color[0],
                      widget.subject!.color[1],
                      widget.subject!.color[2],
                      widget.subject!.color[3],
                    )),
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "${widget.subject!.courseCode} - ${widget.subject!.isLaboratory ? "Laboratory" : "Lecture"}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: C.titleCardContentFontSize,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          if (!(widget.subject!.description == null ||
              widget.subject!.description == ""))
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.subject!.description ?? "",
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
