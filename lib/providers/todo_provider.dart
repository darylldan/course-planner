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

  List<Todo> getAllUnassignedTodo(int termId) {
    return _todos.where((t) => t.termId == termId && t.courseId == -1).toList();
  }

  List<Todo> getAllUncompletedTodo(int termId) {
    return _todos
        .where((t) => t.termId == termId && t.isDone == false)
        .toList();
  }

  List<Todo> getAllUncompletedUnassignedTodo(int termId) {
    return _todos
        .where(
            (t) => t.termId == termId && t.courseId == -1 && t.isDone == false)
        .toList();
  }

  List<Todo> getAllCompletedUnassignedTodo(int termId) {
    return _todos
        .where(
            (t) => t.termId == termId && t.courseId == -1 && t.isDone == true)
        .toList();
  }

  List<Todo> getAllUncompletedTodoByCourse(int termId, int courseId) {
    return _todos
        .where((t) =>
            t.termId == termId && t.courseId == courseId && t.isDone == false)
        .toList();
  }

  List<Todo> getAllCompletedTodoByCourse(int termId, int courseId) {
    return _todos
        .where((t) =>
            t.termId == termId && t.courseId == courseId && t.isDone == true)
        .toList();
  }

  List<Todo> getAllUnassignedCompletedTodo(int termId) {
    return _todos
        .where(
            (t) => t.termId == termId && t.courseId == -1 && t.isDone == true)
        .toList();
  }

  Future<int?> addTodo(Todo todo) async {
    int? newId = await isarService.createTodo(todo);
    todo.id = newId;
    _todos.add(todo);

    notifyListeners();
    return newId;
  }

  Future<void> editTodo(Todo todo) async {
    await isarService.editTodo(todo);
    _todos[_todos.indexWhere((t) => t.id == todo.id)] = todo;

    notifyListeners();
  }

  Future<void> deleteTodo(int id) async {
    await isarService.deleteTodo(id);
    _todos.removeWhere((t) => t.id == id);

    notifyListeners();
  }
}
