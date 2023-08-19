import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/add_term.dart';
import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:course_planner/widgets/cards/error_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/term_card.dart';
import 'package:course_planner/widgets/elements/current_star.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Term.dart';
import '../utils/constants.dart' as Constants;

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  _TermState createState() => _TermState();
}

class _TermState extends State<Terms> {
  final screenTitle = "Terms";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.screenHorizontalPadding),
          child: _buildTermScreen(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTerm())
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildTermScreen(BuildContext context) {
    List<Term> terms = context.watch<TermProvider>().terms;

    if (terms.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: screenTitle),
          InfoCard(
            content: "No terms yet. Create one via the Add button below.",
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: screenTitle),
        _buildCurrentTerm(context),
        const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 4),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        ...terms.map<TermCard>((Term term) {
          return TermCard(term: term);
        }).toList(),
      ],
    );
  }

  Widget _buildCurrentTerm(BuildContext context) {
    return CurrentTermCard(
        term: context.watch<TermProvider>().currentTerm!, onCurrentTerm: true);
  }
}
