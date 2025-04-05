import 'package:isar/isar.dart';

part 'DeadlineEvent.g.dart';

@collection
class DeadlineEvent {
  Id? id = Isar.autoIncrement;

  late int courseId;
  late int termId;
  late String description;
  late DateTime date;
}
