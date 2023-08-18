import 'dart:js_util';

import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';
import '../models/UserSettings.dart';

class UserSettingsProvider with ChangeNotifier {
  late IsarService isarService;

  UserSettingsProvider() {
    isarService = IsarService();
  }

  Future<int?> getCurrentTermID() async {
    var currentTermID = await isarService.getCurrentTerm();
    notifyListeners();

    return currentTermID;
  }

  Future<int?> setCurrentTerm(int termID) async {
    await isarService.setCurrentTerm(termID);
    notifyListeners();
  }
}
