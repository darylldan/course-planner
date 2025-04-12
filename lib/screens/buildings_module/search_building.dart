import 'package:iscompanion/models/Building.dart';
import 'package:iscompanion/models/Room.dart';
import 'package:iscompanion/models/Subject.dart';
import 'package:iscompanion/models/Term.dart';
import 'package:iscompanion/providers/building_provider.dart';
import 'package:iscompanion/providers/room_provider.dart';
import 'package:iscompanion/providers/subject_provider.dart';
import 'package:iscompanion/providers/term_provider.dart';
import 'package:iscompanion/widgets/cards/building_card.dart';
import 'package:iscompanion/widgets/cards/error_card_no_action.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/cards/room_card.dart';
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

  @override
  void initState() {
    super.initState();
    _buildings = [];
    _rooms = [];
  }

  @override
  Widget build(BuildContext context) {
    _rooms = context.read<RoomProvider>().rooms;
    _buildings = context.read<BuildingProvider>().building;

    // No rooms or buildings
    if ((_rooms.isEmpty && _buildings.isEmpty)) {
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

    Term? currentTerm = context.read<TermProvider>().currentTerm;
    List<Subject> courses = [];

    if (currentTerm != null) {
      courses = context
          .read<SubjectProvider>()
          .getSubjectsByTerm(currentTerm.id!)
          .where((c) => c.courseCode
              .toLowerCase()
              .contains(_searchValue.text.toLowerCase()))
          .toList();
    }

    List<Room> roomResults = _rooms.where((r) {
      return r.roomName
              .toLowerCase()
              .contains(_searchValue.text.toLowerCase().trim()) ||
          courses
              .where((c) => c.locationType == "room")
              .toList()
              .any((s) => s.locationID == r.id);
    }).toList();

    List<Building> buildingResults = _buildings.where((b) {
      return b.buildingName
              .toLowerCase()
              .contains(_searchValue.text.toLowerCase().trim()) ||
          courses
              .where((c) => c.locationType == "building")
              .toList()
              .any((s) => s.locationID == b.id) ||
          roomResults.any((r) => r.buildingId == b.id);
    }).toList();

    List<Padding> buildingResultsCard = buildingResults
        .map((b) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: BuildingCard(bldg: b),
            ))
        .toList();
    List<Padding> roomResultsCard = roomResults
        .map((r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RoomCard(room: r),
            ))
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _searchBar(),
        body: _searchValue.text.trim().isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: C.screenHorizontalPadding),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InfoCard(
                        content:
                            "Start by typing the building name, room name, or course code above.")
                  ],
                ),
              )
            : TabBarView(
                children: [
                  _buildResultCards(context, buildingResultsCard),
                  _buildResultCards(context, roomResultsCard)
                ],
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
                setState(() {
                  _searchValue.clear();
                });
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
      bottom: _searchValue.text.trim().isEmpty
          ? null
          : TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  text: "Buildings",
                  icon: Icon(Icons.business),
                ),
                Tab(
                  text: "Rooms",
                  icon: Icon(Icons.meeting_room),
                )
              ],
            ),
    );
  }

  Widget _buildResultCards(BuildContext context, List<Widget> results) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
      child: results.isEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 10),
              child: ErrorCardNoAction(
                  title: "SEARCH RESULTS", content: "No results found."))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: _resultHeader(),
                ),
                ...results,
                Center(
                  child: Text(
                    "${results.length} ${results.length == 1 ? "Result" : "Results"}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onInverseSurface),
                  ),
                ),
                const SizedBox(
                  height: 120,
                )
              ],
            ),
    );
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
}
