import 'package:iscompanion/models/Room.dart';
import 'package:iscompanion/providers/room_provider.dart';
import 'package:iscompanion/screens/buildings_module/add_room.dart';
import 'package:iscompanion/widgets/cards/error_card_no_action.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/cards/room_card.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  final TextEditingController _roomSearchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TitleText(title: "All Rooms"), _buildRooms(context)],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRoom()),
          );
        },
        label: const Text("Create Room"),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildRooms(BuildContext context) {
    List<Room> rooms = context.watch<RoomProvider>().rooms;
    ();
    List<Room> filteredRooms = rooms;

    if (rooms.isEmpty) {
      return InfoCard(
          content: "No rooms yet. Create one by pressing the button below.");
    }

    if (_roomSearchCtrl.text.isNotEmpty) {
      filteredRooms = filteredRooms
          .where((r) => r.roomName
              .toLowerCase()
              .contains(_roomSearchCtrl.text.toLowerCase()))
          .toList();
    }

    List<Padding> roomCards = filteredRooms
        .where((r) => r.buildingId != -1)
        .map((r) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: RoomCard(room: r),
            ))
        .toList();

    List<Padding> unassignedRoomCards = filteredRooms
        .where((r) => r.buildingId == -1)
        .map((r) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: RoomCard(room: r),
            ))
        .toList();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: _roomSearchCtrl,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                ),
                onChanged: (String val) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (_roomSearchCtrl.text.isNotEmpty)
              IconButton(
                  onPressed: () => setState(() {
                        _roomSearchCtrl.clear();
                      }),
                  icon: Icon(Icons.clear))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              if (_roomSearchCtrl.text.isNotEmpty && filteredRooms.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ErrorCardNoAction(
                      title: "SEARCH RESULTS", content: "No room found."),
                ),
              if (_roomSearchCtrl.text.isEmpty &&
                  unassignedRoomCards.isNotEmpty)
                Row(
                  children: [
                    const Expanded(
                      child: Opacity(
                        opacity: 0.5,
                        child: Divider(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "UNASSIGNED ROOMS",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onInverseSurface),
                      ),
                    ),
                    const Expanded(
                      child: Opacity(
                        opacity: 0.5,
                        child: Divider(),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (unassignedRoomCards.isEmpty && _roomSearchCtrl.text.isEmpty)
          InfoCard(content: "No unassigned rooms.")
        else
          ...unassignedRoomCards,
        if (_roomSearchCtrl.text.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Opacity(
                        opacity: 0.5,
                        child: Divider(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "ROOMS",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onInverseSurface),
                      ),
                    ),
                    const Expanded(
                      child: Opacity(
                        opacity: 0.5,
                        child: Divider(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ...roomCards,
        Center(
          child: Text(
            "${filteredRooms.length} ${filteredRooms.length == 1 ? "Room" : "Rooms"}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onInverseSurface),
          ),
        ),
        SizedBox(
          height: 150,
        )
      ],
    );
  }
}
