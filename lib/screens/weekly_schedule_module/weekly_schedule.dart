import 'package:flutter/material.dart';

import '../../models/Term.dart';

class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({super.key});

  @override
  State<WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  final _screenTitle = "Weekly Schedule";
  final _route = "/weekly-schedule";
  late Term? currentTerm;
  late Term? _termSelectorValue;
  bool onCurrentTerm = true;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}