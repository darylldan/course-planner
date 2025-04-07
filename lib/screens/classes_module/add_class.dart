import 'dart:math';

import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/CourseGrade.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/providers/course_grade_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/screens/buildings_module/select_building_room.dart';
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

enum ClassType { lec, lab }

class AddClass extends StatefulWidget {
  final List<Term> terms;
  const AddClass({super.key, required this.terms});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _screenTitle = "Create New Course";
  final _formKey = GlobalKey<FormState>();

  final _courseCodeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _unitsCtrl = TextEditingController();

  bool? _isCredited = true;
  Color? _courseColor;

  int? _selectedTermID;
  int? _selectedLocationID;
  String? _selectedLocationType;
  String? _selectedLocName;

  DateTime? _startDate;
  DateTime? _endDate;

  late Term _currentTerm;

  Set<Day> _selection = <Day>{};

  Set<ClassType> _classTypeSelection = <ClassType>{ClassType.lec};

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
        _selectedLocationID == null &&
        _instructorCtrl.text.isEmpty &&
        _notesCtrl.text.isEmpty &&
        _selection.isEmpty &&
        _descCtrl.text.isEmpty &&
        _startDate == null &&
        _endDate == null &&
        _selectedTermID == null &&
        _classTypeSelection.contains(ClassType.lec);
  }

  Widget _buildForm(BuildContext context) {
    _courseColor ??= _colors[Random().nextInt(_colors.length - 1)];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (_canPop) {
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
            // Course code and course color
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _classTypeSelector(context),
            ),

            // Units
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _unitsCtrl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          labelText: 'Units'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter units";
                        }

                        int? parsedVal = int.tryParse(value);

                        if (parsedVal == null) {
                          return "Please enter valid units.";
                        }

                        if (parsedVal <= 0) {
                          return "Units must be at least 1.";
                        }

                        return null;
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onLongPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Credited courses count towards your GWA. Non-credited courses do not (e.g., NSTP1/2, HK11, etc.)."),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      },
                      child: CheckboxListTile(
                        title: const Text("Credited"),
                        value: _isCredited,
                        onChanged: (bool? val) {
                          setState(() {
                            _isCredited = val;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Class descrpition
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
              padding: const EdgeInsets.symmetric(vertical: 8),
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

            // Instructor
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _termSelector(),
            ),

            // Location
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: _roomSelector(context)),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),

            // Class time selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: _classTimeSelector(context),
            ),

            // Frequency selector
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
              padding: const EdgeInsets.symmetric(vertical: 8),
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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
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
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                    ),
                  )
                ],
              ),
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
        Subject newSubject = _packSubject();
        context.read<SubjectProvider>().createSubject(newSubject);

        CourseGrade newCourseGrade = CourseGrade()
          ..courseCode = newSubject.courseCode
          ..isCredited = newSubject.credited
          ..termId = newSubject.termID
          ..units = newSubject.units;

        bool doesCourseGradeExist = context
            .read<CourseGradeProvider>()
            .doesCourseGradeExist(newCourseGrade);

        if (!doesCourseGradeExist) {
          context.read<CourseGradeProvider>().createCourseGrade(newCourseGrade);
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Course added."),
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

    if (_selection.isEmpty) {
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

  Widget _roomSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Location",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
        ),
        Spacer(),
        Flexible(
          fit: FlexFit.loose,
          child: TextButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectBuildingRoom()));

              if (result == null) {
                return;
              }

              if (result is Building) {
                setState(() {
                  _selectedLocationType = "building";
                  _selectedLocName = result.buildingName;
                  _selectedLocationID = result.id!;
                });
              }

              if (result is Room) {
                setState(() {
                  _selectedLocationType = "room";
                  _selectedLocName = result.roomName;
                  _selectedLocationID = result.id!;
                });
              }
            },
            child: Text(
              _selectedLocName ?? "Select",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (_selectedLocationID != null)
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Location cleared."),
                ));
                setState(() {
                  _selectedLocName = null;
                  _selectedLocationType = null;
                  _selectedLocationID = null;
                });
              },
              icon: Icon(Icons.cancel))
      ],
    );
  }

  Widget _classTypeSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SegmentedButton<ClassType>(
            segments: const [
              ButtonSegment<ClassType>(
                  value: ClassType.lec, label: Text("Lecture")),
              ButtonSegment<ClassType>(
                  value: ClassType.lab, label: Text("Laboratory/Recit"))
            ],
            selected: _classTypeSelection,
            onSelectionChanged: (Set<ClassType> newSelection) {
              setState(() {
                _classTypeSelection = newSelection;
              });
            },
            showSelectedIcon: false,
          ),
        ),
      ],
    );
  }

  Widget _frequencySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<Day>(
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
        ),
        if (_isFrequencyInvalid)
          Text("Please select at least one day.",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12))
      ],
    );
  }

  Widget _classTimeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Start Time",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
            ),
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
              child: Text(
                _startDate != null
                    ? DateFormat.jm().format(_startDate!)
                    : "Select Time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "End Time",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
            ),
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
              child: Text(
                _endDate != null
                    ? DateFormat.jm().format(_endDate!)
                    : "Select Time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
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
      ..units = int.parse(_unitsCtrl.text)
      ..isLaboratory = _classTypeSelection.contains(ClassType.lab)
      ..credited = _isCredited!
      ..description = _descCtrl.text
      ..section = _sectionCtrl.text
      ..instructor = _instructorCtrl.text
      ..termID = _selectedTermID!
      ..locationID = _selectedLocationID
      ..locationType = _selectedLocationType
      ..frequency = _selection.toList()
      ..startDate = _startDate!
      ..endDate = _endDate!
      ..notes = _notesCtrl.text;
  }
}
