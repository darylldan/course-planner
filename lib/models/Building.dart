import 'package:isar/isar.dart';

part 'Building.g.dart';

@collection
class Building {
  Id? id = Isar.autoIncrement;

  late String buildingName;
  late double? longitude;
  late double? latitude;
  String? notes;
}
