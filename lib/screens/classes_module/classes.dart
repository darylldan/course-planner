import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/classes_module/add_class.dart';
import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:course_planner/widgets/cards/current_term_selected.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/subject_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Term.dart';
import '../../utils/constants.dart' as C;
import '../../utils/enums.dart';

class Classes extends StatefulWidget {
  const Classes({super.key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final _screenTitle = "Classes";
  late Term? currentTerm;
  bool onCurrentTerm = true;
  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: _buildClassesScreen(context),
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddClass(
                              terms: context.read<TermProvider>().terms,
                            )));
              },
              label: Text("Create Subject"),
              icon: Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  Widget _buildClassesScreen(BuildContext context) {
    if (onCurrentTerm) {
      currentTerm = context.watch<TermProvider>().currentTerm;
    }

    if (currentTerm == null) {
      _showFab = false;
      return _noTermsYet();
    } else {
      _showFab = true;
    }

    List<Subject> subjects = context
        .watch<SubjectProvider>()
        .subjects
        .where((e) => e.termID == currentTerm!.id)
        .toList();

    if (subjects.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: _screenTitle),
          _buildCurrentTerm(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
          ),
          InfoCard(
            content: "No subjects yet. Create one via the Add button below.",
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        _buildCurrentTerm(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Column(
          children: subjects.map<ClassCard>((c) {
            return ClassCard(subject: c);
          }).toList(),
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
              "Begin by adding a term on the terms page. Once a term is added, you can proceed to create a subject under that term on this page",
        )
      ],
    );
  }

  Widget _buildCurrentTerm() {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () {},
          child: CurrentTermSelectedCard(
            term: currentTerm!,
            editMode: false,
            onCurrentTerm: currentTerm!.isCurrentTerm,
          ),
        ),
      ),
    );
  }
}
