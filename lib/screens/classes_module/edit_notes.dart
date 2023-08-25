import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../utils/constants.dart' as C;

/*
 * Custom note editor that takes up the whole screen, like the Notes app from iOS
 */

class EditNotes extends StatefulWidget {
  final Subject subject;
  const EditNotes({super.key, required this.subject});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  final _screenTitle = "Edit Notes";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesCtrl.text = widget.subject.notes ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<SubjectProvider>()
                  .editSubject(widget.subject..notes = _notesCtrl.text);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Notes successfully saved."),
                ));
              }
            },
            icon: const Icon(Icons.save_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
            child: _buildNotesEditor(context, size),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesEditor(BuildContext context, Size size) {
    return Container(
      height: size.height,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: _screenTitle),
          Expanded(
            child: Column(
              children: [_buildForm(context)],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      onWillPop: () async {
        if (_notesCtrl.text == (widget.subject.notes ?? "")) {
          return true;
        }

        return _onWillPop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            maxLines: null,
            autofocus: true,
            controller: _notesCtrl,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration.collapsed(
                hintText: "Enter notes here..."),
            style: TextStyle(fontSize: 16),
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
