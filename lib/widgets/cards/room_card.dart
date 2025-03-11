import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/building_provider.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/buildings_module/edit_room.dart';
import 'package:course_planner/screens/buildings_module/view_room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class RoomCard extends StatefulWidget {
  final Room room;
  final bool pickMode;
  final bool disableAction;

  const RoomCard(
      {super.key,
      required this.room,
      this.pickMode = false,
      this.disableAction = false});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  Widget build(BuildContext context) {
    Building? bldg;
    if (widget.room.buildingId != -1) {
      bldg = context
          .read<BuildingProvider>()
          .getBuildingByID(widget.room.buildingId);
    }
    return Material(
      borderRadius: BorderRadius.circular(C.cardBorderRadius),
      clipBehavior: Clip.hardEdge,
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.onInverseSurface),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: widget.pickMode
              ? () {
                  Navigator.pop(context, widget.room);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Selected ${widget.room.roomName}")));
                }
              : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewRoom(room: widget.room)));
                },
          onLongPress:
              widget.disableAction ? null : () => _showActions(context, bldg),
          child: _roomCardContainer(context, bldg),
        ),
      ),
    );
  }

  Widget _roomCardContainer(BuildContext context, Building? bldg) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                  width: 4,
                  height: 50,
                ),
                const SizedBox(width: 8), // Add some spacing
                // Column with text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.room.roomName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow
                            .ellipsis, // Add this to prevent overflow
                        maxLines: 1, // Ensure it fits within one line
                      ),
                      Row(
                        children: [
                          _subjectCount(context),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              bldg?.buildingName ?? "Unassigned",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showActions(context, bldg),
                  icon: Icon(Icons.more_vert),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectCount(BuildContext context) {
    Term? currentTerm = context.watch<TermProvider>().currentTerm;
    List<Subject> subjects =
        context.read<SubjectProvider>().getSubjectsByRoom(widget.room.id!, currentTerm!.id!);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
      child: Text(
        subjects.isEmpty ? "NO SUBJECTS" : "${subjects.length} SUBJECTS",
        style: TextStyle(
            color: Theme.of(context).colorScheme.onInverseSurface,
            fontSize: 11,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showActions(BuildContext context, Building? bldg) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
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
                  title: const Text("Edit Room"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditRoom(
                                  room: widget.room,
                                  bldg: bldg,
                                )));
                  },
                ),
                ListTile(
                  title: const Text("Delete Room"),
                  leading: const Icon(Icons.delete_forever_rounded),
                  onTap: () {
                    context.read<RoomProvider>().deleteRoom(widget.room.id!);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Room deleted."),
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
