import 'package:iskotrack/models/Room.dart';
import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';

class RoomProvider extends ChangeNotifier {
  late IsarService isarService;

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  RoomProvider() {
    isarService = IsarService();
    init();
  }

  void load() {
    return;
  }

  void init() async {
    _rooms = await isarService.getAllRooms();
    notifyListeners();
  }

  Room getRoomByID(int id) {
    return _rooms.firstWhere((element) => element.id == id);
  }

  List<Room> getAllRoomsInBuilding(int buildingId) {
    return _rooms.where((element) => element.buildingId == buildingId).toList();
  }

  List<Room> getAllUniassignedRooms() {
    return _rooms.where((r) => r.buildingId == -1).toList();
  }

  int getUnassignedRoomCount() {
    return _rooms.where((r) => r.buildingId == -1).length;
  }

  int getRoomCount() {
    return _rooms.length;
  }

  Future<void> createRoom(Room room) async {
    int? newID = await isarService.createRoom(room);
    room.id = newID;
    _rooms.add(room);

    notifyListeners();
  }

  Future<void> editRoom(Room room) async {
    await isarService.editRoom(room);

    var updatedRoomIndex =
        _rooms.indexWhere((element) => element.id == room.id);

    _rooms[updatedRoomIndex] = room;
    notifyListeners();
  }

  // Coalesce implementation in isarService
  Future<void> deleteRoom(int id) async {
    await isarService.deleteRoom(id);
    _rooms.removeWhere((element) => element.id == id);

    notifyListeners();
  }
}
