import 'dart:math';

import 'package:course_planner/screens/classes_module/classes.dart';
import 'package:course_planner/screens/daily_schedule_module/daily_schedule.dart';
import 'package:course_planner/screens/terms_module/terms.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart' as C;

/*
 * Overview
 * Daily Schedule
 * Weekly Schedule
 * Classes
 * Terms
 * 
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          SafeArea(
            child: ListTile(
              leading: Icon(Icons.info_rounded),
              title: const Text(
                "About",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onTap: () {
                // _navigateTo(context, "/about");
              },
            ),
          ),
        ],
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
          // _navigateTo(context, "/overview");
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
          // _navigateTo(context, "/weekly-schedule");
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
      )
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
