import 'package:course_planner/models/Building.dart';
import 'package:flutter/material.dart';

class BuildingInfoCard extends StatefulWidget {
  final Building bldg;
  const BuildingInfoCard({super.key, required this.bldg});

  @override
  State<BuildingInfoCard> createState() => _BuildingInfoCardState();
}

class _BuildingInfoCardState extends State<BuildingInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Text("test");
  }
}
