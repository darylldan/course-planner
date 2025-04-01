import 'package:course_planner/models/CourseGrade.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/providers/course_grade_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_grade_provider.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class CourseGradeCard extends StatefulWidget {
  final CourseGrade courseGrade;

  const CourseGradeCard({super.key, required this.courseGrade});

  @override
  State<CourseGradeCard> createState() => _CourseGradeState();
}

class _CourseGradeState extends State<CourseGradeCard> {
  late CourseGrade _courseGrade;

  late final List<DropdownMenuEntry<dynamic>> _gradeOptions;
  NumericalGrade? _selectedNumGrade;
  NonNumericalGrade? _selectedNonNumGrade;

  @override
  void initState() {
    super.initState();
    _courseGrade = widget.courseGrade;
    _gradeOptions = NumericalGrade.values
        .map((ng) => DropdownMenuEntry<dynamic>(
            value: ng,
            label: ng == NumericalGrade.drp
                ? "DRP"
                : ng == NumericalGrade.inc
                    ? "INC"
                    : GradeMethods.getValue(ng).toString()))
        .toList()
      ..addAll(NonNumericalGrade.values.map((ng) => DropdownMenuEntry<dynamic>(
          value: ng,
          label:
              ng == NonNumericalGrade.s ? "Satisfactory" : "Unsatisfactory")));
    _selectedNumGrade = _courseGrade.grade;
    _selectedNonNumGrade = _courseGrade.nonNumericalGrade;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            onTap: () {
              _showGradePicker(context);
            },
            onLongPress: () => _showActions(context),
            child: _cardContainer(context),
          ),
        ),
      ),
    );
  }

  Widget _cardContainer(BuildContext context) {
    List<Subject> linkedCourses =
        context.read<SubjectProvider>().getLinkedCoursesFromCG(_courseGrade);

    String grade = "";

    if (_courseGrade.grade == null && _courseGrade.nonNumericalGrade != null) {
      grade =
          _courseGrade.nonNumericalGrade == NonNumericalGrade.s ? "S" : "US";
    } else if (_courseGrade.grade != null &&
        _courseGrade.nonNumericalGrade == null) {
      switch (_courseGrade.grade) {
        case NumericalGrade.inc:
          grade = "INC";
        case NumericalGrade.drp:
          grade = "DRP";
        default:
          grade =
              GradeMethods.getValue(_courseGrade.grade!)!.toStringAsFixed(2);
      }
    } else {
      grade = "Not Set";
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: linkedCourses.length == 1
                          ? Color.fromARGB(
                              linkedCourses.first.color[0],
                              linkedCourses.first.color[1],
                              linkedCourses.first.color[2],
                              linkedCourses.first.color[3])
                          : null,
                      gradient: linkedCourses.length > 1
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(
                                    linkedCourses.first.color[0],
                                    linkedCourses.first.color[1],
                                    linkedCourses.first.color[2],
                                    linkedCourses.first.color[3]),
                                Color.fromARGB(
                                    linkedCourses[1].color[0],
                                    linkedCourses[1].color[1],
                                    linkedCourses[1].color[2],
                                    linkedCourses[1].color[3])
                              ],
                            )
                          : null,
                    ),
                    width: 4,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _courseGrade.courseCode,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSubjectSubtitle(context, linkedCourses),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              constraints: BoxConstraints(maxWidth: 60),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Text(
                                  grade,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              ),
                            ),
                          ])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSubtitle(
      BuildContext context, List<Subject> linkedCourses) {
    CourseComponents components = context
        .read<SubjectProvider>()
        .getCourseComponents(
            _courseGrade.courseCode, _courseGrade.termId, _courseGrade.units);
    return Text(
      "${components == CourseComponents.both ? "Lecture and Laboratory" : components == CourseComponents.lec ? "Lecture" : "Laboratory"} (${_courseGrade.units}u)",
    );
  }

  Widget _buildGradeSelector(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownMenu<dynamic>(
        inputDecorationTheme: InputDecorationTheme(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        width: double.infinity,
        initialSelection:
            _selectedNumGrade ?? (_selectedNonNumGrade ?? NumericalGrade.g1_00),
        label: Text("Grade"),
        hintText: "Grade",
        dropdownMenuEntries: _gradeOptions,
        onSelected: (val) {
          setState(() {
            if (val is NumericalGrade) {
              _selectedNonNumGrade = null;
              _selectedNumGrade = val;
            } else if (val is NonNumericalGrade) {
              _selectedNonNumGrade = val;
              _selectedNumGrade = null;
            }
          });
        },
      ),
    );
  }

  void _showGradePicker(BuildContext context) {
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
                    "Set Grade",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildGradeSelector(context),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primaryContainer),
                          foregroundColor: WidgetStatePropertyAll(
                              Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)),
                      onPressed: () async {
                        Navigator.pop(context);
                        // create a note, and then open the edit note screen
                        _courseGrade.grade = _selectedNumGrade;
                        _courseGrade.nonNumericalGrade = _selectedNonNumGrade;

                        context
                            .read<CourseGradeProvider>()
                            .editCourseGrade(_courseGrade);

                        context.read<TermGradeProvider>().updateState();

                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Grade set."),
                        ));
                      },
                      child: const Text(
                        "Set Grade",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text("Clear Grade"),
                  leading: const Icon(Icons.clear),
                  onTap: () {
                    // To-Do add modal confimation
                    context
                        .read<CourseGradeProvider>()
                        .clearCourseGrade(_courseGrade);

                    context.read<TermGradeProvider>().updateState();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Grade cleared."),
                      ));
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
