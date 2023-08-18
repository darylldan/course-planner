import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/providers/usersettings_provider.dart';
import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:course_planner/widgets/cards/error_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
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
  var currentTerm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: context.watch<TermProvider>().listenToTerms(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return _errorWidget();
                } else {
                  return _termListWrapper(context, snapshot.data as List<Term>);
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _errorWidget() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [TitleText(title: screenTitle), ErrorCard()],
    );
  }

  Widget _termListWrapper(BuildContext context, List<Term> terms) {
    if (terms.isEmpty) {
      return ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          TitleText(title: screenTitle),
          InfoCard(
            content: "No terms yet. Create one via the Add button below.",
            fontSize: 24,
          )
        ],
      );
    }

    return FutureBuilder(
      future: context.read<UserSettingsProvider>().getCurrentTermID(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [TitleText(title: screenTitle), ErrorCard()],
              );
            } else {
              return _constructTermScreen(context, snapshot.data);
            }
        }
      },
    );
  }

  Widget _constructTermScreen(BuildContext context, int? currentTermID) {
    return FutureBuilder(
      future: context.read<TermProvider>().getTermByID(currentTermID!),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [TitleText(title: screenTitle), ErrorCard()],
              );
            } else {
              return ListView(
                children: [
                  TitleText(title: screenTitle),
                  CurrentTermCard(term: snapshot.data!, onCurrentTerm: true),
                ],
              );
            }
        }
      },
    );
  }

  Widget _buildTermsList(BuildContext context) {
    return Column(
      children: [],
    );
  }

  // Widget _termContainer(

  // );
}
