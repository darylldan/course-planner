import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';
import '../models/Term.dart';

class TermProvider with ChangeNotifier {
  late IsarService isarService;

  TermProvider() {
    isarService = IsarService();
  }

  Future<Term?> getTermByID(int termID) async {
    var term = await isarService.getTermByID(termID);
    notifyListeners();

    return term;
  }

  Future<List<Term>> getAllTerms() async {
    List<Term> terms = await isarService.getAllTerms();
    notifyListeners();

    return terms;
  }

  Future<void> editTerm(Term term) async {
    await isarService.editTerm(term);
    notifyListeners();
  }

  Future<void> deleteTerms(List<int> ids) async {
    await isarService.deleteTerms(ids);
    notifyListeners();
  }

  Future<void> wipeDB() async {
    await isarService.wipeDB();
    notifyListeners();
  }

  Stream<List<Term>> listenToTerms() async* {
    yield* isarService.listenToTerms();
  }
}
