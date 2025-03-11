import 'package:course_planner/models/Building.dart';
import 'package:course_planner/providers/building_provider.dart';
import 'package:course_planner/widgets/cards/building_card.dart';
import 'package:course_planner/widgets/cards/error_card_no_action.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class SelectBuilding extends StatefulWidget {
  const SelectBuilding({super.key});

  @override
  State<SelectBuilding> createState() => _SelectBuildingState();
}

class _SelectBuildingState extends State<SelectBuilding> {
  TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Building> buildings = context.read<BuildingProvider>().building;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Select Building"),
            buildings.isEmpty
                ? InfoCard(
                    content:
                        "There are currently no buildings. Add via the Buildings and Rooms screen.")
                : _buildScreen(context, buildings)
          ],
        ),
      ),
    );
  }

  Widget _buildScreen(BuildContext context, List<Building> buildings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard(
            content:
                "If no location is set for room, it will inherit the location of the building."),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                ),
                onChanged: (String val) {
                  setState(() {});
                },
              ),
            ),
            if (_searchCtrl.text.isNotEmpty)
              IconButton(
                  onPressed: () => setState(() {
                        _searchCtrl.clear();
                      }),
                  icon: Icon(Icons.clear))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        _buildSelection(context, buildings)
      ],
    );
  }

  Widget _buildSelection(BuildContext context, List<Building> buildings) {
    if (_searchCtrl.text != "") {
      buildings = buildings
          .where((b) => b.buildingName
              .toLowerCase()
              .contains(_searchCtrl.text.toLowerCase()))
          .toList();
    }

    if (buildings.isEmpty && _searchCtrl.text.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ErrorCardNoAction(
            title: "SEARCH RESULTS", content: "No buildings found."),
      );
    }

    return Column(
      children: buildings
          .map((b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: BuildingCard(
                  bldg: b,
                  disableAction: true,
                  pickMode: true,
                ),
              ))
          .toList(),
    );
  }
}
