import 'package:course_planner/models/Note.dart';
import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';

class NoteProvider extends ChangeNotifier {
  late IsarService isarService;

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  NoteProvider() {
    isarService = IsarService();
    init();
  }

  void init() async {
    _notes = await isarService.getAllNotes();
    notifyListeners();
  }

  List<Note> getNotesBySubject(int courseId) {
    return _notes.where((n) => n.courseId == courseId).toList();
  }

  List<Note> getAllUnassignedNotes(int termId) {
    return _notes
    .where((n) => n.termId == termId)
    .where((n) => n.courseId == -1).toList();
  }

  Future<void> createNote(Note note) async {
    int? newId = await isarService.createNote(note);
    note.id = newId;
    _notes.add(note);

    notifyListeners();
  }

  Future<void> editNote(Note note) async {
    await isarService.editNote(note);
    _notes[_notes.indexWhere((n) => n.id == note.id)] = note;

    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await isarService.deleteNote(id);
    _notes.removeWhere((n) => n.id == id);

    notifyListeners();
  }
}
