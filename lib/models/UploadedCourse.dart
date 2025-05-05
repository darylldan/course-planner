import 'package:isar/isar.dart';

part 'UploadedCourse.g.dart';

@collection
class UploadedCourse {
  Id? id = Isar.autoIncrement;

  late String documentId;
  late String hash;
}
