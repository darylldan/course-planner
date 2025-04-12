import 'package:iskotrack/models/Note.dart';
import 'package:iskotrack/models/Subject.dart';
import 'package:iskotrack/models/Term.dart';
import 'package:iskotrack/providers/note_provider.dart';
import 'package:iskotrack/providers/subject_provider.dart';
import 'package:iskotrack/providers/term_provider.dart';
import 'package:iskotrack/screens/notes_module.dart/view_course_notes.dart';
import 'package:iskotrack/screens/notes_module.dart/view_note.dart';
import 'package:iskotrack/widgets/cards/course_notes_card.dart';
import 'package:iskotrack/widgets/cards/current_term_selected.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/elements/drawer.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _route = "/notes";

  Term? _termSelectorValue;
  Term? _currentTerm;
  bool? _onCurrentTerm = true;

  Term? _ncTermSelectorValue;
  int? _ncSubjectSelectorValue;

  @override
  Widget build(BuildContext context) {
    Term? currentTerm = context.watch<TermProvider>().currentTerm;
    _currentTerm ??= currentTerm;
    List<Term> terms = context.read<TermProvider>().terms;
    _ncTermSelectorValue ??= currentTerm;
    List<Subject> subjects = _currentTerm != null
        ? context.watch<SubjectProvider>().getSubjectsByTerm(_currentTerm!.id!)
        : [];

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Notes"),
            _body(context, currentTerm, subjects),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
      drawer: SideDrawer(parent: _route),
      floatingActionButton: _currentTerm == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showNoteCreator(context, terms),
              label: Row(
                children: [Icon(Icons.add), Text("Create Note")],
              )),
    );
  }

  void _showNoteCreator(BuildContext context, List<Term> terms) {
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
                        _ncTermSelectorValue?.id ?? _currentTerm!.id!);

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
                      "Create Note",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    const SizedBox(height: 20),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownMenu<int>(
                        width: 343,
                        initialSelection: _currentTerm!.id,
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
                          Navigator.pop(context);
                          // create a note, and then open the edit note screen
                          Note newNote = Note()
                            ..content = ""
                            ..title = ""
                            ..termId = _ncTermSelectorValue!.id!
                            ..courseId = _ncSubjectSelectorValue ?? -1
                            ..created = DateTime.now()
                            ..updated = DateTime.now();

                          int? newId = await context
                              .read<NoteProvider>()
                              .createNote(newNote);
                          newNote.id = newId;

                          if (context.mounted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewNote(note: newNote)));
                          }
                        },
                        child: const Text(
                          "Create Note",
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

  Widget _body(
      BuildContext context, Term? currentTerm, List<Subject> subjects) {
    if (currentTerm == null) {
      return InfoCard(
          content: "There are no terms yet. Create one via the terms screen.");
    }

    if (_onCurrentTerm == true) {
      _currentTerm = currentTerm;
    }

    return Column(
      children: [
        _buildCurrentTerm(context),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        _buildCourses(context, subjects)
      ],
    );
  }

  Widget _buildCourses(BuildContext context, List<Subject> subjects) {
    if (subjects.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: InfoCard(
                content:
                    "No courses yet. You can still create an unassigned note."),
          ),
          Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
          const SizedBox(
            height: 8,
          ),
          _unassignedNoteButton(context)
        ],
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _unassignedNoteButton(context),
      SizedBox(
        height: 6,
      ),
      ...subjects.map(
        (s) => ClassNotesCard(subject: s),
      ),
      Center(
        child: Text(
          "${subjects.length} ${subjects.length == 1 ? "Subject" : "Subjects"}",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onInverseSurface),
        ),
      ),
    ]);
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

  Widget _unassignedNoteButton(BuildContext context) {
    int noteCount = context
        .watch<NoteProvider>()
        .getAllUnassignedNotes(_currentTerm!.id!)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.tertiaryContainer)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewCourseNotes(
                                    termId: _currentTerm!.id!,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Unassigned Notes",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: Text(
                              noteCount.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    )))
          ],
        ),
      ],
    );
  }
}
