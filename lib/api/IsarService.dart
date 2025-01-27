import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Note.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/models/Todo.dart';
import 'package:course_planner/models/User.dart';
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
      return await Isar.open([SubjectSchema, TermSchema], directory: dir.path);
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

  Future<List<Note>> getAllNotes() async {
    final isar = await db;

    return isar.notes.where().findAll();
  }

  Future<List<Building>> getAllBuildings() async {
    final isar = await db;

    return isar.buildings.where().findAll();
  }

  Future<List<DeadlineEvent>> getAllDeadlineEvents() async {
    final isar = await db;

    return isar.deadlineEvents.where().findAll();
  }

  Future<List<Room>> getAllRooms() async {
    final isar = await db;

    return isar.rooms.where().findAll();
  }

  Future<List<Todo>> getAllTodos() async {
    final isar = await db;

    return isar.todos.where().findAll();
  }

  Future<List<User>> getAllUsers() async {
    final isar = await db;

    return isar.users.where().findAll();
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

  Future<void> createBuilding(Building building) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.buildings.put(building);
    });
  }

  Future<void> createDeadlineEvent(DeadlineEvent deadlineEvent) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.deadlineEvents.put(deadlineEvent);
    });
  }

  Future<void> createNote(Note note) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  Future<void> createRoom(Room room) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.rooms.put(room);
    });
  }

  Future<void> createTodo(Todo todo) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.todos.put(todo);
    });
  }

  Future<void> createUser(User user) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.users.put(user);
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

  Future<void> editBuilding(Building building) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.buildings.put(building);
    });
  }

    Future<void> editDeadlineEvent(DeadlineEvent deadlineEvent) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.deadlineEvents.put(deadlineEvent);
    });
  }

  Future<void> editNote(Note note) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  Future<void> editRoom(Room room) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.rooms.put(room);
    });
  }

  Future<void> editTodo(Todo todo) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.todos.put(todo);
    });
  }

  Future<void> editUser(User user) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.users.put(user);
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

    // Also deletes the subjects in that term
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
}
