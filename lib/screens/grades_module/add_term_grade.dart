import 'package:iskotrack/models/TermGrade.dart';
import 'package:iskotrack/providers/term_grade_provider.dart';
import 'package:iskotrack/utils/enums.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class AddTermGrade extends StatefulWidget {
  final bool editMode;
  final TermGrade? termGrade;

  const AddTermGrade({super.key, this.editMode = false, this.termGrade});

  @override
  State<AddTermGrade> createState() => _AddTermGradeState();
}

class _AddTermGradeState extends State<AddTermGrade> {
  final _formKey = GlobalKey<FormState>();

  late final List<DropdownMenuEntry<NumericalGrade>> _gradeOptions;

  final TextEditingController _semesterCtrl = TextEditingController();
  final TextEditingController _acadYearCtrl = TextEditingController();
  final TextEditingController _unitsCtrl = TextEditingController();
  final TextEditingController _gradeCtrl = TextEditingController();

  NumericalGrade? _selectedNumGrade;

  @override
  void initState() {
    super.initState();

    _gradeOptions = NumericalGrade.values
        .where((ng) => ng != NumericalGrade.drp && ng != NumericalGrade.inc)
        .map((ng) => DropdownMenuEntry(
            value: ng, label: GradeMethods.getValue(ng).toString()))
        .toList();
    _selectedNumGrade = NumericalGrade.g1_00;

    // Unpack
    if (widget.editMode) {
      _semesterCtrl.text = widget.termGrade!.semester;
      _acadYearCtrl.text = widget.termGrade!.academicYear;
      _unitsCtrl.text = widget.termGrade!.units.toString();
      _gradeCtrl.text = widget.termGrade!.grade.toString();
    }
  }

  @override
  void dispose() {
    _semesterCtrl.dispose();
    _acadYearCtrl.dispose();
    _unitsCtrl.dispose();
    _gradeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
                title: widget.editMode ? "Edit Term Grade" : "Add Term Grade"),
            InfoCard(
                content:
                    "Enter the GWA for a completed term to record its grade. All fields are required."),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 4),
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),
            _buildForm(context),
            const SizedBox(height: 150)
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Check if form is empty
          bool canPop;

          if (widget.editMode) {
            canPop = _acadYearCtrl.text == widget.termGrade!.academicYear &&
                _semesterCtrl.text == widget.termGrade!.semester &&
                int.tryParse(_unitsCtrl.text) == widget.termGrade!.units &&
                double.parse(_gradeCtrl.text) == widget.termGrade!.grade;
          } else {
            canPop = _acadYearCtrl.text.isEmpty &&
                _semesterCtrl.text.isEmpty &&
                _unitsCtrl.text.isEmpty &&
                _gradeCtrl.text.isEmpty;
          }

          if (canPop) {
            if (context.mounted) Navigator.of(context).pop();
          } else {
            var shouldExit = await _onWillPop(context);
            if (shouldExit) {
              if (context.mounted) Navigator.of(context).pop();
            }
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Term Name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _semesterCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Enter Name (Ex. "First Semester")',
                    labelText: 'Semester'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the semester.";
                  }

                  return null;
                },
              ),
            ),

            // Academic Year
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _acadYearCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Enter A.Y. (Ex. "A.Y. 2023 - 2024")',
                    labelText: 'Academic Year'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the Academic Year.";
                  }

                  return null;
                },
              ),
            ),

            // Units
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _unitsCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: 'Number of Units'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter number of units.";
                  }

                  int? numValue = int.tryParse(value);

                  if (numValue == null) {
                    return "Invalid number of units.";
                  }

                  if (numValue <= 0) {
                    return "Number of units should be at least 1.";
                  }

                  return null;
                },
              ),
            ),

            // Units
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _gradeCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelText: 'Grade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your grade.";
                  }

                  double? numValue = double.tryParse(value);

                  if (numValue == null) {
                    return "Invalid grade.";
                  }

                  if (numValue < 1.0) {
                    return "Grades should be at least 1.0";
                  }

                  return null;
                },
              ),
            ),

            // Create button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primaryContainer)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          TermGrade newTermGrade = TermGrade()
                            ..academicYear = _acadYearCtrl.text
                            ..semester = _semesterCtrl.text
                            ..units = int.parse(_unitsCtrl.text)
                            ..grade = double.parse(_gradeCtrl.text);

                          if (widget.editMode) {
                            newTermGrade.id = widget.termGrade!.id;
                            context
                                .read<TermGradeProvider>()
                                .editTermGrade(newTermGrade);
                          } else {
                            context
                                .read<TermGradeProvider>()
                                .createTermGrade(newTermGrade);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Term grade ${widget.editMode ? "edited" : "added"}."),
                          ));
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGradeSelector(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownMenu<NumericalGrade>(
        inputDecorationTheme: InputDecorationTheme(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        width: double.infinity,
        initialSelection: _selectedNumGrade,
        label: Text("Grade"),
        hintText: "Grade",
        dropdownMenuEntries: _gradeOptions,
        onSelected: (val) {
          setState(() {
            _selectedNumGrade = val;
          });
        },
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(widget.editMode
                    ? "Discard term grade editing?"
                    : "Discard term grade creation?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Discard'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  )
                ],
              );
            })) ??
        false;
  }
}
