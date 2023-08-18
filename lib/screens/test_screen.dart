import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:flutter/material.dart';
import '../models/Term.dart';
import '../utils/constants.dart' as Constants;
import '../widgets/elements/title_text.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Term testTerm = Term()
    ..academicYear = "A.Y. 2023 - 2024"
    ..semester = "First Semester";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: "Terms"),
              CurrentTermCard(term: testTerm, onCurrentTerm: true),
            ],
          ),
        ),
      ),
    );
  }
}
