import 'package:course_planner/providers/subject_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/IsarService.dart';
import '../models/Term.dart';

class TermProvider with ChangeNotifier {
  late IsarService isarService;

  List<Term> _terms = [];
  List<Term> get terms => _terms;

  Term? _currentTerm;
  Term? get currentTerm => _currentTerm;

  TermProvider() {
    isarService = IsarService();
    init();
  }

  void init() async {
    _terms = await isarService.getAllTerms();
    if (_terms.isNotEmpty) {
      _currentTerm =
          _terms.firstWhere((element) => element.isCurrentTerm == true);
    }
    notifyListeners();
  }

  Term getTermByID(int termID) {
    var term = _terms.firstWhere((element) => element.id == termID);
    return term;
  }

  Future<int?> addTerm(Term term, BuildContext context) async {
    if (_terms.isEmpty) {
      term.isCurrentTerm = true;
      _currentTerm = term;
    }

    var returnID = await isarService.createTerm(term);

    _terms.add(term);

    notifyListeners();

    return returnID;
  }

  Future<void> editTerm(Term term) async {
    await isarService.editTerm(term);
    var updatedTermIndex =
        _terms.indexWhere((element) => element.id == term.id);

    _terms[updatedTermIndex] = term;
    notifyListeners();
  }

  Future<void> deleteTerm(Term term) async {
    await isarService.deleteTerm(term.id!);
    _terms.removeWhere((e) => e.id == term.id);

    if (term.isCurrentTerm && _terms.isNotEmpty) {
      _terms.first.isCurrentTerm = true;
      _currentTerm = _terms.first;
      await isarService.editTerm(_currentTerm!);
    } else if (term.isCurrentTerm) {
      _currentTerm = null;
    }

    notifyListeners();
  }

  void setCurrentTerm(Term term) async {
    var oldTermIndex =
        _terms.indexWhere((element) => _currentTerm?.id == element.id);
    _terms[oldTermIndex].isCurrentTerm = false;

    term.isCurrentTerm = true;
    var newTermIndex = _terms.indexWhere((element) => term.id == element.id);

    await isarService.editTerm(term);
    await isarService.editTerm(_terms[oldTermIndex]);
    _terms[newTermIndex] = term;
    _currentTerm = term;

    notifyListeners();
  }

  Future<void> wipeDB() async {
    await isarService.wipeDB();
    _terms = [];
    notifyListeners();
  }

  Stream<List<Term>> listenToTerms() async* {
    yield* isarService.listenToTerms();
  }
}
