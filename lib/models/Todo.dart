import 'package:isar/isar.dart';

part 'Todo.g.dart';

@collection
class Todo {
  Id? id = Isar.autoIncrement;

  late int courseId;
  late String task;
  late bool isDone;
}
