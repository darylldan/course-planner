import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/widgets/cards/current_day_selected.dart';
import 'package:course_planner/widgets/elements/drawer.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:course_planner/widgets/timeline/Timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../models/Term.dart';
import '../../utils/constants.dart' as C;
import '../../widgets/cards/info_card.dart';

class DailySchedule extends StatefulWidget {
  const DailySchedule({super.key});

  @override
  State<DailySchedule> createState() => _DailyScheduleState();
}

class _DailyScheduleState extends State<DailySchedule> {
  final String _screenTitle = "Daily Schedule";
  final String _route = "/daily-schedule";

  final Day _today = DayMethods.fromInt(DateTime.now().weekday);
  Day? _daySelectorValue;
  Day? _currentDay;
  late Term? _currentTerm;
  late Term? _termSelectorValue;
  bool onCurrentTerm = true;
  bool onCurrentDay = true;

  late List<Subject> _subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideDrawer(
        parent: _route,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildTimeline(context),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    _currentDay ??= _today;

    if (onCurrentTerm) {
      _currentTerm = context.watch<TermProvider>().currentTerm;
    }

    if (_currentTerm == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            title: _screenTitle,
          ),
          InfoCard(
            content:
                "Begin by adding a term on the terms page. Once a term is added, you can proceed to create a subject under that term on this subjects page. The timeline of the subjects you created will appear here.",
          )
        ],
      );
    }

    _subjects = context
        .watch<SubjectProvider>()
        .getSubjectsByDay(_currentDay!, _currentTerm!.id!)..sort(
          (a, b) => a.startDate.compareTo(b.startDate)
        );

    if (_subjects.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            title: _screenTitle,
          ),
          _buildCurrentDay(context),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
          ),
          InfoCard(
            content:
                "You have no schedule for ${_currentDay == _today ? "today." : "this day."}",
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          title: _screenTitle,
        ),
        _buildCurrentDay(context),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Center(child: Timeline(subjects: _subjects)),
        const SizedBox(height: 120,)
      ],
    );
  }

  Widget _buildCurrentDay(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: InkWell(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            onTap: () {
              _showDayTermChanger(context);
            },
            child: CurrentDaySelectedCard(
              day: _currentDay!,
              term: _currentTerm!,
              isCurrent: _currentDay == _today,
            )),
      ),
    );
  }

  void _showDayTermChanger(BuildContext context) {
    _termSelectorValue = _currentTerm;
    List<Term> terms = context.read<TermProvider>().terms;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: C.screenHorizontalPadding, vertical: 24),
          child: SizedBox(
            height: 400,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Select Day and Term",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _dayTermSelector(context, terms),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dayTermSelector(BuildContext context, List<Term> terms) {
    List<DropdownMenuEntry<int>> entries = [];
    List<DropdownMenuEntry<Day>> dayEntries = [];

    for (var t in terms) {
      String label = "${t.semester}, ${t.academicYear}";

      if (label.length > 36) {
        label = "${label.substring(0, 37)}...";
      }

      entries.add(DropdownMenuEntry(
          value: t.id!,
          label: label,
          trailingIcon: t.isCurrentTerm ? Icon(Icons.star_rounded) : null));
    }

    for (var d in Day.values) {
      dayEntries.add(DropdownMenuEntry(
          value: d,
          label: DayMethods.dayToString(d),
          trailingIcon: d == _today ? Icon(Icons.star_rounded) : null));
    }

    return Column(
      children: [
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownMenu<Day>(
            width: 390,
            initialSelection: _currentDay,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
            label: const Text("Day"),
            dropdownMenuEntries: dayEntries,
            onSelected: (Day? d) {
              if (d != _today) {
                onCurrentDay = false;
              }

              _daySelectorValue = d;
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ButtonTheme(
          alignedDropdown: true,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: DropdownMenu<int>(
            width: 390,
            initialSelection: _currentTerm!.id,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
            label: const Text("Terms"),
            dropdownMenuEntries: entries,
            onSelected: (int? termID) {
              _termSelectorValue =
                  context.read<TermProvider>().getTermByID(termID!);
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer),
                foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentTerm = _termSelectorValue;
                onCurrentTerm = _termSelectorValue!.isCurrentTerm;

                _currentDay = _daySelectorValue;
                if (_daySelectorValue == _today) {
                  onCurrentDay = true;
                } else {
                  onCurrentDay = false;
                }
              });
            },
            child: const Text(
              "View Daily Schedule",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
