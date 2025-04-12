import 'package:iskotrack/models/Building.dart';
import 'package:iskotrack/models/Room.dart';
import 'package:iskotrack/providers/building_provider.dart';
import 'package:iskotrack/providers/room_provider.dart';
import 'package:iskotrack/widgets/cards/building_card.dart';
import 'package:iskotrack/widgets/cards/error_card_no_action.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/cards/room_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class SelectBuildingRoom extends StatefulWidget {
  const SelectBuildingRoom({super.key});

  @override
  State<SelectBuildingRoom> createState() => _SelectBuildingRoomState();
}

class _SelectBuildingRoomState extends State<SelectBuildingRoom> {
  final TextEditingController _roomCtrl = TextEditingController();
  final TextEditingController _bldgCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select Class Location"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.meeting_room),
                text: "Room",
              ),
              Tab(
                icon: Icon(Icons.business),
                text: "Building",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildRooms(context), _buildBuildings(context)],
        ),
      ),
    );
  }

  Widget _buildRooms(BuildContext context) {
    List<Room> rooms = context.watch<RoomProvider>().rooms;
    List<Room> filteredRooms = rooms;

    if (rooms.isEmpty) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          children: [
            SizedBox(
              height: 18,
            ),
            InfoCard(
                content:
                    "No rooms found. Add one via buildings and rooms screen."),
          ],
        ),
      );
    }

    if (_roomCtrl.text.isNotEmpty) {
      filteredRooms = rooms
          .where((r) =>
              r.roomName.toLowerCase().contains(_roomCtrl.text.toLowerCase()))
          .toList();
    }

    List<Padding> roomCard = filteredRooms
        .map((r) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: RoomCard(
                room: r,
                pickMode: true,
                disableAction: true,
              ),
            ))
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _roomCtrl,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search',
                  ),
                  onChanged: (String val) {
                    setState(() {});
                  },
                ),
              ),
              if (_roomCtrl.text.isNotEmpty)
                IconButton(
                    onPressed: () => setState(() {
                          _roomCtrl.clear();
                        }),
                    icon: Icon(Icons.clear))
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if (filteredRooms.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ErrorCardNoAction(
                  title: "SEARCH RESULT", content: "No rooms found."),
            ),
          ...roomCard,
          SizedBox(
            height: 150,
          ),
        ],
      ),
    );
  }

  Widget _buildBuildings(BuildContext context) {
    List<Building> buildings = context.watch<BuildingProvider>().building;
    List<Building> filteredBldgs = buildings;

    if (buildings.isEmpty) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          children: [
            SizedBox(
              height: 18,
            ),
            InfoCard(
                content:
                    "No buildings found. Add one via buildings and rooms screen."),
          ],
        ),
      );
    }

    if (_bldgCtrl.text.isNotEmpty) {
      filteredBldgs = buildings
          .where((r) => r.buildingName
              .toLowerCase()
              .contains(_bldgCtrl.text.toLowerCase()))
          .toList();
    }

    List<Padding> bldgCard = filteredBldgs
        .map((b) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: BuildingCard(
                bldg: b,
                pickMode: true,
                disableAction: true,
              ),
            ))
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _bldgCtrl,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search',
                  ),
                  onChanged: (String val) {
                    setState(() {});
                  },
                ),
              ),
              if (_bldgCtrl.text.isNotEmpty)
                IconButton(
                    onPressed: () => setState(() {
                          _bldgCtrl.clear();
                        }),
                    icon: Icon(Icons.clear))
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if (filteredBldgs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ErrorCardNoAction(
                  title: "SEARCH RESULT", content: "No rooms found."),
            ),
          ...bldgCard
        ],
      ),
    );
  }
}
