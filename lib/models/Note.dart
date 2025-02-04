import 'package:isar/isar.dart';

part 'Note.g.dart';

@collection
class Note {
  Id? id = Isar.autoIncrement;

  // -1 courseId for unassigned notes
  late int courseId;
  late String title;
  late String content;
}
