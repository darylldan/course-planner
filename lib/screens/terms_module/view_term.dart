import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/terms_module/edit_term.dart';
import 'package:course_planner/widgets/cards/current_term_selected.dart';
import 'package:course_planner/widgets/cards/subject_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          padding: const EdgeInsets.only(top: 10, bottom: 4),
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
                  "SUBJECTS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surfaceVariant),
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
        _buildClasses(context)
      ],
    );
  }

  Widget _buildClasses(BuildContext context) {
    List<Subject> subjects =
        context.watch<SubjectProvider>().getSubjectsByTerm(_term!.id!);

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
              "${subjects.length} ${subjects.length == 1 ? "Subject" : "Subjects"}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surfaceVariant),
            ),
          ),
          const SizedBox(
            height: 120,
          )
        ]),
    );
  }
}
