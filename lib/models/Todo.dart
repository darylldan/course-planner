import 'package:isar/isar.dart';

part 'Todo.g.dart';

@collection
class Todo {
  Id? id = Isar.autoIncrement;

  // Unassigned todo courseId: -1
  late int courseId;
  late int termId; // incase the todo is unassigned
  late String task;
  late bool isDone;
}
