import 'package:isar/isar.dart';

part 'DeadlineEvent.g.dart';

@collection
class DeadlineEvent {
  Id? id = Isar.autoIncrement;

  late int courseId;
  String? description;
  late DateTime date;

  // How many minutes before to notify
  late int notifyPreference;
}
