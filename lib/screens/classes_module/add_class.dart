import 'dart:math';

import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/widgets/cards/error_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/overlap_warning_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../models/Term.dart';
import '../../utils/enums.dart';
import '../../utils/constants.dart' as C;

class AddClass extends StatefulWidget {
  List<Term> terms;
  AddClass({super.key, required this.terms});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _screenTitle = "Create New Class";
  final _formKey = GlobalKey<FormState>();

  final _courseCodeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  Color? _courseColor;
  bool _isLaboratory = false;

  int? _selectedTermID;

  DateTime? _startDate;
  DateTime? _endDate;

  Map<Day, bool> _frequency = {
    Day.mon: false,
    Day.tue: false,
    Day.wed: false,
    Day.thu: false,
    Day.fri: false,
    Day.sat: false,
  };

  List<Color?> _colors = [
    Colors.red.shade600,
    Colors.pink.shade600,
    Colors.purple.shade600,
    Colors.deepPurple.shade600,
    Colors.indigo.shade600,
    Colors.blue.shade600,
    Colors.lightBlue.shade600,
    Colors.cyan.shade600,
    Colors.teal.shade600,
    Colors.green.shade600,
    Colors.lightGreen.shade600,
    Colors.lime.shade600,
    Colors.yellow.shade700,
    Colors.amber.shade600,
    Colors.orange.shade600,
    Colors.deepOrange.shade600,
    Colors.brown.shade600,
    Colors.grey.shade600,
    Colors.blueGrey.shade600,
    Colors.black87,
  ];

  // Validation flags
  bool _isFrequencyInvalid = false;
  bool _isDatesInvalid = false;
  bool _isTermInvalid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: _screenTitle),
              InfoCard(
                  content:
                      "Complete required fields. Avoid schedule conflicts when creating classes."),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    _courseColor ??= _colors[Random().nextInt(_colors.length - 1)];

    return Form(
      key: _formKey,
      onWillPop: () async {
        if (_courseCodeCtrl.text.isEmpty &&
            _sectionCtrl.text.isEmpty &&
            _roomCtrl.text.isEmpty &&
            _instructorCtrl.text.isEmpty &&
            _notesCtrl.text.isEmpty) return true;
        return _onWillPop();
      },
      child: Column(
        children: [
          // Course code and course color
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: TextFormField(
                    controller: _courseCodeCtrl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'Enter Course Code (Ex. CMSC 12)',
                        labelText: 'Course Code'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter course code.";
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(_courseColor)),
                    onPressed: () {
                      _showColorPicker();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                    ),
                  ),
                )
              ],
            ),
          ),

          // isLaboratory
          _classTypeRadio(),

          // Class descrpition
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: _descCtrl,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: '"Foundations of Computer Science"',
                  labelText: 'Description (Optional)'),
            ),
          ),

          // Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: _sectionCtrl,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'Enter section ("ST - 4L")',
                  labelText: 'Section'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter section.";
                }

                return null;
              },
            ),
          ),

          // Room
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: _roomCtrl,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'Enter room ("ICS Megahall")',
                  labelText: 'Room'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter room.";
                }

                return null;
              },
            ),
          ),

          // Instructor
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: _instructorCtrl,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'Prof. Juan Dela Cruz',
                  labelText: 'Instructor (Optional)'),
            ),
          ),

          // Term selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _termSelector(),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
          ),

          // Class time selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _classTimeSelector(),
          ),

          // Frequency selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _frequencySelector(),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _notesCtrl,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: '"Enter notes here (Optional)"',
                  labelText: 'Notes (Optional)'),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primaryContainer)),
                  onPressed: _submit,
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              )
            ],
          ),

          const SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }

  void _submit() {
    _validateOtherFields();
    if (_formKey.currentState!.validate() && _validateOtherFields()) {
      _formKey.currentState?.save();

      // check first for overlaps
      var overlapResult =
          context.read<SubjectProvider>().checkForOverlap(_packSubject());

      if (overlapResult['isOverlapping']) {
        List<Subject> overlappingSubjects = [];
        for (int i in overlapResult['overlapSubjectIDs']) {
          overlappingSubjects
              .add(context.read<SubjectProvider>().getSubjectByID(i));
        }

        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: OverlapWarningCard(subjects: overlappingSubjects),
            );
          },
        );
      } else {
        context.read<SubjectProvider>().createSubject(_packSubject());

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Subject added."),
        ));
        Navigator.of(context).pop();
      }
    }
  }

  // Custom validation for frequency selector, term selector, and date selector
  bool _validateOtherFields() {
    bool isValidForm = true;

    if (_selectedTermID == null) {
      _isTermInvalid = true;
      isValidForm = false;
    } else {
      _isTermInvalid = false;
    }

    if (_frequency.entries
        .toList()
        .every((element) => element.value == false)) {
      _isFrequencyInvalid = true;
      isValidForm = false;
    } else {
      _isFrequencyInvalid = false;
    }

    if (_startDate == null ||
        _endDate == null ||
        _startDate == null ||
        _endDate!.isBefore(_startDate!) ||
        _startDate!.isAfter(_endDate!)) {
      _isDatesInvalid = true;
      isValidForm = false;
    } else {
      _isDatesInvalid = false;
    }

    setState(() {});

    return isValidForm;
  }

  Widget _frequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Frequency",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
        ),
        if (_isFrequencyInvalid)
          Text(
            "Please select at least one day.",
            style: TextStyle(
                color: Theme.of(context).colorScheme.error, fontSize: 12),
          ),
        ..._frequency.keys.map<CheckboxListTile>((e) {
          return CheckboxListTile(
            title: Text(_dayEnumToName(e)),
            value: _frequency[e],
            onChanged: (value) {
              setState(() {
                _frequency[e] = value!;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  String _dayEnumToName(Day day) {
    switch (day) {
      case Day.mon:
        return "Monday";
      case Day.tue:
        return "Tuesday";
      case Day.wed:
        return "Wednesday";
      case Day.thu:
        return "Thursday";
      case Day.fri:
        return "Friday";
      case Day.sat:
        return "Saturday";
    }
  }

  Widget _classTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Timeslot",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
        ),
        if (_isDatesInvalid)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              "Please enter a valid timeslot.",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 7, minute: 0));

                    if (context.mounted) {
                      if (time == null) {
                        return;
                      }

                      if (time.hour < 7 || time.hour > 19) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Dialog(
                              child: ErrorCard(
                                  title: "Invalid Time",
                                  content:
                                      "The class only supports time from 7am to 7pm."),
                            );
                          },
                        );
                      } else {
                        setState(() {
                          _startDate =
                              DateTime(2024, 8, 20, time.hour, time.minute);
                        });
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Text("Start Time: ${_dateTimeToString(_startDate)}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 8, minute: 0));

                    if (context.mounted) {
                      if (time == null) {
                        return;
                      }

                      if (time.hour < 7 || time.hour > 19) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Dialog(
                              child: ErrorCard(
                                  title: "Invalid Time",
                                  content:
                                      "The class only supports time from 7am to 7pm."),
                            );
                          },
                        );
                      } else {
                        setState(() {
                          _endDate =
                              DateTime(2024, 8, 20, time.hour, time.minute);
                        });
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text("End Time: ${_dateTimeToString(_endDate)}")
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  String _dateTimeToString(DateTime? dateTime) {
    if (dateTime == null) {
      return "Not Set";
    }

    return DateFormat.jm().format(dateTime);
  }

  Widget _termSelector() {
    List<DropdownMenuEntry<int>> entries = [];

    for (var t in widget.terms) {
      String label = "${t.semester}, ${t.academicYear}";
      
      // Needed because the new dropdown menu does not catch text overflows
      if (label.length > 36) {
        label = "${label.substring(0, 37)}...";
      }
      entries.add(DropdownMenuEntry(
          value: t.id!,
          label: label,
          trailingIcon: t.isCurrentTerm ? const Icon(Icons.star_rounded) : null));
    }

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownMenu<int>(
        // needed the width because there are no way to set the width so that it takes up the entire width of parent
        width: 390,
        initialSelection: null,
        inputDecorationTheme: InputDecorationTheme(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        label: const Text("Term"),
        dropdownMenuEntries: entries,
        onSelected: (int? termID) {
          setState(() {
            _selectedTermID = termID;
          });
        },
        errorText: _isTermInvalid ? "Please select a term." : null,
      ),
    );
  }

  Widget _classTypeRadio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: RadioListTile<bool>(
              title: const Text("Lecture"),
              value: false,
              groupValue: _isLaboratory,
              onChanged: (bool? value) {
                setState(() {
                  _isLaboratory = value!;
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile<bool>(
              title: const Text("Laboratory"),
              value: true,
              groupValue: _isLaboratory,
              onChanged: (bool? value) {
                setState(() {
                  _isLaboratory = value!;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  // Custom color picker
  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 450,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 25, bottom: 16),
                child: Text(
                  "Select Color",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
              Flexible(flex: 1, child: _buildColors())
            ],
          ),
        );
      },
    );
  }

  Widget _buildColors() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 20,
      crossAxisSpacing: 30,
      crossAxisCount: 5,
      children: _colors.map<Widget>((e) => _colorCube(e!)).toList(),
    );
  }

  Widget _colorCube(Color color) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.pop(context);
            setState(() {
              _courseColor = color;
            });
          },
          child: Container(
            height: 10,
            width: 10,
            child: (color == _courseColor)
                ? const Center(
                    child: Icon(Icons.check),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  // Responsible for "Discard creation?"
  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Discard class creation?"),
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

  Subject _packSubject() {
    return Subject()
      ..courseCode = _courseCodeCtrl.text
      ..color = [
        _courseColor!.alpha,
        _courseColor!.red,
        _courseColor!.green,
        _courseColor!.blue
      ]
      ..isLaboratory = _isLaboratory
      ..description = _descCtrl.text
      ..section = _sectionCtrl.text
      ..room = _roomCtrl.text
      ..instructor = _instructorCtrl.text
      ..termID = _selectedTermID!
      ..frequency =
          _frequency.keys.toList().where((d) => _frequency[d]!).toList()
      ..startDate = _startDate!
      ..endDate = _endDate!
      ..notes = _notesCtrl.text;
  }
}
