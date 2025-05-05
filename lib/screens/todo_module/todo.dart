import 'package:iskotrack/models/Subject.dart';
import 'package:iskotrack/models/Term.dart';
import 'package:iskotrack/models/Todo.dart';
import 'package:iskotrack/providers/subject_provider.dart';
import 'package:iskotrack/providers/term_provider.dart';
import 'package:iskotrack/providers/todo_provider.dart';
import 'package:iskotrack/screens/misc/course_picker.dart';
import 'package:iskotrack/screens/todo_module/view_course_todo.dart';
import 'package:iskotrack/widgets/cards/current_term_selected.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/cards/todo_course_card.dart';
import 'package:iskotrack/widgets/cards/unassigned_card.dart';
import 'package:iskotrack/widgets/elements/drawer.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  Term? _termSelectorValue;
  Term? _currentTerm;
  bool _onCurrentTerm = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _todoCtrl = TextEditingController();
  Subject? _selectedCourse;

  @override
  Widget build(BuildContext context) {
    Term? currentTerm = context.watch<TermProvider>().currentTerm;
    _currentTerm ??= currentTerm;
    return Scaffold(
      appBar: AppBar(),
      drawer: SideDrawer(parent: '/todo'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "To-Do"),
            _body(context, currentTerm),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
      floatingActionButton: currentTerm != null
          ? FloatingActionButton.extended(
              onPressed: () => _showTodoCreator(context),
              label: Row(
                children: [Icon(Icons.add), Text("Create To-Do")],
              ))
          : null,
    );
  }

  Widget _body(BuildContext context, currentTerm) {
    if (currentTerm == null) {
      return InfoCard(
          content:
              "There are no terms yet. Create one via the terms screen. The to-dos that you've created will appear here.");
    }

    if (_onCurrentTerm == true) {
      _currentTerm = currentTerm;
    }

    List<Subject> courses =
        context.watch<SubjectProvider>().getSubjectsByTerm(_currentTerm!.id!);

    return Column(
      children: [
        _buildCurrentTerm(context),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        if (courses.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InfoCard(
                content:
                    "No courses yet. Create one via the Courses screen to create course-specific to-dos."),
          ),
          SizedBox(
            height: 8,
          )
        ],
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: UnassignedCard(
            count: context
                .watch<TodoProvider>()
                .getAllUncompletedUnassignedTodo(_currentTerm!.id!)
                .length,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewCourseTodo(
                            term: _currentTerm!,
                          )));
            },
          ),
        ),
        if (courses.isNotEmpty) _courses(context, courses)
      ],
    );
  }

  Widget _courses(BuildContext context, List<Subject> courses) {
    return Column(
      children: [
        ...courses.map((c) => TodoCourseCard(subject: c)),
        Center(
          child: Text(
            "${courses.length} ${courses.length == 1 ? "Course" : "Courses"}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onInverseSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTerm(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () {
            _showTermChanger(context);
          },
          child: CurrentTermSelectedCard(
            term: _currentTerm!,
            editMode: false,
            onCurrentTerm: _currentTerm!.isCurrentTerm,
          ),
        ),
      ),
    );
  }

  void _showTermChanger(BuildContext context) {
    _termSelectorValue = _currentTerm;
    List<Term> terms = context.read<TermProvider>().terms;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Select Term",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _termSelector(context, terms),
                const SizedBox(
                  height: 15,
                ),
                InfoCard(
                  content:
                      "To change the current term, go to the Terms screen.",
                  fontSize: 14,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _termSelector(BuildContext context, List<Term> terms) {
    List<DropdownMenuEntry<int>> entries = [];

    for (var t in terms) {
      // Needed because the new dropdown menu does not catch text overflows
      String label = "${t.semester}, ${t.academicYear}";

      if (label.length > 36) {
        label = "${label.substring(0, 37)}...";
      }
      entries.add(
        DropdownMenuEntry(
          value: t.id!,
          label: label,
          trailingIcon: t.isCurrentTerm ? Icon(Icons.star_rounded) : null,
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: 343,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownMenu<int>(
              width: 343,
              initialSelection: _currentTerm!.id,
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              label: const Text("Terms"),
              dropdownMenuEntries: entries,
              onSelected: (int? termID) {
                _termSelectorValue =
                    context.read<TermProvider>().getTermByID(termID!);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer),
                foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentTerm = _termSelectorValue;
                _onCurrentTerm = _termSelectorValue!.isCurrentTerm;
              });
            },
            child: const Text(
              "View Term's Classes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _coursePicker(BuildContext context, StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Course"),
            Row(
              children: [
                if (_selectedCourse != null)
                  IconButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedCourse = null;
                        });
                      },
                      icon: Icon(Icons.cancel)),
                TextButton(
                    onPressed: () async {
                      var course = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CoursePicker(term: _currentTerm!)));

                      if (course != null) {
                        setModalState(() {
                          _selectedCourse = course;
                        });
                      }
                    },
                    child: Text(
                      _selectedCourse == null
                          ? "Unassigned"
                          : "${_selectedCourse!.courseCode} ${_selectedCourse!.isLaboratory ? "Lab" : "Lec"}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        )
      ],
    );
  }

  void _showTodoCreator(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                height: 500,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: C.screenHorizontalPadding, vertical: 24),
                    child: Column(
                      children: [
                        const Text(
                          "Create To-Do",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _todoCtrl,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                hintText: 'Enter task',
                                labelText: 'Task'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a task.";
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Opacity(
                          opacity: 0.5,
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _coursePicker(context, setModalState),
                        ),
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
                              // create a note, and then open the edit note screen
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                Todo newTodo = Todo()
                                  ..courseId = _selectedCourse == null
                                      ? -1
                                      : _selectedCourse!.id!
                                  ..isDone = false
                                  ..termId = _currentTerm!.id!
                                  ..task = _todoCtrl.text;

                                context.read<TodoProvider>().addTodo(newTodo);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("To-do created.")));

                                setModalState(() {
                                  _todoCtrl.clear();
                                  _selectedCourse = null;
                                });

                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              "Create To-Do",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
