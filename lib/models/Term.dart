import 'package:isar/isar.dart';

part 'Term.g.dart';

@collection
class Term {
  Id? id = Isar.autoIncrement;

  late String semester;
  late String academicYear;
}
