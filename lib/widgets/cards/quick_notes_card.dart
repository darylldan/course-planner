import 'package:course_planner/screens/misc/edit_quick_notes.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart' as C;

class QuickNotesCard extends StatefulWidget {
  String? notes;
  final int id;
  final String type;
  final String name;

  QuickNotesCard(
      {super.key, required this.notes, required this.id, required this.type, required this.name});

  @override
  State<QuickNotesCard> createState() => _QuickNotesCardState();
}

class _QuickNotesCardState extends State<QuickNotesCard> {
  void onNotesChanged(String? newNotes) {
    setState(() {
      widget.notes = newNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditQuickNotes(
                        notes: widget.notes,
                        onNotesChanged: onNotesChanged,
                        id: widget.id,
                        type: widget.type, name: widget.name,)));
          },
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          child: _notes(context),
        ),
      ),
    );
  }

  Widget _notes(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
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
                      Icons.format_list_bulleted_rounded,
                      size: C.cardIconSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    "Notes",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: C.titleCardHeaderFontSize),
                  ),
                ],
              ),
              Text(
                "Tap to Edit",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _notesContainer(context)
        ],
      ),
    );
  }

  Widget _notesContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: C.titleCardPaddingV, horizontal: C.titleCardPaddingV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(C.cardBorderRadius),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              (widget.notes == null || widget.notes!.isEmpty)
                  ? "No notes."
                  : widget.notes!,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onInverseSurface),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
