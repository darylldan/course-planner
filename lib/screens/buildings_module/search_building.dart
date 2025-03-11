import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/providers/building_provider.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:course_planner/widgets/cards/building_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart' as C;

enum ResultFilter { building, room, all }

class SearchBuilding extends StatefulWidget {
  const SearchBuilding({super.key});

  @override
  State<SearchBuilding> createState() => _SearchBuildingState();
}

class _SearchBuildingState extends State<SearchBuilding> {
  final _searchValue = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late List<Building> _buildings;
  late List<Room> _rooms;

  late bool _unassignedFlag;
  late ResultFilter _resultFilter;

  @override
  void initState() {
    super.initState();

    _unassignedFlag = false;
    _resultFilter = ResultFilter.all;
    _buildings = [];
    _rooms = [];
  }

  @override
  Widget build(BuildContext context) {
    _rooms = context.read<RoomProvider>().rooms;
    _buildings = context.read<BuildingProvider>().building;

    // No rooms or buildings
    if ((_rooms.isEmpty && _buildings.isEmpty) && _isFilterActive()) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                  content:
                      "Begin by adding a room or a building on the Buildings and Rooms page.")
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _searchBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildResults(context),
        ),
      ),
    );
  }

  AppBar _searchBar() {
    return AppBar(
      title: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                _searchValue.clear();
              },
              icon: const Icon(Icons.clear_rounded),
            ),
          ),
          controller: _searchValue,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      actions: [
        _isFilterActive()
            ? Badge(
                child: IconButton(
                  onPressed: () {
                    _showFilterPanel();
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                ),
              )
            : IconButton(
                onPressed: () {
                  _showFilterPanel();
                },
                icon: const Icon(Icons.filter_alt_rounded)),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    if (_searchValue.text.trim().isEmpty && !_isFilterActive()) {
      return Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InfoCard(
              content:
                  "Start by typing the building or room name above. Click the filter button to enhance your search.")
        ],
      );
    }

    List<Room> roomResults = _rooms.where((r) {
      return r.roomName
          .toLowerCase()
          .contains(_searchValue.text.toLowerCase().trim());
    }).toList();

    List<Building> buildingResults = _buildings.where((b) {
      return b.buildingName
          .toLowerCase()
          .contains(_searchValue.text.toLowerCase().trim());
    }).toList();

    // List<Subject> results = _subjects.where(
    //   (s) {
    //     return s.termID == _currentTerm!.id! &&
    //         s.courseCode
    //             .toLowerCase()
    //             .contains(_searchValue.text.toLowerCase().trim());
    //   },
    // ).toList();

    if (_unassignedFlag) {
      roomResults = _rooms.where((r) => r.buildingId == -1).toList();
    }

    List<BuildingCard> buildingResultsCard =
        buildingResults.map((b) => BuildingCard(bldg: b)).toList();
    // List<RoomCard> roomResultsCard =
    //     roomResults.map((r) => RoomCard(room: r)).toList();

    // To-do: build the results with the resulttype filter
    if (true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _resultHeader(),
          ),
          // ...resultsCard,
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
          ),
          // Center(
          //   child: Text(
          //     "${resultsCard.length} ${resultsCard.length == 1 ? "Subject" : "Subjects"}",
          //     style: TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.bold,
          //         color: Theme.of(context).colorScheme.onInverseSurface),
          //   ),
          // ),
          const SizedBox(
            height: 120,
          )
        ],
      );
    }
  }

  Widget _resultHeader() {
    return Row(
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
            "SEARCH RESULT",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onInverseSurface,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
      ],
    );
  }

  void _showFilterPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: ((context, setModalState) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: SizedBox(
              height: 500,
              width: double.infinity,
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Filters",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setModalState(() {
                          _unassignedFlag = false;
                          _resultFilter = ResultFilter.all;
                        });
                      },
                      child: const Text(
                        "Clear",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
      },
    );
  }

  bool _isFilterActive() {
    return _unassignedFlag || _resultFilter != ResultFilter.all;
  }
}
