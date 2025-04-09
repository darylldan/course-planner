import 'package:course_planner/models/Building.dart';
import 'package:flutter/foundation.dart';
import '../api/IsarService.dart';

class BuildingProvider extends ChangeNotifier {
  late IsarService isarService;

  List<Building> _buildings = [];
  List<Building> get building => _buildings;

  BuildingProvider() {
    isarService = IsarService();
    init();
  }

  void load() {
    return;
  }

  void init() async {
    _buildings = await isarService.getAllBuildings();
    notifyListeners();
  }

  Building getBuildingByID(int id) {
    return _buildings.firstWhere((e) => e.id == id);
  }

  Future<void> createBuilding(Building building) async {
    int? newID = await isarService.createBuilding(building);
    building.id = newID;
    _buildings.add(building);

    notifyListeners();
  }

  Future<void> editBuilding(Building building) async {
    await isarService.editBuilding(building);

    var updatedIndex = _buildings.indexWhere((e) => e.id == building.id);
    _buildings[updatedIndex] = building;
    notifyListeners();
  }

  Future<void> deleteBuilding(int id) async {
    await isarService.deleteBuilding(id);
    _buildings.removeWhere((e) => e.id == id);

    notifyListeners();
  }
}
