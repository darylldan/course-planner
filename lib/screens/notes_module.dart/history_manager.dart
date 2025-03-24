import 'dart:collection';
import 'package:course_planner/models/Note.dart';

// This class represents a snapshot of note state
class NoteSnapshot {
  final String title;
  final String content;
  final DateTime timestamp;

  NoteSnapshot({
    required this.title,
    required this.content,
    required this.timestamp,
  });

  // Factory to create snapshot from a Note
  factory NoteSnapshot.fromNote(Note note) {
    return NoteSnapshot(
      title: note.title,
      content: note.content,
      timestamp: DateTime.now(),
    );
  }
}

// History manager class
class NoteHistoryManager {
  final int maxHistorySize;

  final ListQueue<NoteSnapshot> _undoStack = ListQueue<NoteSnapshot>();
  final ListQueue<NoteSnapshot> _redoStack = ListQueue<NoteSnapshot>();

  // Current state (needed to avoid pushing duplicate states)
  NoteSnapshot? _currentState;

  NoteHistoryManager({this.maxHistorySize = 30});

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void pushState(Note note) {
    final newState = NoteSnapshot.fromNote(note);

    // Don't add if it's identical to current state
    if (_currentState != null &&
        _currentState!.title == newState.title &&
        _currentState!.content == newState.content) {
      return;
    }

    // Add current state to undo stack
    if (_currentState != null) {
      _undoStack.addLast(_currentState!);

      // Limit stack size
      if (_undoStack.length > maxHistorySize) {
        _undoStack.removeFirst();
      }
    }

    // Clear redo stack when new state is added
    _redoStack.clear();

    // Update current state
    _currentState = newState;
  }

  // Perform undo
  NoteSnapshot? undo(Note currentNote) {
    if (!canUndo) return null;

    // Save current state to redo stack
    _redoStack.addLast(_currentState!);

    // Get previous state
    _currentState = _undoStack.removeLast();

    return _currentState;
  }

  // Perform redo
  NoteSnapshot? redo() {
    if (!canRedo) return null;

    // Save current state to undo stack
    _undoStack.addLast(_currentState!);

    // Get next state
    _currentState = _redoStack.removeLast();

    return _currentState;
  }

  // Initialize with an initial state
  void initialize(Note initialNote) {
    _currentState = NoteSnapshot.fromNote(initialNote);
    _undoStack.clear();
    _redoStack.clear();
  }
}
