import 'package:course_planner/models/UserSettings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/Subject.dart';
import '../models/Term.dart';
import '../utils/enums.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationCacheDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([SubjectSchema, TermSchema, UserSettingsSchema],
          directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  // All GET
  Future<Term?> getTermByID(int id) async {
    final isar = await db;

    return await isar.terms.get(id);
  }

  Future<List<Term>> getAllTerms() async {
    final isar = await db;

    return await isar.terms.where().findAll();
  }

  Future<Subject?> getSubjetByID(int id) async {
    final isar = await db;

    return await isar.subjects.get(id);
  }

  Future<List<Subject>> getSubjectsByTerm(int termID) async {
    final isar = await db;

    return await isar.subjects.filter().termIDEqualTo(termID).findAll();
  }

  Future<List<Subject>> getSubjectByDay(Day day, int termID) async {
    final isar = await db;

    return await isar.subjects
        .filter()
        .termIDEqualTo(termID)
        .frequencyElementEqualTo(day)
        .findAll();
  }

  // All WRITE

  Future<int?> createTerm(Term term) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.terms.put(term);
    });

    var terms = await getAllTerms();
    if (terms.length == 1) {
      await setCurrentTerm(returnID!);
    }

    return returnID;
  }

  Future<void> createSubject(Subject subject) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.subjects.put(subject);
    });
  }

  // All EDIT
  Future<void> editSubject(Subject subject) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.subjects.put(subject);
    });
  }

  Future<void> editTerm(Term term) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.terms.put(term);
    });
  }

  // All DELETE

  Future<void> deleteSubjects(List<int> ids) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.subjects.deleteAll(ids);
    });
  }

  Future<void> deleteTerms(List<int> ids) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.terms.deleteAll(ids);
    });

    for (var id in ids) {
      await isar.subjects.filter().termIDEqualTo(id).deleteAll();
    }

    var currentTermID = await getCurrentTerm();
    if (ids.contains(currentTermID)) {
      await wipeUserSettings();
    }

    var terms = await getAllTerms();
    if (terms.isNotEmpty) {
      await setCurrentTerm(terms[0].id!);
    }
  }

  Future<void> wipeDB() async {
    final isar = await db;

    await isar.writeTxn(() => isar.clear());
  }

  // All STREAMS

  Stream<List<Subject>> listenToSubjectsByTerm(int termID) async* {
    final isar = await db;
    yield* isar.subjects.filter().termIDEqualTo(termID).watch();
  }

  Stream<List<Subject>> listenToSubjectsByDay(Day day, int termID) async* {
    final isar = await db;
    yield* isar.subjects
        .filter()
        .termIDEqualTo(termID)
        .frequencyElementEqualTo(day)
        .watch();
  }

  Stream<List<Term>> listenToTerms() async* {
    final isar = await db;
    yield* isar.terms.where().watch();
  }

  // for USER SETTINGS

  Future<List<UserSettings>> getCurrentUserSettings() async {
    final isar = await db;
    return isar.userSettings.where().findAll();
  }

  Future<int?> getCurrentTerm() async {
    List<UserSettings> queryResult = await getCurrentUserSettings();

    if (queryResult.isEmpty) {
      return -1;
    }

    UserSettings currentUserSettings = queryResult[0];
    return currentUserSettings.currentTerm;
  }

  Future<void> setCurrentTerm(int termID) async {
    final isar = await db;

    List<UserSettings> queryResult = await getCurrentUserSettings();
    UserSettings currentUserSettings;

    if (queryResult.isEmpty) {
      currentUserSettings = UserSettings()..currentTerm = termID;
    } else {
      currentUserSettings = queryResult[0];
      currentUserSettings.currentTerm = termID;
    }

    isar.writeTxn(() async {
      await isar.userSettings.put(currentUserSettings);
    });
  }

  Future<void> wipeUserSettings() async {
    final isar = await db;

    isar.writeTxn(() async {
      await isar.userSettings.clear();
    });
  }
}
