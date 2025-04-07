import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/terms_module/edit_term.dart';
import 'package:course_planner/widgets/cards/current_term_selected.dart';
import 'package:course_planner/widgets/cards/subject_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/Subject.dart';
import '../../models/Term.dart';
import '../../utils/constants.dart' as C;

class ViewTerm extends StatefulWidget {
  final termID;
  const ViewTerm({super.key, required this.termID});

  @override
  State<ViewTerm> createState() => _ViewTermState();
}

class _ViewTermState extends State<ViewTerm> {
  late Term? _term;
  final _screenTitle = "View Term";

  @override
  Widget build(BuildContext context) {
    _term = context.watch<TermProvider>().getTermByID(widget.termID);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTerm(term: _term!)));
            },
            icon: const Icon(Icons.edit_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildTermInfo(context),
        ),
      ),
    );
  }

  Widget _buildTermInfo(BuildContext context) {
    List<Subject> subjects =
        context.watch<SubjectProvider>().getSubjectsByTerm(_term!.id!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(C.cardBorderRadius),
              color: Theme.of(context).colorScheme.primaryContainer),
          child: CurrentTermSelectedCard(
            term: _term!,
            onCurrentTerm: _term!.isCurrentTerm,
            editMode: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [Expanded(child: _buildDateRange(context))],
          ),
        ),
        if (subjects.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Expanded(
                  child: Opacity(
                    opacity: 0.5,
                    child: Divider(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "COURSERS",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onInverseSurface),
                  ),
                ),
                const Expanded(
                  child: Opacity(
                    opacity: 0.5,
                    child: Divider(),
                  ),
                ),
              ],
            ),
          ),
        _buildClasses(context, subjects)
      ],
    );
  }

  Widget _buildDateRange(BuildContext context) {
    int weekCount =
        (_term!.endDate.difference(_term!.startDate).inDays / 7).ceil();

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.secondaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.calendar_month,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Text(
                "Semester Duration",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: C.titleCardHeaderFontSize),
              )
            ],
          ),
          Text(
            "${DateFormat("MMM dd, yyyy").format(_term!.startDate)} - ${DateFormat("MMM dd, yyyy").format(_term!.endDate)}",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Text(
            "About $weekCount week${weekCount == 1 ? "" : "s"}.",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: C.titleCardHeaderFontSize),
          )
        ],
      ),
    );
  }

  Widget _buildClasses(BuildContext context, List<Subject> subjects) {
    return Column(
      children: subjects.map<Widget>((s) {
        return ClassCard(subject: s);
      }).toList()
        ..addAll([
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
          ),
          Center(
            child: Text(
              "${subjects.length} ${subjects.length == 1 ? "Course" : "Courses"}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inverseSurface),
            ),
          ),
          const SizedBox(
            height: 120,
          )
        ]),
    );
  }
}
