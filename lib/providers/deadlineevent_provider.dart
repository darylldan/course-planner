import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:flutter/foundation.dart';

import '../api/IsarService.dart';

class DeadlineEventProvider extends ChangeNotifier {
  late IsarService isarService;

  List<DeadlineEvent> _deadlineEvents = [];
  List<DeadlineEvent> get deadlineEvent => _deadlineEvents;

  DeadlineEventProvider() {
    isarService = IsarService();
    init();
  }

  void init() async {
    _deadlineEvents = await isarService.getAllDeadlineEvents();
    notifyListeners();
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isWithinRange(DateTime date, DateTime start, DateTime end) {
    final bool isOnOrAfterStart =
        _isSameDate(date, start) || date.isAfter(start);
    final bool isOnOrBeforeEnd = _isSameDate(date, end) || date.isBefore(end);
    return isOnOrAfterStart && isOnOrBeforeEnd;
  }

  DeadlineEvent getDeadlineEventByID(int id) {
    return _deadlineEvents.firstWhere((e) => e.id == id);
  }

  List<DeadlineEvent> getDeadlineAllEventByCourse(int courseId) {
    return _deadlineEvents.where((e) => e.courseId == courseId).toList();
  }

  Future<List<DeadlineEvent>> getDeadlineEventByTerm(int termId) async {
    List<Subject> subjects = await isarService.getAllSubjects();

    return _deadlineEvents
        .where((d) =>
            subjects.firstWhere((e) => d.courseId == e.id).termID == termId)
        .toList();
  }

  Future<List<DeadlineEvent>> getAllOngoingDeadlineEvents(int termId) async {
    List<Subject> subjects = await isarService.getAllSubjects();

    return _deadlineEvents
        .where((d) =>
            subjects.firstWhere((e) => d.courseId == e.id).termID == termId)
        .where((d) => d.date.isBefore(DateTime.now()))
        .toList();
  }

  List<DeadlineEvent> getAllOngoingDeadlineEventsForSubject(int courseId) {
    return _deadlineEvents
        .where((d) => d.courseId == courseId)
        .where((d) => d.date.isBefore(DateTime.now()))
        .toList();
  }

  Future<List<DeadlineEvent>> getAllOngoingDeadlineEventsToday(
      int termId) async {
    List<Subject> subjects = await isarService.getAllSubjects();
    DateTime today = DateTime.now();

    return _deadlineEvents
        .where((d) =>
            subjects.firstWhere((e) => d.courseId == e.id).termID == termId)
        .where((d) => _isSameDate(d.date, today))
        .toList();
  }

  Future<List<DeadlineEvent>> getAllDeadlineEventsThisWeek(int termId) async {
    List<Subject> subjects = await isarService.getAllSubjects();
    DateTime today = DateTime.now();

    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = today.add(Duration(days: 6));

    return _deadlineEvents
        .where((d) =>
            subjects.firstWhere((e) => d.courseId == e.id).termID == termId)
        .where((d) =>
            d.date.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
            d.date.isBefore(endOfWeek.add(Duration(days: 1))))
        .toList();
  }

  Future<List<DeadlineEvent>> getAllDeadlineEventsInMonth(
      int termId, int month) async {
    List<Subject> subjects = await isarService.getAllSubjects();

    return _deadlineEvents
        .where((d) =>
            subjects.firstWhere((e) => e.id == d.courseId).termID == termId)
        .where((d) => d.date.month == month)
        .toList();
  }

  // Inclusive
  Future<List<DeadlineEvent>> getAllDeadlineEventsRange(
      int termId, DateTime startDate, DateTime endDate) async {
    List<Subject> subjects = await isarService.getAllSubjects();

    return _deadlineEvents
        .where((d) =>
            subjects.firstWhere((e) => e.id == d.courseId).termID == termId)
        .where((d) => _isWithinRange(d.date, startDate, endDate))
        .toList();
  }

  Future<List<DeadlineEvent>> getAllLapsedDeadlineEvent(int termId) async {
    List<Subject> subjects = await isarService.getAllSubjects();

    return _deadlineEvents
        .where((d) =>
            subjects.firstWhere((e) => e.id == d.courseId).termID == termId)
        .where((d) => d.date.isBefore(DateTime.now()))
        .toList();
  }

  List<DeadlineEvent> getAllLapsedDeadlineEventBySubject(int courseId) {
    return _deadlineEvents
        .where((d) => d.courseId == courseId)
        .where((d) => d.date.isBefore(DateTime.now()))
        .toList();
  }

  Future<void> createDeadlineEvent(DeadlineEvent deadlineEvent) async {
    int? newId = await isarService.createDeadlineEvent(deadlineEvent);
    deadlineEvent.id = newId;
    _deadlineEvents.add(deadlineEvent);
    notifyListeners();
  }

  Future<void> editDeadlineEvent(DeadlineEvent deadlineEvent) async {
    await isarService.editDeadlineEvent(deadlineEvent);
    _deadlineEvents[_deadlineEvents
        .indexWhere((d) => d.id == deadlineEvent.id)] = deadlineEvent;

    notifyListeners();
  }

  Future<void> deleteDeadlineEvent(int id) async {
    await isarService.deleteDeadlineEvent(id);
    _deadlineEvents.removeWhere((d) => d.id == id);

    notifyListeners();
  }
}
