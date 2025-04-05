import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Todo.dart';
import 'package:course_planner/providers/todo_provider.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/todo_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

import '../../models/Term.dart';

class ViewDoneTodos extends StatefulWidget {
  final Subject? course;
  final Term? term;

  const ViewDoneTodos({super.key, this.course, this.term});

  @override
  State<ViewDoneTodos> createState() => _ViewDoneTodos();
}

class _ViewDoneTodos extends State<ViewDoneTodos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TitleText(title: "Done To-Dos"), _body(context)],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    List<Todo> todos = widget.course == null
        ? context
            .watch<TodoProvider>()
            .getAllCompletedUnassignedTodo(widget.term!.id!)
        : context.watch<TodoProvider>().getAllCompletedTodoByCourse(
            widget.course!.termID, widget.course!.id!);

    return Column(
      children: [
        if (todos.isEmpty)
          InfoCard(content: "No to-dos done yet. You can do it!")
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
}
