import 'package:iscompanion/models/Subject.dart';
import 'package:iscompanion/models/Term.dart';
import 'package:iscompanion/models/Todo.dart';
import 'package:iscompanion/providers/term_provider.dart';
import 'package:iscompanion/providers/todo_provider.dart';
import 'package:iscompanion/screens/misc/course_picker.dart';
import 'package:iscompanion/screens/todo_module/view_done_todos.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/cards/todo_card.dart';
import 'package:iscompanion/widgets/cards/unassigned_card.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class ViewCourseTodo extends StatefulWidget {
  final Subject? course;
  final Term? term;

  const ViewCourseTodo({super.key, this.course, this.term});

  @override
  State<ViewCourseTodo> createState() => _ViewCourseTodoState();
}

class _ViewCourseTodoState extends State<ViewCourseTodo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _todoCtrl = TextEditingController();
  Subject? _selectedCourse;

  @override
  void initState() {
    super.initState();
    _selectedCourse = widget.course;
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
                title: widget.course == null
                    ? "View Unassigned To-Do"
                    : "View To-Do"),
            if (widget.course != null) ...[
              _classTitleDesc(context),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
            ],
            _body(context),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showTodoCreator(context),
          label: Row(
            children: [Icon(Icons.add), Text("Create To-Do")],
          )),
    );
  }

  Widget _body(BuildContext context) {
    List<Todo> todos = widget.course == null
        ? context
            .watch<TodoProvider>()
            .getAllUncompletedUnassignedTodo(widget.term!.id!)
        : context.watch<TodoProvider>().getAllUncompletedTodoByCourse(
            widget.course!.termID, widget.course!.id!);

    return Column(
      children: [
        UnassignedCard(
          count: widget.course == null
              ? context
                  .watch<TodoProvider>()
                  .getAllUnassignedCompletedTodo(widget.term!.id!)
                  .length
              : context
                  .watch<TodoProvider>()
                  .getAllCompletedTodoByCourse(
                      widget.course!.termID, widget.course!.id!)
                  .length,
          onTap: () {
            if (widget.course != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewDoneTodos(
                            course: widget.course,
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewDoneTodos(
                            term: widget.term!,
                          )));
            }
          },
          title: "Done",
        ),
        SizedBox(
          height: 10,
        ),
        if (todos.isEmpty)
          InfoCard(content: "No to-dos yet. Create one below.")
        else ...[
          ...todos.map((t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: TodoCard(todo: t),
              )),
          Center(
            child: Text(
              "${todos.length} ${todos.length == 1 ? "To-Do" : "To-Dos"}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onInverseSurface),
            ),
          ),
        ]
      ],
    );
  }

  Widget _classTitleDesc(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.book_rounded,
                      size: C.cardIconSize,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    "Class",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: C.titleCardHeaderFontSize),
                  ),
                ],
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(
                      widget.course!.color[0],
                      widget.course!.color[1],
                      widget.course!.color[2],
                      widget.course!.color[3],
                    )),
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "${widget.course!.courseCode} - ${widget.course!.isLaboratory ? "Laboratory" : "Lecture"}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: C.titleCardContentFontSize,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          if (!(widget.course!.description == null ||
              widget.course!.description == ""))
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.course!.description ?? "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            )
        ],
      ),
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
                              builder: (context) => CoursePicker(
                                  term: widget.term != null
                                      ? widget.term!
                                      : context
                                          .read<TermProvider>()
                                          .getTermByID(widget.course!.id!))));

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
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 400,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: C.screenHorizontalPadding, vertical: 24),
                child: Column(
                  children: [
                    const Text(
                      "Create To-Do",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
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
                                Theme.of(context).colorScheme.primaryContainer),
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
                              ..termId = widget.course != null
                                  ? widget.course!.termID
                                  : widget.term!.id!
                              ..task = _todoCtrl.text;

                            context.read<TodoProvider>().addTodo(newTodo);

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("To-do created.")));

                            setModalState(() {
                              _todoCtrl.clear();
                              _selectedCourse = widget.course;
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
            );
          });
        });
  }
}
