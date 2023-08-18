import 'package:isar/isar.dart';

part 'UserSettings.g.dart';

@collection
class UserSettings {
  Id id = Isar.autoIncrement;

  int? currentTerm;
}
