import 'dart:math';

import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/CourseGrade.dart';
import 'package:course_planner/models/CourseTemplate.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/models/SharedCourse.dart';
import 'package:course_planner/providers/course_grade_provider.dart';
import 'package:course_planner/providers/course_template_provider.dart';
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
  final Term term;
  final bool editMode;
  final Subject? course;
  final SharedCourse? sc;
  final bool fromSharing;
  const AddClass({
    super.key,
    required this.term,
    this.editMode = false,
    this.course,
    this.sc,
    this.fromSharing = false,
  });

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _formKey = GlobalKey<FormState>();

  final _courseCodeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _unitsCtrl = TextEditingController();

  final _courseCodeFN = FocusNode();

  bool _isCredited = true;
  Color? _courseColor;

  int? _selectedLocationID;
  String? _selectedLocationType;
  String? _selectedLocName;

  DateTime? _startDate;
  DateTime? _endDate;

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

  @override
  void initState() {
    super.initState();
    _courseCodeFN.addListener(_autoCompleteCourseDetails);

    if (widget.editMode) {
      _courseCodeCtrl.text = widget.course!.courseCode;

      _classTypeSelection = widget.course!.isLaboratory
          ? <ClassType>{ClassType.lab}
          : <ClassType>{ClassType.lec};

      _unitsCtrl.text = widget.course!.units.toString();
      _isCredited = widget.course!.credited;
      _descCtrl.text = widget.course!.description ?? "";
      _sectionCtrl.text = widget.course!.section;
      _instructorCtrl.text = widget.course!.instructor ?? "";
      _selectedLocationID = widget.course!.locationID;
      _selectedLocationType = widget.course!.locationType;
      _notesCtrl.text = widget.course!.notes ?? "";

      _startDate = widget.course!.startDate;
      _endDate = widget.course!.endDate;

      for (Day f in widget.course!.frequency) {
        _selection.add(f);
      }

      for (var c in _colors) {
        if (c!.alpha == widget.course!.color[0] &&
            c.red == widget.course!.color[1] &&
            c.green == widget.course!.color[2] &&
            c.blue == widget.course!.color[3]) {
          _courseColor = c;
        }
      }
    }

    if (widget.fromSharing && widget.sc != null) {
      _courseCodeCtrl.text = widget.sc!.courseCode;
      _classTypeSelection =
          widget.sc!.isLaboratory ? {ClassType.lab} : {ClassType.lec};
      _descCtrl.text = widget.sc!.description ?? "";
      _instructorCtrl.text = widget.sc!.instructor ?? "";
      _sectionCtrl.text = widget.sc!.section;
      _selection =
          widget.sc!.frequency.map((f) => DayMethods.intToDay(f)!).toSet();
      _notesCtrl.text = widget.sc!.notes ?? "";
      _startDate = widget.sc!.startDate != null
          ? DateTime(
              widget.term.startDate.year,
              widget.term.startDate.month,
              widget.term.startDate.day,
              widget.sc!.startDate!.hour,
              widget.sc!.startDate!.minute)
          : null;
      _endDate = widget.sc!.endDate != null
          ? DateTime(
              widget.term.startDate.year,
              widget.term.startDate.month,
              widget.term.startDate.day,
              widget.sc!.endDate!.hour,
              widget.sc!.endDate!.minute)
          : null;
      _unitsCtrl.text = widget.sc!.units.toString();
      _isCredited = widget.sc!.credited;
      for (var c in _colors) {
        if (c!.alpha == widget.sc!.color[0] &&
            c.red == widget.sc!.color[1] &&
            c.green == widget.sc!.color[2] &&
            c.blue == widget.sc!.color[3]) {
          _courseColor = c;
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course downloaded.')),
        );
      });
    }
  }

  void _autoCompleteCourseDetails() {
    if (!_courseCodeFN.hasFocus) {
      CourseTemplate? res =
          Provider.of<CourseTemplateProvider>(context, listen: false)
              .findCourse(_courseCodeCtrl.text.trim());

      if (res != null) {
        setState(() {
          _courseCodeCtrl.text = res.courseCode;
          _descCtrl.text = res.description;
          _isCredited = res.credited;

          if (res.units != null) {
            _unitsCtrl.text = res.units.toString();
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Course details auto-filled.")));
      }
    }
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
              TitleText(
                  title: widget.editMode ? "Edit Course" : "Create New Course"),
              InfoCard(
                  content:
                      "Complete required fields. Avoid schedule conflicts when creating courses."),
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

  bool _setAndListEqual<T>(Set<T> set, List<T> list) {
    // Convert both to sets to ignore order and duplicates
    final setFromList = list.toSet();
    final setFromSet =
        set.toSet(); // This might seem redundant but ensures symmetry

    // Compare the sets
    return setFromSet.length == setFromList.length &&
        setFromSet.containsAll(setFromList);
  }

  bool get _canPop {
    return widget.editMode
        ? _courseCodeCtrl.text == widget.course!.courseCode &&
            _classTypeSelection.contains(
                widget.course!.isLaboratory ? ClassType.lab : ClassType.lec) &&
            _descCtrl.text == widget.course!.description &&
            _sectionCtrl.text == widget.course!.section &&
            _instructorCtrl.text == widget.course!.instructor &&
            _selectedLocationID == widget.course!.locationID &&
            _selectedLocationType == widget.course!.locationType &&
            // _startDate!.isAtSameMomentAs(widget.course!.startDate) &&
            // _endDate!.isAtSameMomentAs(widget.course!.endDate) &&
            _notesCtrl.text == widget.course!.notes &&
            _unitsCtrl.text == widget.course!.units.toString() &&
            _isCredited == widget.course!.credited &&
            (_courseColor!.alpha == widget.course!.color[0] &&
                _courseColor!.red == widget.course!.color[1] &&
                _courseColor!.green == widget.course!.color[2] &&
                _courseColor!.blue == widget.course!.color[3]) &&
            _setAndListEqual(_selection, widget.course!.frequency)
        : _courseCodeCtrl.text.isEmpty &&
            _sectionCtrl.text.isEmpty &&
            _selectedLocationID == null &&
            _instructorCtrl.text.isEmpty &&
            _notesCtrl.text.isEmpty &&
            _selection.isEmpty &&
            _descCtrl.text.isEmpty &&
            _startDate == null &&
            _endDate == null &&
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
                      textCapitalization: TextCapitalization.characters,
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
                      focusNode: _courseCodeFN,
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
                            _isCredited = val!;
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

      bool didCGChange = false;

      Subject newSubject = _packSubject();

      if (widget.editMode) {
        newSubject.id = widget.course!.id!;
      }

      if (newSubject.startDate != null &&
          newSubject.endDate != null &&
          newSubject.frequency.isNotEmpty) {
        // check first for overlaps
        var overlapResult =
            context.read<SubjectProvider>().checkForOverlap(newSubject);

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

          return;
        }
      }
      if (widget.editMode) {
        if (_didCourseGradeChange()) {
          // Check if there are already coursegrade for edited subj
          bool cgExistence = context
              .read<CourseGradeProvider>()
              .doesCourseHaveCourseGrade(newSubject);

          List<Subject> courses = context
              .read<SubjectProvider>()
              .getSubjectsByTerm(widget.course!.termID)
              .where((c) => c.id != widget.course!.id!)
              .toList();

          CourseGrade oldCG = context
              .read<CourseGradeProvider>()
              .getCourseGradeByCourse(widget.course!);

          if (!cgExistence) {
            CourseGrade newCourseGrade = CourseGrade()
              ..courseCode = newSubject.courseCode
              ..isCredited = newSubject.credited
              ..termId = newSubject.termID
              ..units = newSubject.units;

            context
                .read<CourseGradeProvider>()
                .createCourseGrade(newCourseGrade);

            // now check if the old coursegrade still have dependency
            if (!context
                .read<CourseGradeProvider>()
                .doesCourseGradeHaveDependency(oldCG, courses)) {
              didCGChange = true;
              context.read<CourseGradeProvider>().deleteCourseGrade(oldCG.id!);
            }
          }
        }

        context.read<SubjectProvider>().editSubject(newSubject);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Course edited. ${didCGChange ? "Grade set for this course were cleared." : ""}"),
        ));

        Navigator.of(context).pop();
      } else {
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
    // resetting date flags
    _isDatesInvalid = false;
    _isFrequencyInvalid = false;

    bool isValidForm = true;

    if (_startDate != null && _endDate == null) {
      _isDatesInvalid = true;
    } else if (_startDate != null && _endDate != null) {
      if (_selection.isEmpty) {
        _isFrequencyInvalid = true;
      }

      if (_endDate!.isBefore(_startDate!) ||
          _startDate!.isAfter(_endDate!) ||
          _endDate!.isAtSameMomentAs(_startDate!)) {
        _isDatesInvalid = true;
      }
    }

    setState(() {});

    return isValidForm && !_isFrequencyInvalid && !_isDatesInvalid;
  }

  Widget _roomSelector(BuildContext context) {
    return GestureDetector(
      onTap: _selectedLocName != null
          ? () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(_selectedLocName!)));
            }
          : null,
      child: Row(
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
      ),
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
          onSelectionChanged: _startDate == null || _endDate == null
              ? null
              : (Set<Day> newSelection) {
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
            Row(
              children: [
                if (_startDate != null)
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _startDate = null;
                          _selection.clear();
                        });
                      },
                      icon: Icon(Icons.cancel)),
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
                              widget.term.startDate.year,
                              widget.term.startDate.month,
                              widget.term.startDate.day,
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
                ),
              ],
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
            Row(
              children: [
                if (_endDate != null)
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _endDate = null;
                          _selection.clear();
                        });
                      },
                      icon: Icon(Icons.cancel)),
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
                                    widget.term.startDate.year,
                                    widget.term.startDate.month,
                                    widget.term.startDate.day,
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
                ),
              ],
            )
          ],
        ),
      ],
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

  bool _didCourseGradeChange() {
    if (_courseCodeCtrl.text.toLowerCase() !=
        widget.course!.courseCode.toLowerCase()) {
      return true;
    }

    if (_unitsCtrl.text != widget.course!.units.toString()) {
      return true;
    }

    if (_isCredited != widget.course!.credited) {
      return true;
    }

    return false;
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
      ..credited = _isCredited
      ..description = _descCtrl.text
      ..section = _sectionCtrl.text
      ..instructor = _instructorCtrl.text
      ..termID = widget.term.id!
      ..locationID = _selectedLocationID
      ..locationType = _selectedLocationType
      ..frequency = _selection.toList()
      ..startDate = _startDate
      ..endDate = _endDate
      ..notes = _notesCtrl.text;
  }
}
