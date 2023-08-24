import 'dart:async';

import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/classes_module/view_class.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/next_class_card.dart';
import 'package:course_planner/widgets/cards/overview_today_card.dart';
import 'package:course_planner/widgets/elements/drawer.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:course_planner/widgets/timeline/Timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../models/Term.dart';
import '../../utils/constants.dart' as C;

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final _screenTitle = "Overview";
  final _route = "/overview";
  DateTime _rightNow = DateTime.now();
  Term? _term;
  late List<Subject> _subjects;
  late List<Subject> _subjectsToday;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _rightNow = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideDrawer(parent: _route),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildOverview(context),
        ),
      ),
    );
  }

  Widget _buildOverview(BuildContext context) {
    _term = context.watch<TermProvider>().currentTerm;

    if (_term == null) {
      return _noTermsYet(context);
    }

    _subjects = context.watch<SubjectProvider>().getSubjectsByTerm(_term!.id!);

    if (_subjects.isEmpty) {
      return _noSubjectsYet(context);
    }

    _subjectsToday = context
        .watch<SubjectProvider>()
        .getSubjectsByDay(DayMethods.fromInt(_rightNow.weekday), _term!.id!)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    if (_subjectsToday.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: _screenTitle),
          OverviewTodayCard(subjects: []),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        OverviewTodayCard(subjects: _subjectsToday),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: _content(context),
        )
      ],
    );
  }

  Widget _content(BuildContext context) {
    DateTime moment = DateTime(2024, 8, 20, _rightNow.hour, _rightNow.minute);
    Subject? currentSubject;
    int curSubIndex = 0;

    for (int i = 0; i < _subjectsToday.length; i++) {
      if ((moment.isAfter(_subjectsToday[i].startDate) ||
              _subjectsToday[i].startDate == moment) &&
          (moment.isBefore(_subjectsToday[i].endDate) ||
              _subjectsToday[i].endDate == moment)) {
        currentSubject = _subjectsToday[i];
        curSubIndex = i;
      }
    }

    bool onSchedule = (moment.isAfter(_subjectsToday[0].startDate) ||
            _subjectsToday[0].startDate == moment) &&
        (_subjectsToday[_subjectsToday.length - 1].endDate == moment ||
            moment.isBefore(_subjectsToday[_subjectsToday.length - 1].endDate));

    TimeOfDay timeLeft;

    if (onSchedule && currentSubject == null) {
      // On break
      Duration diff =
          _subjectsToday[curSubIndex + 1].startDate.difference(moment);
      timeLeft = TimeOfDay(hour: diff.inHours, minute: diff.inMinutes % 60);
    } else if (onSchedule) {
      // On class
      Duration diff = currentSubject!.endDate.difference(moment);
      timeLeft = TimeOfDay(hour: diff.inHours, minute: diff.inMinutes % 60);
    } else {
      timeLeft = TimeOfDay(hour: 0, minute: 0);
    }

    Widget nextClass;
    if (moment.isAfter(_subjectsToday[_subjectsToday.length - 1].endDate) ||
        _subjectsToday.isEmpty) {
      nextClass = const NextClassCard(
        isLastClass: false,
        emptyMode: true,
      );
    } else if (moment.isBefore(_subjectsToday[0].startDate)) {
      nextClass =
          NextClassCard(isLastClass: false, nextClass: _subjectsToday[0]);
    } else if (curSubIndex == _subjectsToday.length - 1) {
      nextClass = const NextClassCard(isLastClass: true);
    } else {
      nextClass = NextClassCard(
          isLastClass: false, nextClass: _subjectsToday[curSubIndex + 1]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _currentCourseClickable(context, currentSubject, onSchedule),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _timeLeft(
              context, timeLeft, onSchedule, curSubIndex, currentSubject),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: nextClass,
        ),
        if (_subjectsToday.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _timeline(),
          ),
        const SizedBox(height: 120)
      ],
    );
  }

  Widget _currentCourseClickable(
      BuildContext context, Subject? currentSubject, bool onSchedule) {
    return Material(
      borderRadius: BorderRadius.circular(C.cardBorderRadius),
      child: Ink(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(C.cardBorderRadius)),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: onSchedule && currentSubject != null
              ? () {
                  if (onSchedule) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewClass(subjectID: currentSubject.id!),
                        ));
                  }
                }
              : null,
          child: _currentCourseContainer(context, currentSubject, onSchedule),
        ),
      ),
    );
  }

  Widget _currentCourseContainer(
      BuildContext context, Subject? currentSubject, bool onSchedule) {
    String content = "--";

    if (currentSubject == null && onSchedule) {
      content = "On Break";
    } else if (onSchedule) {
      content =
          "${currentSubject!.courseCode} - ${currentSubject.isLaboratory ? "Laboratory" : "Lecture"}";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
              ),
              Text(
                "Current Class",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    fontSize: C.titleCardHeaderFontSize),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              content,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _timeLeft(BuildContext context, TimeOfDay timeLeft, bool onSchedule,
      int curSubIndex, Subject? curSub) {
    bool isLastClass = curSubIndex == _subjectsToday.length - 1;

    String subtitle = "";
    if (isLastClass && onSchedule) {
      subtitle = "Until free.";
    } else if (onSchedule) {
      if ((_subjectsToday[curSubIndex + 1].startDate !=
              _subjectsToday[curSubIndex].endDate &&
          curSub != null)) {
        subtitle = "Until break.";
      } else {
        subtitle =
            "Until ${_subjectsToday[curSubIndex + 1].courseCode} - ${_subjectsToday[curSubIndex + 1].isLaboratory ? "Laboratory" : "Lecture"} (${DateFormat.jm().format(_subjectsToday[curSubIndex + 1].startDate)}).";
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.watch_later_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Text(
                "Time Left",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: C.titleCardHeaderFontSize),
              )
            ],
          ),
          Text(
            _timeOfDayToString(timeLeft).trimLeft(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          if (onSchedule)
            SizedBox(
              width: double.infinity,
              child: Text(
                subtitle,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w300,
                    fontSize: 14),
              ),
            )
        ],
      ),
    );
  }

  String _timeOfDayToString(TimeOfDay time) {
    String timeStr = "";

    if (time.hour > 0) {
      timeStr = "${timeStr} ${time.hour} ${time.hour == 1 ? "hour" : "hours"}";
    }

    if (time.minute > 0) {
      timeStr =
          "${timeStr} ${time.minute} ${time.minute == 1 ? "minute" : "minutes"}";
    }

    if (timeStr == "") {
      return "--";
    }

    return timeStr;
  }

  Widget _noTermsYet(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        InfoCard(
            content:
                "Welcome! \nBegin by adding a term in the 'Terms' section. Next, populate the 'Classes' screen with your classes. Your daily summary will be displayed here.")
      ],
    );
  }

  Widget _noSubjectsYet(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        InfoCard(
            content:
                "You don't have any classes in the current term. Add one on the 'Classes' screen.")
      ],
    );
  }

  Widget _timeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _timelineHeader(),
        const SizedBox(height: 10),
        Timeline(subjects: _subjectsToday),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onLongPress: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Padayon! 🌻")));
          },
          child: const Text(
            '🌻',
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }

  Widget _timelineHeader() {
    return const Row(
      children: [
        Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "TODAY'S SCHEDULE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
      ],
    );
  }
}
