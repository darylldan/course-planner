import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';
import '../models/Subject.dart';
import 'package:provider/provider.dart';

import '../utils/enums.dart';

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
    notifyListeners();

    return subject;
  }

  List<Subject> getSubjectsByDay(Day day, int termID) {
    List<Subject> subjects = _subjects.where((element) {
      return element.frequency.contains(day) && element.termID == termID;
    }).toList();

    notifyListeners();

    return subjects;
  }

  List<Subject> getSubjectsByTerm(int termID) {
    List<Subject> subjects =
        _subjects.where((element) => element.termID == termID).toList();
    notifyListeners();

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

  Map<String, dynamic> checkForOverlap(Subject subject) {
    Map<String, dynamic> returnVal = {
      'isOverlapping': false,
      'overlapSubjectIDs': []
    };

    for (var d in subject.frequency) {
      _subjects.where((sub) => sub.frequency.contains(d)).any((s) {
        if (!(subject.endDate.isBefore(s.startDate) ||
            s.endDate.isBefore(subject.startDate))) {
          returnVal['overlapSubjectIDs'].add(s.id);
          return true;
        }

        return false;
      });
    }

    returnVal['overlapSubjectIDs'] = returnVal['overlapSubjectIDs'].toSet().toList();
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
