import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/screens/buildings_module/location_picker.dart';
import 'package:course_planner/screens/buildings_module/select_building_room.dart';
import 'package:course_planner/widgets/cards/building_card.dart';
import 'package:course_planner/widgets/cards/quick_notes_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart' as C;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final key = GlobalKey<AnimatedListState>();
  late int nextIndex;
  int counter = 1;

  TimeOfDay? selectedTime;

  List<Color?> colors = [
    Colors.red.shade600,
    Colors.pink.shade600,
    Colors.purple.shade600,
    Colors.deepPurple.shade600,
    Colors.indigo.shade600,
    Colors.blue.shade600,
    Colors.lightBlue.shade600,
    Colors.cyan.shade600,
    Colors.teal.shade600,
    Colors.green.shade600,
    Colors.lightGreen.shade600,
    Colors.lime.shade600,
    Colors.yellow.shade600,
    Colors.amber.shade600,
    Colors.orange.shade600,
    Colors.deepOrange.shade600,
    Colors.brown.shade600,
    Colors.grey.shade600,
    Colors.blueGrey.shade600,
    Colors.black87,
  ];

  Color? selectedColor;

  double lat = 14.165066352080837;
  double long = 121.24156452547093;
  Building _bldg = Building()
    ..id = 1
    ..buildingName = "Physical Sciences"
    ..notes = "testing the notes"
    ..latitude = C.obleLat
    ..longitude = C.obleLong;

  Room _room = Room()
    ..id = 1
    ..buildingId = 1
    ..roomName = "ICS PC Lab 7"
    ..long = C.obleLong
    ..lat = C.obleLat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SelectBuildingRoom()));

                    if (result != null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result.toString())));
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("receieved null")));
                      }
                    }
                  },
                  child: Text("Click")),
            ],
          ),
        ));
  }

}
