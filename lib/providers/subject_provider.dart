import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';
import '../models/Subject.dart';

import '../utils/enums.dart';

/*
 * Basically it fetches the subjects from db, then the modifications that occured 
 * on db is done first in the database, then the local array, to prevent fetching
 * them around. GET methods are mostly from the local array.
 * 
 * Justification:
 *  - The data is never being modified by entities other than the user, so there
 *    are for other entities to modify the database.
 */

class SubjectProvider with ChangeNotifier {
  late IsarService isarService;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  SubjectProvider() {
    isarService = IsarService();
    init();
  }

  void init() async {
    _subjects = await isarService.getAllSubjects();
    notifyListeners();
  }

  Subject getSubjectByID(int id) {
    var subject = _subjects.firstWhere((element) => element.id == id);

    return subject;
  }

  List<Subject> getSubjectsByDay(Day day, int termID) {
    List<Subject> subjects = _subjects.where((element) {
      return element.frequency.contains(day) && element.termID == termID;
    }).toList();

    return subjects;
  }

  List<Subject> getSubjectsByTerm(int termID) {
    List<Subject> subjects =
        _subjects.where((element) => element.termID == termID).toList();

    return subjects;
  }

  Future<void> createSubject(Subject subject) async {
    await isarService.createSubject(subject);
    _subjects.add(subject);

    notifyListeners();
  }

  Future<void> editSubject(Subject subject) async {
    await isarService.editSubject(subject);
    var updatedSubjectIndex =
        _subjects.indexWhere((element) => element.id == subject.id);
    _subjects[updatedSubjectIndex] = subject;

    notifyListeners();
  }

  Future<void> deleteSubjects(List<int> ids) async {
    await isarService.deleteSubjects(ids);
    _subjects.removeWhere((subject) => ids.contains(subject.id));

    notifyListeners();
  }

  // A handy method that checks if the subject param is conflicting with other subjects
  // in temrs of schedule.
  Map<String, dynamic> checkForOverlap(Subject subject) {
    Map<String, dynamic> returnVal = {
      'isOverlapping': false,
      'overlapSubjectIDs': []
    };

    for (var d in subject.frequency) {
      _subjects
          .where((sub) =>
              sub.frequency.contains(d) && sub.termID == subject.termID)
          .any((s) {
        if (subject.startDate == s.endDate || s.endDate == subject.startDate) {
          return false;
        }

        if (!(subject.endDate.isBefore(s.startDate) ||
            s.endDate.isBefore(subject.startDate))) {
          returnVal['overlapSubjectIDs'].add(s.id);
          return true;
        }

        return false;
      });
    }

    /*
     * Can result to same id being placed in the array, (because a subject can
     * have multiple days in frequency)
     */
    returnVal['overlapSubjectIDs'] =
        returnVal['overlapSubjectIDs'].toSet().toList();
    returnVal['overlapSubjectIDs'].remove(subject.id);

    if (returnVal['overlapSubjectIDs'].isNotEmpty) {
      returnVal['isOverlapping'] = true;
    }

    return returnVal;
  }

  Future<void> wipeDB() async {
    await isarService.wipeDB();
    _subjects = [];
    notifyListeners();
  }

  Stream<List<Subject>> listenToSubjectsByTerm(int termID) async* {
    yield* isarService.listenToSubjectsByTerm(termID);
  }
}
