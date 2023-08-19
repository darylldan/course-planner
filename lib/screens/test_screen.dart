import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:course_planner/widgets/cards/error_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/term_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Term.dart';
import '../utils/constants.dart' as Constants;
import '../widgets/elements/title_text.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final key = GlobalKey<AnimatedListState>();
  late int nextIndex;
  int counter = 1;

  Term testTerm = Term()
    ..academicYear = "A.Y. 2023 - 2024"
    ..semester = "First Semester";

  @override
  Widget build(BuildContext context) {
    var termList = context.watch<TermProvider>().terms;
    nextIndex = termList.length;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.screenHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TermProvider>().addTerm(
              Term()
                ..academicYear = "$counter + A Y"
                ..isCurrentTerm = false
                ..semester = "$counter Semester");

          key.currentState!.insertItem(nextIndex);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _clickableContainer(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Pressed on tap!")));
          },
          child: Container(
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  }
}
