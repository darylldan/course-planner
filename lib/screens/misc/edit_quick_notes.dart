import 'dart:async';

import 'package:iscompanion/models/Building.dart';
import 'package:iscompanion/models/Room.dart';
import 'package:iscompanion/providers/building_provider.dart';
import 'package:iscompanion/providers/room_provider.dart';
import 'package:iscompanion/providers/subject_provider.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../utils/constants.dart' as C;

/*
 * Custom note editor that takes up the whole screen, like the Notes app from iOS
 */

class EditQuickNotes extends StatefulWidget {
  final String? notes;
  final int id;
  final String type;
  final String name;
  final ValueChanged<String?> onNotesChanged;

  const EditQuickNotes(
      {super.key,
      required this.notes,
      required this.onNotesChanged,
      required this.id,
      required this.name,
      required this.type});

  @override
  State<EditQuickNotes> createState() => _EditQuickNotesState();
}

class _EditQuickNotesState extends State<EditQuickNotes> {
  final _screenTitle = "Edit Notes";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesCtrl = TextEditingController();

  Timer? _saveTimer;

  void _setNotes(BuildContext context) {
    _saveTimer?.cancel();

    _saveTimer = Timer(const Duration(seconds: 2), () {
      widget.onNotesChanged(_notesCtrl.text);
      _saveNotes(context);
    });
  }

  void _saveNotes(BuildContext context) {
    if (widget.type == "building") {
      Building bldg =
          context.read<BuildingProvider>().getBuildingByID(widget.id);
      bldg.notes = _notesCtrl.text;

      context.read<BuildingProvider>().editBuilding(bldg);

      return;
    }

    if (widget.type == "subject") {
      Subject subj = context.read<SubjectProvider>().getSubjectByID(widget.id);
      subj.notes = _notesCtrl.text;

      context.read<SubjectProvider>().editSubject(subj);

      return;
    }

    if (widget.type == "room") {
      Room room = context.read<RoomProvider>().getRoomByID(widget.id);
      room.notes = _notesCtrl.text;

      context.read<RoomProvider>().editRoom(room);

      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _notesCtrl.text = widget.notes ?? "";
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.name,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildNotesEditor(context),
        ),
      ),
    );
  }

  Widget _buildNotesEditor(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: _screenTitle),
          Column(
            children: [_buildForm(context)],
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        widget.onNotesChanged(_notesCtrl.text); // Save before exiting
        _saveNotes(context);

        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Form(
        key: _formKey,
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
              onChanged: (String val) => _setNotes(context),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
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
