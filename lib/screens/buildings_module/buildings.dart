import 'package:iskotrack/models/Building.dart';
import 'package:iskotrack/providers/building_provider.dart';
import 'package:iskotrack/providers/room_provider.dart';
import 'package:iskotrack/screens/buildings_module/add_building.dart';
import 'package:iskotrack/screens/buildings_module/rooms.dart';
import 'package:iskotrack/screens/buildings_module/search_building.dart';
import 'package:iskotrack/widgets/cards/building_card.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/elements/drawer.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class Buildings extends StatefulWidget {
  const Buildings({super.key});

  @override
  State<Buildings> createState() => _BuildingsState();
}

class _BuildingsState extends State<Buildings> {
  final _screenTitle = "Buildings";
  final _route = "/buildings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchBuilding()),
              );
            },
            icon: Icon(Icons.search_rounded),
          )
        ],
      ),
      drawer: SideDrawer(parent: _route),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: _screenTitle),
              _roomsButton(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
              _buildBuildings(context)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBuilding()),
          );
        },
        label: const Text("Create Building"),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildBuildings(BuildContext context) {
    List<Building> buildings = context.watch<BuildingProvider>().building
      ..sort((a, b) =>
          a.buildingName.toLowerCase().compareTo(b.buildingName.toLowerCase()));

    if (buildings.isEmpty) {
      return _emptyBuilding(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildings.map<Padding>((b) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: BuildingCard(bldg: b),
        );
      }).toList()
        ..add(Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
              Center(
                child: Text(
                  "${buildings.length} ${buildings.length == 1 ? "Building" : "Buildings"}",
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
        )),
    );
  }

  Widget _roomsButton() {
    int roomCount = context.watch<RoomProvider>().rooms.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.onInverseSurface)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Rooms()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View All Rooms",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: Text(
                              roomCount.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    )))
          ],
        ),
      ],
    );
  }

  Widget _emptyBuilding(BuildContext context) {
    return InfoCard(
        content:
            "Begin adding buildings by cliking the 'Create Building' button below.");
  }
}
