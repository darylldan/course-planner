import 'package:isar/isar.dart';

part 'Note.g.dart';

@collection
class Note {
  Id? id = Isar.autoIncrement;

  late int courseId;
  late String title;
  late String noteUUID;
}
