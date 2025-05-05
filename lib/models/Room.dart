import 'package:isar/isar.dart';

part 'Room.g.dart';

@collection
class Room {
  Id? id = Isar.autoIncrement;

  late int buildingId;
  late String roomName;
  String? notes;

  late double? long;
  late double? lat;
}
