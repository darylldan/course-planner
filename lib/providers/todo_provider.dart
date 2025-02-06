import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Todo.dart';
import 'package:flutter/foundation.dart';
import '../api/IsarService.dart';

class TodoProvider extends ChangeNotifier {
  late IsarService isarService;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  TodoProvider() {
    isarService = IsarService();
    init();
  }

  void init() async {
    _todos = await isarService.getAllTodos();
    notifyListeners();
  }

  List<Todo> getTodoBySubject(int courseId) {
    return _todos.where((t) => t.courseId == courseId).toList();
  }

  Todo getTodoById(int id) {
    return _todos.firstWhere((t) => t.id == id);
  }

  List<Todo> getAllUnassignedTodo() {
    return _todos.where((t) => t.courseId == -1).toList();
  }

  Future<List<Todo>> getAllUncompletedTodo(int termId) async {
    List<Subject> subjects = await isarService.getAllSubjects();

    return _todos
        .where((t) => t.courseId == -1
            ? t.termId == termId
            : subjects.firstWhere((s) => s.id == t.courseId).termID == termId)
        .where((t) => !t.isDone)
        .toList();
  }

  Future<void> editTodo(Todo todo) async {
    await isarService.editTodo(todo);
    _todos[_todos.indexWhere((t) => t.id == todo.id)] = todo;

    notifyListeners();
  }

  Future<void> deleteTodo(int id) async {
    await isarService.deleteTodo(id);
    _todos.removeWhere((t) => t.id == id);
  }
}
