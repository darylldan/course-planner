import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:course_planner/widgets/cards/error_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/subject_card.dart';
import 'package:course_planner/widgets/cards/term_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/Term.dart';
import '../utils/constants.dart' as C;
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

  Subject s = Subject()
    ..courseCode = "CMSC 143"
    ..isLaboratory = true
    ..description = "Test Course"
    ..section = "ST - 10L"
    ..room = "ICS PC Lab 7"
    ..instructor = "Prof. Juan dela Cruz"
    ..frequency = [Day.tue, Day.thu]
    ..startDate = DateTime(2023, 8, 20, 8)
    ..endDate = DateTime(2023, 8, 20, 11)
    ..termID = 1
    ..notes = "wla lungz";
  @override
  Widget build(BuildContext context) {
    s.color = [
      Theme.of(context).colorScheme.primaryContainer.alpha,
      Theme.of(context).colorScheme.primaryContainer.red,
      Theme.of(context).colorScheme.primaryContainer.green,
      Theme.of(context).colorScheme.primaryContainer.blue,
    ];
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ClassCard(subject: s)],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TermProvider>().addTerm(Term()
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

  Widget _buildSubject(BuildContext context) {
    s.color = [
      Theme.of(context).colorScheme.primaryContainer.alpha,
      Theme.of(context).colorScheme.primaryContainer.red,
      Theme.of(context).colorScheme.primaryContainer.green,
      Theme.of(context).colorScheme.primaryContainer.blue,
    ];

    return Material(
      child: Ink(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(C.cardBorderRadius)),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: C.titleCardPaddingH, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromARGB(
                            s.color[0], s.color[1], s.color[2], s.color[3])),
                    width: 4,
                    height: 50,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 275,
                      child: Text(
                        "${s.courseCode} - ${s.isLaboratory ? 'Laboratory' : 'Lecture'}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          constraints: BoxConstraints(
                            maxWidth: 60
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            borderRadius: BorderRadius.circular(4)
                          ),
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                s.section,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        _buildSubjectSubtitle(context),
                      ]
                    )
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert_rounded),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectSubtitle(BuildContext context) {
    String subTitle = "";

    for(var d in s.frequency) {
      switch (d) {
        case Day.mon:
          subTitle = "${subTitle}Mo";
        case Day.tue:
          subTitle = "${subTitle}Tu";
        case Day.wed:
          subTitle = "${subTitle}We";
        case Day.thu:
          subTitle = "${subTitle}Th";
        case Day.fri:
          subTitle = "${subTitle}Fr";
        case Day.sat:
          subTitle = "${subTitle}Sa";
      }
    }

    String startDate = DateFormat.jm().format(s.startDate);
    String endDate = DateFormat.jm().format(s.endDate);

    subTitle = "$subTitle $startDate - $endDate";

    return SizedBox(
      width: 200,
      child: Text(
        subTitle,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant
        ),
      ),
    );
  }
}
