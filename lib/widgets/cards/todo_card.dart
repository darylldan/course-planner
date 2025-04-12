import 'package:iscompanion/models/Todo.dart';
import 'package:iscompanion/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatefulWidget {
  final Todo todo;

  const TodoCard({super.key, required this.todo});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late bool _isDone;
  late FocusNode _focusNode;
  late TextEditingController _taskCtrl;
  bool _isEditable = false;

  late String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.todo.task;
    _isDone = widget.todo.isDone;
    _taskCtrl = TextEditingController(text: _text);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isEditable = _focusNode.hasFocus;
      if (!_isEditable) {
        _text = _taskCtrl.text;

        // save todo here
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _taskCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Swipe to the left to delete To-Do.")));
      },
      child: Dismissible(
        key: ValueKey<int>(widget.todo.id!),
        background: Container(
          padding: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.errorContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Delete",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onErrorContainer),
              )
            ],
          ),
        ),
        onDismissed: (direction) {
          context.read<TodoProvider>().deleteTodo(widget.todo.id!);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("To-Do deleted.")));
        },
        direction: DismissDirection.endToStart,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.onInverseSurface),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _checkBox(context),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_taskLabel(context)],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskLabel(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isEditable) {
          _focusNode.requestFocus();
        }
      },
      child: AbsorbPointer(
        absorbing: !_isEditable,
        child: TextField(
          focusNode: _focusNode,
          controller: _taskCtrl,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              overflow: TextOverflow.ellipsis),
          decoration: InputDecoration(
            border: InputBorder.none, // Remove underline if needed
            isDense: true,
          ),
          maxLines: null,
          onEditingComplete: () {
            final updatedTodo = Todo()
              ..id = widget.todo.id
              ..courseId = widget.todo.courseId
              ..termId = widget.todo.termId
              ..task = _taskCtrl.text
              ..isDone = _isDone;

            context.read<TodoProvider>().editTodo(updatedTodo);
          },
          readOnly: !_isEditable, // Toggle read-only based on focus
        ),
      ),
    );
  }

  Widget _checkBox(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Checkbox(
          value: _isDone,
          visualDensity: VisualDensity.comfortable,
          onChanged: (val) {
            setState(() {
              _isDone = !_isDone;

              final updatedTodo = Todo()
                ..id = widget.todo.id
                ..courseId = widget.todo.courseId
                ..termId = widget.todo.termId
                ..task = _taskCtrl.text
                ..isDone = _isDone;
              context.read<TodoProvider>().editTodo(updatedTodo);
            });
          },
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
