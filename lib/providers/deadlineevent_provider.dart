import 'package:iskotrack/models/DeadlineEvent.dart';
import 'package:iskotrack/utils/enums.dart';
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

  void load() {
    return;
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

  List<DeadlineEvent> getAllDeadlineEventByCourse(int courseId) {
    return _deadlineEvents.where((e) => e.courseId == courseId).toList();
  }

  List<DeadlineEvent> getDeadlineEventByTerm(int termId) {
    return _deadlineEvents.where((d) => d.termId == termId).toList();
  }

  List<DeadlineEvent> getUnassignedDeadlineEventByTerm(int termId) {
    return _deadlineEvents
        .where((d) => d.termId == termId && d.courseId == -1)
        .toList();
  }

  List<DeadlineEvent> getAllUpcomingDeadlineEvents(int termId) {
    return _deadlineEvents
        .where((d) => d.termId == termId)
        .where((d) => d.date.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // Ascending (nearest first)
  }

  List<DeadlineEvent> getAllPastDeadlineEvents(int termId) {
    return _deadlineEvents
        .where((d) => d.termId == termId)
        .where((d) => d.date.isBefore(DateTime.now()))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Descending (latest last)
  }

  List<DeadlineEvent> getAllUpcomingDeadlineEventsForSubject(int courseId) {
    final events = _deadlineEvents
        .where((d) => d.courseId == courseId)
        .where((d) => d.date.isAfter(DateTime.now()))
        .toList();
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  List<DeadlineEvent> getAllDoneDeadlineEventsForSubject(int courseId) {
    final events = _deadlineEvents
        .where((d) => d.courseId == courseId)
        .where((d) => d.date.isBefore(DateTime.now()))
        .toList();
    events.sort((a, b) => b.date.compareTo(a.date)); // Reverse sort
    return events;
  }

  List<DeadlineEvent> getAllUpcomingUnassignedEvent(int termId) {
    final events = _deadlineEvents
        .where((d) => d.termId == termId && d.courseId == -1)
        .where((d) => d.date.isAfter(DateTime.now()))
        .toList();
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  List<DeadlineEvent> getAllDoneUnassignedEvent(int termId) {
    final events = _deadlineEvents
        .where((d) => d.termId == termId && d.courseId == -1)
        .where((d) => d.date.isBefore(DateTime.now()))
        .toList();
    events.sort((a, b) => b.date.compareTo(a.date)); // Reverse sort
    return events;
  }

  List<DeadlineEvent> getAllOngoingDeadlineEventsToday(int termId) {
    DateTime today = DateTime.now();

    return _deadlineEvents
        .where((d) => d.termId == termId)
        .where((d) => _isSameDate(d.date, today))
        .toList();
  }

  List<DeadlineEvent> getAllCourseEventToday(int termId, int courseId) {
    DateTime today = DateTime.now();

    return _deadlineEvents
        .where((d) => d.termId == termId && d.courseId == courseId)
        .where((d) => _isSameDate(d.date, today))
        .toList();
  }

  List<DeadlineEvent> getAllDeadlineEventsThisWeek(int termId) {
    final now = DateTime.now();

    // Get start of week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekAtMidnight =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    // Get end of week (Sunday)
    final endOfWeek = startOfWeekAtMidnight.add(Duration(days: 6));
    final endOfWeekAtMidnight =
        DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);

    return _deadlineEvents
        .where((d) => d.termId == termId)
        .where(
            (d) => d.date.isAfter(now) && d.date.isBefore(endOfWeekAtMidnight))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<DeadlineEvent> getEventsForDay(Day day, int termId) {
    // Get current date and calculate the start and end of the week
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);

    // Calculate start of week (Monday)
    final startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));

    // Calculate the target day by adding the day offset
    final dayOffset = day.index; // mon=0, tue=1, ..., sat=5
    final targetDay = startOfWeek.add(Duration(days: dayOffset));

    // Calculate the next day (for end of range)
    final nextDay = targetDay.add(const Duration(days: 1));

    // Filter events that fall on the target day
    return _deadlineEvents.where((event) {
      return event.termId == termId &&
          event.date.isAfter(targetDay) &&
          event.date.isBefore(nextDay);
    }).toList();
  }

  List<DeadlineEvent> getAllDeadlineEventsOfSubjThisWeek(
      int termId, int courseId) {
    final now = DateTime.now();

    // Get start of week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekAtMidnight =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    // Get end of week (Sunday)
    final endOfWeek = startOfWeekAtMidnight.add(Duration(days: 6));
    final endOfWeekAtMidnight =
        DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);

    return _deadlineEvents
        .where((d) => d.termId == termId && d.courseId == courseId)
        .where(
            (d) => d.date.isAfter(now) && d.date.isBefore(endOfWeekAtMidnight))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<DeadlineEvent> getAllDeadlineEventsInMonth(int termId, int month) {
    return _deadlineEvents
        .where((d) => d.termId == termId)
        .where((d) => d.date.month == month)
        .toList();
  }

  // Inclusive
  List<DeadlineEvent> getAllDeadlineEventsRange(
      int termId, DateTime startDate, DateTime endDate) {
    return _deadlineEvents
        .where((d) =>
            d.termId == termId && _isWithinRange(d.date, startDate, endDate))
        .toList();
  }

  List<DeadlineEvent> getAllLapsedDeadlineEvent(int termId) {
    return _deadlineEvents
        .where((d) => d.termId == termId && d.date.isBefore(DateTime.now()))
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

  Future<void> updateEventBounds(
      int termId, DateTime startDate, DateTime endDate) async {
    List<DeadlineEvent> affectedEvents =
        _deadlineEvents.where((e) => e.termId == termId).toList();

    for (DeadlineEvent e in affectedEvents) {
      if (e.date.isBefore(startDate)) {
        e.date = DateTime(startDate.year, startDate.month, startDate.day,
            e.date.hour, e.date.minute);
      }

      if (e.date.isAfter(endDate)) {
        e.date = DateTime(endDate.year, endDate.month, endDate.day,
            e.date.hour, e.date.minute);
      }

      await editDeadlineEvent(e);
    }

    notifyListeners();
  }

  Future<void> deleteDeadlineEvent(int id) async {
    await isarService.deleteDeadlineEvent(id);
    _deadlineEvents.removeWhere((d) => d.id == id);

    notifyListeners();
  }
}
