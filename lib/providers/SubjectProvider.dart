import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';
import '../models/Subject.dart';
import 'package:provider/provider.dart';

class SubjectProvider with ChangeNotifier {
  late IsarService isarService;

  SubjectProvider() {
    isarService = IsarService();
  }
}
