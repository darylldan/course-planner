import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/providers/usersettings_provider.dart';
import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:course_planner/widgets/cards/error_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
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
              ElevatedButton(
                onPressed: () async {
                  var id = await context.read<TermProvider>().addTerm(Term()
                    ..semester = "Second Semester"
                    ..academicYear = "A.Y. 2023 - 2024");

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Added lmao. ID: $id")));
                  }
                },
                child: Text("Add terms"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await context.read<SubjectProvider>().wipeDB();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Wiped db!")));
                  }
                },
                child: Text("Wipe db"),
              ),
              ElevatedButton(
                onPressed: () async {
                  var id = await context
                      .read<UserSettingsProvider>()
                      .getCurrentTermID();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Current term: $id")));
                  }
                },
                child: Text("get current term"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
