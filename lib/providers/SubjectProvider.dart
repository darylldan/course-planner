import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';
import '../models/Subject.dart';
import 'package:provider/provider.dart';

class SubjectProvider with ChangeNotifier {
  late IsarService isarService;

  SubjectProvider() {
    isarService = IsarService();
  }

  Future<Subject?> getSubjectByID(int id) async {
    var subject = await isarService.getSubjetByID(id);
    notifyListeners();

    return subject;
  }

  Future<List<Subject>> getSubjectsByTerm(int termID) async {
    List<Subject> subjects = await isarService.getSubjectsByTerm(termID);
    notifyListeners();

    return subjects;
  }

  Future<void> createSubject(Subject subject) async {
    await isarService.createSubject(subject);
    notifyListeners();
  }

  Future<void> editSubject(Subject subject) async {
    await isarService.editSubject(subject);
    notifyListeners();
  }

  Future<void> deleteSubjects(List<int> ids) async {
    await isarService.deleteSubjects(ids);
    notifyListeners();
  }

  Stream<List<Subject>> listenToSubjectsByTerm(int termID) async* {
    yield* isarService.listenToSubjectsByTerm(termID);
  }
}
