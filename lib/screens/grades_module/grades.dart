import 'package:iscompanion/models/Term.dart';
import 'package:iscompanion/models/TermGrade.dart';
import 'package:iscompanion/providers/term_grade_provider.dart';
import 'package:iscompanion/providers/term_provider.dart';
import 'package:iscompanion/screens/grades_module/add_term_grade.dart';
import 'package:iscompanion/screens/grades_module/insights.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/cards/overall_gwa_card.dart';
import 'package:iscompanion/widgets/cards/term_grade_card.dart';
import 'package:iscompanion/widgets/elements/drawer.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class Grades extends StatefulWidget {
  const Grades({super.key});

  @override
  State<Grades> createState() => _GradesState();
}

bool showFab = false;

class _GradesState extends State<Grades> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _totalUnitsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_totalUnitsButton(context)],
      ),
      drawer: SideDrawer(parent: "/grades"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TitleText(title: "Grades"), _buildBody(context)],
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTermGrade()),
                );
              },
              label: const Text("Add Term Grade"),
              icon: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  Widget _totalUnitsButton(BuildContext context) {
    int? totalUnitsOverall =
        context.read<TermGradeProvider>().totalUnitsOverall;
    return IconButton(
        onPressed: () => _showTotalUnitsSetter(context, totalUnitsOverall),
        icon: Badge(
          isLabelVisible: totalUnitsOverall == null,
          child: Icon(Icons.build),
        ));
  }

  Widget _buildBody(BuildContext context) {
    List<Term> terms = context.watch<TermProvider>().terms;
    List<TermGrade> termGrade = context.watch<TermGradeProvider>().termGrades;

    if (terms.isEmpty && termGrade.isEmpty) {
      return InfoCard(
          content:
              "There are no terms yet. Add a grade term below to input your general weighted average without creating a term or individual courses.");
    }

    if (!showFab) {
      setState(() {
        showFab = true;
      });
    }

    bool isGradesEmpty = context.watch<TermGradeProvider>().isGradesEmpty();
    List<TermGradeCard> termGradeCards = [];

    for (Term t in terms) {
      termGradeCards.add(TermGradeCard(term: t));
    }

    for (TermGrade t in termGrade) {
      termGradeCards.add(TermGradeCard(term: t));
    }

    double gwa = context.watch<TermGradeProvider>().getOverallGWA();
    int units = context.watch<TermGradeProvider>().getOverallUnitsTaken();
    int? totalUnitsOverall =
        context.read<TermGradeProvider>().totalUnitsOverall;

    return Column(
      children: [
        isGradesEmpty
            ? InfoCard(
                content:
                    "No grades have been entered yet. Click on a term and enter the grades for your courses.")
            : OverallGwaCard(gwa: gwa, totalUnitsTaken: units),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Divider(),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (totalUnitsOverall == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Please set the total required units for your degree program first by clicking the wrench icon at the top before viewing grade insights.")));

                    return;
                  }

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GradeInsights()));
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.tertiaryContainer),
                    foregroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.onTertiaryContainer)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.insights),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "View Insights",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 2,
        ),
        ...termGradeCards,
        SizedBox(
          height: 150,
        )
      ],
    );
  }

  void _showTotalUnitsSetter(BuildContext context, int? initValue) {
    int units = Provider.of<TermGradeProvider>(context, listen: false)
        .getOverallUnitsTaken();
    _totalUnitsCtrl.text = initValue != null ? initValue.toString() : "";

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 300,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: C.screenHorizontalPadding, vertical: 24),
              child: Column(
                children: [
                  const Text(
                    "Set Total Units",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _totalUnitsCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: 'Total Units for Degree Program'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the number of units.";
                            }

                            int? numValue = int.tryParse(value);

                            if (numValue == null) {
                              return "Invalid number of units.";
                            }

                            if (numValue < units) {
                              return "Total number of units must not be less than the total units taken.";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                foregroundColor: WidgetStatePropertyAll(
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                Provider.of<TermGradeProvider>(context,
                                        listen: false)
                                    .setTotalUnits(
                                        int.parse(_totalUnitsCtrl.text));

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Total units for degree program set."),
                                ));
                                Navigator.of(context).pop();
                                setState(() {});
                              }
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
