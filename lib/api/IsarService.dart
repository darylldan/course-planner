import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/Subject.dart';
import '../models/Term.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }
  Future<Isar> openDB() async {
    final dir = await getApplicationCacheDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([SubjectSchema, TermSchema], directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }
}
