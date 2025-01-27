import 'package:isar/isar.dart';

part 'User.g.dart';

@collection
class User {
  Id? id = Isar.autoIncrement;

  late String name;
  late String? bio;
  late String? school;
}
