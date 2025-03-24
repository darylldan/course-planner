import 'dart:math';

import 'package:course_planner/screens/buildings_module/buildings.dart';
import 'package:course_planner/screens/classes_module/classes.dart';
import 'package:course_planner/screens/daily_schedule_module/daily_schedule.dart';
import 'package:course_planner/screens/misc/about.dart';
import 'package:course_planner/screens/notes_module.dart/note.dart';
import 'package:course_planner/screens/overview_module/overview.dart';
import 'package:course_planner/screens/terms_module/terms.dart';
import 'package:course_planner/screens/test_screen.dart';
import 'package:course_planner/screens/weekly_schedule_module/weekly_schedule.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart' as C;

/*
 * Overview
 * Daily Schedule
 * Weekly Schedule
 * Classes
 * Terms
 * Buildings and Rooms
 */

class SideDrawer extends StatefulWidget {
  String parent;
  SideDrawer({super.key, required this.parent});

  static var _currIndex = 0;

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final List<String> _foodEmojis = [
    "🧭",
    "🍔",
    "🍟",
    "🍕",
    "🌮",
    "🍣",
    "🍦",
    "🍪",
    "🥪",
    "🥞",
    "🍩",
    "🍫",
    "🍓",
    "🍎",
    "🍌",
    "🍇",
    "🥕",
    "🍆",
    "🌽",
    "🍊",
    "🍍",
    "🍒",
    "🍅",
    "🍉"
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 175,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onLongPress: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Padayon! 🌻")));
                          },
                          onPressed: () {
                            setState(() {
                              SideDrawer._currIndex =
                                  Random().nextInt(_foodEmojis.length);
                            });
                          },
                          child: Text(
                            _foodEmojis[SideDrawer._currIndex],
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ..._drawerButtons()
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ListTile> _drawerButtons() {
    return [
      ListTile(
        leading: const Icon(Icons.home_rounded),
        title: const Text(
          "Overview",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/overview", const Overview());
        },
      ),
      ListTile(
        leading: const Icon(Icons.view_day_rounded),
        title: const Text(
          "Daily Schedule",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/daily-schedule", const DailySchedule());
        },
      ),
      ListTile(
        leading: const Icon(Icons.view_week_rounded),
        title: const Text(
          "Weekly Schedule",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/weekly-schedule", const WeeklySchedule());
        },
      ),
      ListTile(
        leading: Icon(Icons.book_rounded),
        title: const Text(
          "Classes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/classes", const Classes());
        },
      ),
      ListTile(
        leading: Icon(Icons.calendar_today_rounded),
        title: const Text(
          "Terms",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/terms", const Terms());
        },
      ),
      ListTile(
        leading: Icon(Icons.meeting_room_rounded),
        title: const Text(
          "Buildings and Rooms",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/buildings", const Buildings());
        },
      ),
      ListTile(
        leading: Icon(Icons.meeting_room_rounded),
        title: const Text(
          "Notes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/notes", const Notes());
        },
      ),
      ListTile(
        leading: Icon(Icons.flag),
        title: const Text(
          "Testing Screen",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/test-screen", const TestScreen());
        },
      ),
      ListTile(
        leading: Icon(Icons.info_rounded),
        title: const Text(
          "About",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          _navigateTo(context, "/about", About());
        },
      ),
    ];
  }

  void _navigateTo(BuildContext context, String route, Widget screen) {
    Navigator.pop(context);

    if (widget.parent == route) {
      return;
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }
}
