import 'dart:math';

import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
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

  late Term _currentTerm;

  final Map<Day, bool> _frequency = {
    Day.mon: false,
    Day.tue: false,
    Day.wed: false,
    Day.thu: false,
    Day.fri: false,
    Day.sat: false,
  };
  Set<Day> _selection = <Day>{};

  final List<Color?> _colors = [
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
  void initState() {
    super.initState();
    _currentTerm = widget.terms.firstWhere((t) => t.isCurrentTerm);
  }

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
              _buildForm(context),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canPop {
    return _courseCodeCtrl.text.isEmpty &&
        _sectionCtrl.text.isEmpty &&
        _roomCtrl.text.isEmpty &&
        _instructorCtrl.text.isEmpty &&
        _notesCtrl.text.isEmpty;
  }

  Widget _buildForm(BuildContext context) {
    _courseColor ??= _colors[Random().nextInt(_colors.length - 1)];

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        var shouldExit = await _onWillPop(context);
        if (shouldExit) {
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Form(
        key: _formKey,
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
                              WidgetStatePropertyAll(_courseColor)),
                      onPressed: () {
                        _showColorPicker();
                      },
                      child: SizedBox(
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
              child: _classTimeSelector(context),
            ),

            // Frequency selector
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _frequencySelector(context),
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
                        backgroundColor: WidgetStatePropertyAll(
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

  Widget _frequencySelector(BuildContext context) {
    return SegmentedButton<Day>(
      segments: const [
        ButtonSegment<Day>(value: Day.mon, label: Text("Mon")),
        ButtonSegment<Day>(value: Day.tue, label: Text("Tue")),
        ButtonSegment<Day>(value: Day.wed, label: Text("Wed")),
        ButtonSegment<Day>(value: Day.thu, label: Text("Thu")),
        ButtonSegment<Day>(value: Day.fri, label: Text("Fri")),
        ButtonSegment<Day>(value: Day.sat, label: Text("Sat")),
      ],
      selected: _selection,
      onSelectionChanged: (Set<Day> newSelection) {
        setState(() {
          _selection = newSelection;
        });
      },
      multiSelectionEnabled: true,
      emptySelectionAllowed: true,
      showSelectedIcon: false,
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

  Widget _classTimeSelector(BuildContext context) {
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start Time"),
              TextButton(
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: _startDate == null
                          ? const TimeOfDay(hour: 7, minute: 0)
                          : TimeOfDay(
                              hour: _startDate!.hour,
                              minute: _startDate!.minute));

                  if (context.mounted) {
                    if (time == null) {
                      return;
                    }

                    if (time.hour < 7 ||
                        (time.hour >= 21 && time.minute > 0) ||
                        time.hour > 21) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(
                            child: ErrorCard(
                                title: "Invalid Time",
                                content:
                                    "The class only supports time from 7am to 9pm."),
                          );
                        },
                      );
                    } else {
                      setState(() {
                        _startDate = DateTime(
                            _currentTerm.startDate.year,
                            _currentTerm.startDate.month,
                            _currentTerm.startDate.day,
                            time.hour,
                            time.minute);
                      });
                    }
                  }
                },
                child: Text(_startDate != null
                    ? DateFormat.jm().format(_startDate!)
                    : "Select Time"),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("End Time"),
              TextButton(
                onPressed: _startDate == null
                    ? null
                    : () async {
                        final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: _endDate == null
                                ? const TimeOfDay(hour: 7, minute: 0)
                                : TimeOfDay(
                                    hour: _endDate!.hour,
                                    minute: _endDate!.minute));

                        if (context.mounted) {
                          if (time == null) {
                            return;
                          }

                          if (time.hour < 7 ||
                              (time.hour >= 21 && time.minute > 0) ||
                              time.hour > 21) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const Dialog(
                                  child: ErrorCard(
                                      title: "Invalid Time",
                                      content:
                                          "The class only supports time from 7am to 9pm."),
                                );
                              },
                            );
                          } else {
                            setState(() {
                              print(time.toString());
                              _endDate = DateTime(
                                  _currentTerm.startDate.year,
                                  _currentTerm.startDate.month,
                                  _currentTerm.startDate.day,
                                  time.hour,
                                  time.minute);
                            });
                          }
                        }
                      },
                child: Text(_endDate != null
                    ? DateFormat.jm().format(_endDate!)
                    : "Select Time"),
              )
            ],
          ),
        )
      ],
    );
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
          trailingIcon:
              t.isCurrentTerm ? const Icon(Icons.star_rounded) : null));
    }

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownMenu<int>(
        // needed the width because there are no way to set the width so that it takes up the entire width of parent
        width: 343,
        initialSelection: null,
        inputDecorationTheme: InputDecorationTheme(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        label: const Text("Term"),
        dropdownMenuEntries: entries,
        onSelected: (int? termID) {
          setState(() {
            _selectedTermID = termID;
            _currentTerm = widget.terms.firstWhere((t) => t.isCurrentTerm);

            if (_startDate != null) {
              _startDate = DateTime(
                  _currentTerm.startDate.year,
                  _currentTerm.startDate.month,
                  _currentTerm.startDate.day,
                  _startDate!.hour,
                  _startDate!.minute);
            }

            if (_endDate != null) {
              _endDate = DateTime(
                  _currentTerm.startDate.year,
                  _currentTerm.startDate.month,
                  _currentTerm.startDate.day,
                  _endDate!.hour,
                  _endDate!.minute);
            }
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
  Future<bool> _onWillPop(BuildContext context) async {
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
