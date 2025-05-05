import 'package:flutter/material.dart';
import 'package:iskotrack/models/Building.dart';
import 'package:iskotrack/models/CourseGrade.dart';
import 'package:iskotrack/models/CourseTemplate.dart';
import 'package:iskotrack/models/DeadlineEvent.dart';
import 'package:iskotrack/models/Note.dart';
import 'package:iskotrack/models/Room.dart';
import 'package:iskotrack/models/TermGrade.dart';
import 'package:iskotrack/models/Todo.dart';
import 'package:iskotrack/models/UploadedCourse.dart';
import 'package:iskotrack/models/User.dart';
import 'package:isar/isar.dart';
import 'package:iskotrack/providers/room_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
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
      return await Isar.open([
        SubjectSchema,
        TermSchema,
        BuildingSchema,
        DeadlineEventSchema,
        NoteSchema,
        RoomSchema,
        TodoSchema,
        UserSchema,
        CourseGradeSchema,
        TermGradeSchema,
        CourseTemplateSchema,
        UploadedCourseSchema
      ], directory: dir.path);
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

  Future<List<TermGrade>> getAllTermGrades() async {
    final isar = await db;

    return isar.termGrades.where().findAll();
  }

  Future<List<CourseGrade>> getAllCourseGrades() async {
    final isar = await db;

    return isar.courseGrades.where().findAll();
  }

  Future<List<CourseTemplate>> getAllCourseTemplate() async {
    final isar = await db;

    return isar.courseTemplates.where().findAll();
  }

  Future<int> getCourseTemplateCount() async {
    final isar = await db;

    return isar.courseTemplates.count();
  }

  Future<List<UploadedCourse>> getAllUploadedCourses() async {
    final isar = await db;

    return isar.uploadedCourses.where().findAll();
  }

  // All WRITE

  Future<int?> createUploadedCourse(UploadedCourse u) async {
    final isar = await db;

    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.uploadedCourses.put(u);
    });

    return returnID;
  }

  Future<int?> createTerm(Term term) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.terms.put(term);
    });
    return returnID;
  }

  Future<int?> createSubject(Subject subject) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.subjects.put(subject);
    });

    return returnID;
  }

  Future<int?> createBuilding(Building building) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.buildings.put(building);
    });

    return returnID;
  }

  Future<int?> createDeadlineEvent(DeadlineEvent deadlineEvent) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.deadlineEvents.put(deadlineEvent);
    });

    return returnID;
  }

  Future<int?> createNote(Note note) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.notes.put(note);
    });

    return returnID;
  }

  Future<int?> createRoom(Room room) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.rooms.put(room);
    });

    return returnID;
  }

  Future<int?> createTodo(Todo todo) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.todos.put(todo);
    });

    return returnID;
  }

  Future<int?> createUser(User user) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.users.put(user);
    });

    return returnID;
  }

  Future<int?> createTermGrade(TermGrade termGrade) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.termGrades.put(termGrade);
    });

    return returnID;
  }

  Future<int?> createCourseGrade(CourseGrade courseGrade) async {
    final isar = await db;
    int? returnID;

    await isar.writeTxn(() async {
      returnID = await isar.courseGrades.put(courseGrade);
    });

    return returnID;
  }

  Future<void> addAllCourseTemplates(List<CourseTemplate> cts) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.courseTemplates.putAll(cts);
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

  Future<void> editTermGrade(TermGrade termGrade) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.termGrades.put(termGrade);
    });
  }

  Future<void> editCourseGrade(CourseGrade courseGrade) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.courseGrades.put(courseGrade);
    });
  }

  // All DELETE

  Future<void> deleteSubject(int id) async {
    final isar = await db;
    Subject? course = await isar.subjects.filter().idEqualTo(id).findFirst();
    String courseCode = course!.courseCode;
    List<Subject> linkedCourses = await isar.subjects
        .filter()
        .courseCodeEqualTo(courseCode, caseSensitive: false)
        .unitsEqualTo(course.units)
        .findAll();

    await isar.writeTxn(() async {
      await isar.subjects.delete(id);
      await isar.deadlineEvents.filter().courseIdEqualTo(id).deleteAll();
      await isar.notes.filter().courseIdEqualTo(id).deleteAll();
      await isar.todos.filter().courseIdEqualTo(id).deleteAll();

      // Deleting a course grade if no matching course code+units is detected
      if (linkedCourses.isEmpty) {
        await isar.courseGrades
            .filter()
            .courseCodeEqualTo(courseCode, caseSensitive: false)
            .deleteAll();
      }
    });
  }

  Future<void> deleteTerm(int id) async {
    final isar = await db;

    List<Subject> affectedSubjects =
        await isar.subjects.filter().termIDEqualTo(id).findAll();

    for (Subject s in affectedSubjects) {
      await deleteSubject(s.id!);
    }

    await isar.writeTxn(() async {
      await isar.terms.delete(id);

      await isar.deadlineEvents.filter().termIdEqualTo(id).deleteAll();
      await isar.todos.filter().termIdEqualTo(id).deleteAll();

      // Deleting unassinged notes
      await isar.notes.filter().termIdEqualTo(id).deleteAll();
    });
  }

  Future<void> deleteRoom(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.rooms.delete(id);

      List<Subject> affectedSubjects = await isar.subjects
          .filter()
          .locationTypeEqualTo("room")
          .locationIDEqualTo(id)
          .findAll();

      for (Subject s in affectedSubjects) {
        s.locationID = null;
        s.locationType = null;
      }

      for (Subject s in affectedSubjects) {
        await editSubject(s);
      }
    });
  }

  Future<void> deleteBuilding(int id, BuildContext context) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.buildings.delete(id);
      await isar.rooms.filter().buildingIdEqualTo(id).deleteAll();
    });

    List<Subject> affectedCourses = await isar.subjects
        .filter()
        .locationTypeEqualTo("bldg")
        .locationIDEqualTo(id)
        .findAll();

    for (Subject c in affectedCourses) {
      c.locationType = null;
      c.locationID = null;

      await editSubject(c);
    }

    if (context.mounted) context.read<RoomProvider>().init();
  }

  Future<void> deleteDeadlineEvent(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.deadlineEvents.delete(id);
    });
  }

  Future<void> deleteNote(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.notes.delete(id);
    });
  }

  Future<void> deleteTodo(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.todos.delete(id);
    });
  }

  Future<void> deleteUser(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.todos.delete(id);
    });
  }

  Future<void> deleteTermGrade(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.termGrades.delete(id);
    });
  }

  Future<void> deleteCourseGrade(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.courseGrades.delete(id);
    });
  }

  Future<void> wipeDB() async {
    final isar = await db;

    await isar.writeTxn(() => isar.clear());
  }
}
