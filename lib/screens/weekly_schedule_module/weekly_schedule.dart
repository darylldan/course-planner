import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/widgets/elements/drawer.dart';
import 'package:course_planner/widgets/timetable/Timetable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../models/Term.dart';
import '../../providers/subject_provider.dart';
import '../../utils/constants.dart' as C;
import '../../widgets/cards/current_term_selected.dart';
import '../../widgets/cards/info_card.dart';
import '../../widgets/elements/title_text.dart';

class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({super.key});

  @override
  State<WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  final _screenTitle = "Weekly Schedule";
  final _route = "/weekly-schedule";
  late Term? currentTerm;
  late Term? _termSelectorValue;
  bool onCurrentTerm = true;
  bool includeSun = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideDrawer(parent: _route),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildWeeklySchedule(context),
        ),
      ),
    );
  }

  Widget _buildWeeklySchedule(BuildContext context) {
    if (onCurrentTerm) {
      currentTerm = context.watch<TermProvider>().currentTerm;
    }

    if (currentTerm == null) {
      return _noTermsYet();
    }

    List<Subject> subjects = context
        .watch<SubjectProvider>()
        .subjects
        .where((e) => e.termID == currentTerm!.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        _buildCurrentTerm(context),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Timetable(subjects: subjects),
        const SizedBox(
          height: 120,
        )
      ],
    );
  }

  Widget _buildCurrentTerm(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () {
            _showTermChanger(context);
          },
          child: CurrentTermSelectedCard(
            term: currentTerm!,
            editMode: false,
            onCurrentTerm: currentTerm!.isCurrentTerm,
          ),
        ),
      ),
    );
  }

  void _showTermChanger(BuildContext context) {
    _termSelectorValue = currentTerm;
    List<Term> terms = context.read<TermProvider>().terms;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Select Term",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _termSelector(context, terms),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _termSelector(BuildContext context, List<Term> terms) {
    List<DropdownMenuEntry<int>> entries = [];

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

    return Column(
      children: [
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownMenu<int>(
            width: 343,
            initialSelection: currentTerm!.id,
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
          height: 10,
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
                currentTerm = _termSelectorValue;
                onCurrentTerm = _termSelectorValue!.isCurrentTerm;
              });
            },
            child: const Text(
              "View Term's Classes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget _noTermsYet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        InfoCard(
          content:
              "Add a term on the terms page, then create subjects under it on the subject page. Your created subjects will be displayed here.",
        )
      ],
    );
  }
}
