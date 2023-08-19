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
      return await Isar.open([SubjectSchema, TermSchema],
          directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }


  // All GET
  Future<List<Term>> getAllTerms() async {
    final isar = await db;

    return await isar.terms.where().findAll();
  }

  Future<List<Subject>> getAllSubjects() async {
    final isar = await db;

    return await isar.subjects.where().findAll();
  }

  // All WRITE

  Future<int?> createTerm(Term term) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.terms.put(term);
    });
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
      await isar.writeTxn(() async {
        await isar.subjects.filter().termIDEqualTo(id).deleteAll();
      });
    }
  }

  Future<void> deleteTerm(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.terms.delete(id);
      await isar.subjects.filter().termIDEqualTo(id).deleteAll();
    });
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
    yield* isar.terms.where().watch(fireImmediately: true);
  }

}
