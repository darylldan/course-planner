import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Term.dart';
import '../utils/constants.dart' as Constants;

class EditTerm extends StatefulWidget {
  final Term term;
  const EditTerm({super.key, required this.term});

  @override
  _EditTermState createState() => _EditTermState();
}

class _EditTermState extends State<EditTerm> {
  final _screenTitle = "Edit Term";
  final TextEditingController _semesterCtrl = TextEditingController();
  final TextEditingController _acadYearCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _semesterCtrl.text = widget.term.semester;
    _acadYearCtrl.text = widget.term.academicYear;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: _screenTitle),
              InfoCard(content: "Edit the field you want to change."),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 4),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
              CurrentTermCard(
                  term: widget.term,
                  onCurrentTerm: widget.term.isCurrentTerm,
                  editMode: true),
              const SizedBox(height: 14,),
              _buildForm(context)
            ],
          )),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      onWillPop: () async {
        if (_acadYearCtrl.text == widget.term.academicYear &&
            _semesterCtrl.text == widget.term.semester) {
          return true;
        }

        return _onWillPop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: _acadYearCtrl,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'Enter A.Y. (Ex. "A.Y. 2023 - 2024")',
                  labelText: 'Enter Academic Year'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the Academic Year.";
                }

                return null;
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      textStyle: const MaterialStatePropertyAll(
                        TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primaryContainer),
                      foregroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimaryContainer)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      widget.term.academicYear = _acadYearCtrl.text;
                      widget.term.semester = _semesterCtrl.text;
                      context.read<TermProvider>().editTerm(widget.term);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Changes saved.")));
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Discard term creation?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Discard'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                )
                              ],
                            );
                          });
                    },
                    child: const Text("Discard"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Discard changes?"),
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
