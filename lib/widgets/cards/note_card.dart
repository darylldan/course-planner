import 'package:iskotrack/models/Note.dart';
import 'package:iskotrack/models/Subject.dart';
import 'package:iskotrack/models/Term.dart';
import 'package:iskotrack/providers/note_provider.dart';
import 'package:iskotrack/providers/subject_provider.dart';
import 'package:iskotrack/providers/term_provider.dart';
import 'package:iskotrack/screens/notes_module.dart/view_note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class NotesCard extends StatefulWidget {
  final Note note;
  const NotesCard({super.key, required this.note});

  @override
  State<NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  Term? _ncTermSelectorValue;
  int? _ncSubjectSelectorValue;

  @override
  Widget build(BuildContext context) {
    Subject? subject = widget.note.courseId == -1
        ? null
        : context.read<SubjectProvider>().getSubjectByID(widget.note.courseId);

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
                      builder: (context) => ViewNote(
                            note: widget.note,
                            subject: subject,
                          )));
            },
            onLongPress: () {
              _showActions(context);
            },
            child: _noteCardContainer(context, subject),
          ),
        ),
      ),
    );
  }

  Widget _noteCardContainer(BuildContext context, Subject? subject) {
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
                        color: subject == null
                            ? Theme.of(context).colorScheme.inverseSurface
                            : Color.fromARGB(
                                subject.color[0],
                                subject.color[1],
                                subject.color[2],
                                subject.color[3],
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
                        widget.note.title == ""
                            ? "Untitled Note"
                            : widget.note.title,
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
                              EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              borderRadius: BorderRadius.circular(4)),
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                formatDateTime(widget.note.updated),
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
                            widget.note.content == ""
                                ? "Empty note"
                                : "${widget.note.content.substring(0, (!widget.note.content.contains('\n')) ? widget.note.content.length : widget.note.content.indexOf('\n')).trimLeft()}...",
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
          IconButton(
            onPressed: () {
              _showActions(context);
            },
            icon: Icon(Icons.more_vert_rounded),
          )
        ],
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime weekStart = today.subtract(
        Duration(days: today.weekday - 1)); // Start of the week (Monday)

    if (dateTime.isAfter(today)) {
      return DateFormat("h:mm a").format(dateTime); // Show only time if today
    } else if (dateTime.isAfter(weekStart)) {
      return DateFormat("E")
          .format(dateTime); // Show day name if within this week
    } else {
      return DateFormat("MM/dd/yy").format(dateTime); // Show MM/DD/YY otherwise
    }
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
                  title: const Text("Organize Note"),
                  leading: const Icon(Icons.folder_open),
                  onTap: () {
                    Navigator.pop(context);
                    _showNoteOrganizer(context);
                  },
                ),
                ListTile(
                  title: const Text("Delete Note"),
                  leading: const Icon(Icons.delete_forever_rounded),
                  onTap: () {
                    context.read<NoteProvider>().deleteNote(widget.note.id!);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Note deleted."),
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

  void _showNoteOrganizer(BuildContext context) {
    List<Term> terms = context.read<TermProvider>().terms;
    Term? currentTerm = context.read<TermProvider>().currentTerm;

    _ncTermSelectorValue ??= currentTerm;
    if (widget.note.courseId != -1) {
      _ncSubjectSelectorValue = widget.note.courseId;
    }

    List<DropdownMenuEntry<int>> termEntries = [];

    // Generate term entries outside the modal (static)
    for (var t in terms) {
      String label = "${t.semester}, ${t.academicYear}";
      if (label.length > 36) label = "${label.substring(0, 37)}...";
      termEntries.add(
        DropdownMenuEntry(
          value: t.id!,
          label: label,
          trailingIcon: t.isCurrentTerm ? Icon(Icons.star_rounded) : null,
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            List<Subject> subjects =
                Provider.of<SubjectProvider>(context, listen: false)
                    .getSubjectsByTerm(
                        _ncTermSelectorValue?.id ?? currentTerm!.id!);

            List<DropdownMenuEntry<int?>> subjectEntries = [];
            for (var s in subjects) {
              String label =
                  "${s.courseCode} - ${s.isLaboratory ? "Laboratory" : "Lecture"}";
              if (label.length > 36) label = "${label.substring(0, 37)}...";
              subjectEntries.add(DropdownMenuEntry(value: s.id!, label: label));
            }
            subjectEntries
                .add(DropdownMenuEntry(value: null, label: "Unassigned"));

            return SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: C.screenHorizontalPadding, vertical: 24),
                child: Column(
                  children: [
                    const Text(
                      "Organize Note",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    const SizedBox(height: 20),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownMenu<int>(
                        width: 343,
                        initialSelection: currentTerm!.id,
                        inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        label: const Text("Terms"),
                        dropdownMenuEntries: termEntries,
                        onSelected: (int? termID) {
                          setModalState(() {
                            _ncTermSelectorValue = context
                                .read<TermProvider>()
                                .getTermByID(termID!);
                            // Regenerate subjects list when term changes
                            subjects = Provider.of<SubjectProvider>(context,
                                    listen: false)
                                .getSubjectsByTerm(termID);
                            _ncSubjectSelectorValue =
                                null; // Reset subject selection
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownMenu<int?>(
                        width: 343,
                        initialSelection: _ncSubjectSelectorValue,
                        inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        label: const Text("Course"),
                        dropdownMenuEntries: subjectEntries,
                        onSelected: (int? subjectId) {
                          setModalState(() {
                            _ncSubjectSelectorValue = subjectId;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.primaryContainer),
                            foregroundColor: WidgetStatePropertyAll(
                                Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                        onPressed: () async {
                          Note editedNote = widget.note
                            ..termId = _ncTermSelectorValue!.id!
                            ..courseId = _ncSubjectSelectorValue ?? -1
                            ..updated = DateTime.now();

                          context.read<NoteProvider>().editNote(editedNote);

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Note reorganized.")));
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.onInverseSurface),
                            foregroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.inverseSurface)),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
