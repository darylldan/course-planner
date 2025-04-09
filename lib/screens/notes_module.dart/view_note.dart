import 'dart:async';

import 'package:course_planner/models/Note.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/note_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/notes_module.dart/history_manager.dart';
import 'package:course_planner/utils/extensions.dart';
import 'package:course_planner/utils/methods.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/constants.dart' as C;

class ViewNote extends StatefulWidget {
  final Note note;
  Subject? subject;
  ViewNote({super.key, required this.note, this.subject});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  Term? _ncTermSelectorValue;
  int? _ncSubjectSelectorValue;
  late String _title;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtrl = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final TextEditingController _notesCtrl = TextEditingController();

  final NoteHistoryManager _historyManager = NoteHistoryManager();

  // Last tracked state
  String _lastTrackedTitle = '';
  String _lastTrackedContent = '';
  bool _hasSignificantChanges = false;

  Timer? _saveTimer;
  Timer? _historyTimer;

  void _setNotes(BuildContext context) {
    _saveTimer?.cancel();

    _saveTimer = Timer(const Duration(seconds: 2), () {
      Note newNote = widget.note
        ..content = _notesCtrl.text
        ..title = _titleCtrl.text
        ..updated = DateTime.now();

      context.read<NoteProvider>().editNote(newNote);
    });
  }

  void _setupPeriodicHistoryCheck() {
    // Check every 5 seconds if there are significant changes to capture
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_hasSignificantChanges) {
        _captureCurrentState();
        _hasSignificantChanges = false;
      }
    });
  }

  void _onTitleFocusChanged() {
    // If title loses focus, check for changes
    if (!_titleFocusNode.hasFocus && _titleCtrl.text != _lastTrackedTitle) {
      _captureCurrentState();
    }
  }

  void _onTitleChanged() {
    // Start the save timer
    setNotes(context);

    // If significant title change (more than just a character or two)
    if ((_titleCtrl.text.length - _lastTrackedTitle.length).abs() > 3) {
      _hasSignificantChanges = true;
    }
  }

  void _onContentChanged() {
    // Start the save timer
    setNotes(context);

    // Cancel any pending history timer
    _historyTimer?.cancel();

    // Set new history timer with appropriate delay
    _historyTimer = Timer(Duration(seconds: 2), () {
      // Check for significant content changes
      if (_isSignificantContentChange()) {
        _captureCurrentState();
      }
    });
  }

  bool _isSignificantContentChange() {
    // Define what constitutes a "significant" change
    final currentContent = _notesCtrl.text;
    final lastContent = _lastTrackedContent;

    // If length difference is substantial
    if ((currentContent.length - lastContent.length).abs() > 15) {
      return true;
    }

    // If a new paragraph was added (contains extra newline)
    if (currentContent.split('\n').length != lastContent.split('\n').length) {
      return true;
    }

    // If significant time passed since last capture (handled by periodic check)
    return false;
  }

  void _captureCurrentState() {
    Note currentNote = widget.note.copyWith(
      content: _notesCtrl.text,
      title: _titleCtrl.text,
    );

    _historyManager.pushState(currentNote);

    // Update tracked state
    _lastTrackedTitle = _titleCtrl.text;
    _lastTrackedContent = _notesCtrl.text;
    _hasSignificantChanges = false;
  }

  void setNotes(BuildContext context) {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () {
      Note newNote = widget.note.copyWith(
        content: _notesCtrl.text,
        title: _titleCtrl.text,
        updated: DateTime.now(),
      );

      // Save to database
      context.read<NoteProvider>().editNote(newNote);
    });
  }

  // Force history capture before undo/redo
  void _prepareForHistoryOperation() {
    _historyTimer?.cancel();
    _captureCurrentState();
  }

  // Implement undo
  void _handleUndo() {
    _prepareForHistoryOperation();
    final snapshot = _historyManager.undo(widget.note);
    if (snapshot != null) {
      setState(() {
        _titleCtrl.text = snapshot.title;
        _notesCtrl.text = snapshot.content;

        // Update tracked state
        _lastTrackedTitle = snapshot.title;
        _lastTrackedContent = snapshot.content;
      });

      // Force a save after undo
      Note newNote = widget.note.copyWith(
        content: snapshot.content,
        title: snapshot.title,
        updated: DateTime.now(),
      );

      context.read<NoteProvider>().editNote(newNote);
    }
  }

  // Implement redo (similar to undo)
  void _handleRedo() {
    _prepareForHistoryOperation();
    final snapshot = _historyManager.redo();
    if (snapshot != null) {
      setState(() {
        _titleCtrl.text = snapshot.title;
        _notesCtrl.text = snapshot.content;

        // Update tracked state
        _lastTrackedTitle = snapshot.title;
        _lastTrackedContent = snapshot.content;
      });

      // Force a save after redo
      Note newNote = widget.note.copyWith(
        content: snapshot.content,
        title: snapshot.title,
        updated: DateTime.now(),
      );

      context.read<NoteProvider>().editNote(newNote);
    }
  }

  @override
  void initState() {
    super.initState();
    _titleCtrl.text = widget.note.title;
    _notesCtrl.text = widget.note.content;
    _title = widget.subject?.courseCode ?? "Unassigned Note";

    _historyManager.initialize(widget.note);

    _lastTrackedTitle = widget.note.title;
    _lastTrackedContent = widget.note.content;

    // Add listeners
    _titleCtrl.addListener(_onTitleChanged);
    _notesCtrl.addListener(_onContentChanged);

    // Add title focus listener
    _titleFocusNode.addListener(_onTitleFocusChanged);

    // Set up periodic history snapshot checker
    _setupPeriodicHistoryCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _historyManager.canUndo ? _handleUndo : null,
            icon: Icon(Icons.undo),
            tooltip: "Undo",
          ),
          IconButton(
            onPressed: _historyManager.canRedo ? _handleRedo : null,
            icon: Icon(Icons.redo),
            tooltip: "Redo",
          ),
          IconButton(
            onPressed: () => _showNoteOrganizer(context),
            icon: Icon(Icons.folder_open),
            tooltip: "Organize",
          ),
          IconButton(
            onPressed: () async {
              ShareResult res = await mdToPDF(
                  title:
                      "${_titleCtrl.text.isEmpty ? "Untitled Note" : _titleCtrl.text} - ${widget.subject != null ? "${widget.subject!.courseCode} - ${widget.subject!.isLaboratory ? "Lab" : "Lec"}" : ""}",
                  md: _notesCtrl.text.replaceAll("’", "'"));

              if (res.status == ShareResultStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Note saved as PDF.")));
              }
            },
            icon: Icon(Icons.picture_as_pdf),
            tooltip: "Save as PDF",
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Edit Note"),
            _buildTitleEditor(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(),
            ),
            _buildNoteEditor(context)
          ],
        ),
      ),
    );
  }

  Widget _buildTitleEditor(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        _saveTimer?.cancel();
        Note newNote = widget.note.copyWith(
          content: _notesCtrl.text,
          title: _titleCtrl.text,
          updated: DateTime.now(),
        );
        context.read<NoteProvider>().editNote(newNote);

        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDecorator(
              decoration: InputDecoration.collapsed(
                hintText: "Enter title here...",
                hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              isFocused: _titleFocusNode.hasFocus,
              isEmpty: _titleCtrl.text.isEmpty,
              child: EditableText(
                controller: _titleCtrl,
                focusNode: _titleFocusNode,
                maxLines: null,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface),
                cursorColor: Theme.of(context).colorScheme.onSurface,
                backgroundCursorColor: Colors.transparent,
                onChanged: (String val) {
                  setState(() {});
                },
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.deny('\n'), // Prevent newlines
                ],
                onSubmitted: (val) {
                  // This is fired when Enter is pressed
                  _titleFocusNode.unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteEditor(BuildContext context) {
    return MarkdownAutoPreview(
      controller: _notesCtrl,
      decoration: InputDecoration.collapsed(
        hintText: "Enter your notes here...",
      ),
      toolbarBackground: Theme.of(context).colorScheme.tertiaryContainer,
      style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface, fontSize: 15),
      hintText: "Enter your notes here...",
      onChanged: (String val) => _setNotes(context),
    );
  }

  void _showNoteOrganizer(BuildContext context) {
    List<Term> terms = context.read<TermProvider>().terms;
    Term? currentTerm = context.read<TermProvider>().currentTerm;

    _ncTermSelectorValue ??= currentTerm;
    if (widget.subject != null) {
      _ncSubjectSelectorValue = widget.subject!.id!;
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
                            ..title = _titleCtrl.text
                            ..content = _notesCtrl.text
                            ..termId = _ncTermSelectorValue!.id!
                            ..courseId = _ncSubjectSelectorValue ?? -1
                            ..updated = DateTime.now();

                          context.read<NoteProvider>().editNote(editedNote);

                          setState(() {
                            if (_ncSubjectSelectorValue == null) {
                              _title = "Unassigned Note";
                            } else {
                              Subject newSubject = context
                                  .read<SubjectProvider>()
                                  .getSubjectByID(_ncSubjectSelectorValue!);
                              widget.subject = newSubject;
                              _title = newSubject.courseCode;
                            }
                          });

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

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    _titleFocusNode.dispose();
    _saveTimer?.cancel();
    _historyTimer?.cancel();
    super.dispose();
  }
}
