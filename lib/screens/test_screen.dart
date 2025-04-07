import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/DeadlineEvent.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/models/Todo.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/screens/buildings_module/location_picker.dart';
import 'package:course_planner/screens/buildings_module/select_building_room.dart';
import 'package:course_planner/widgets/cards/building_card.dart';
import 'package:course_planner/widgets/cards/event_course_card.dart';
import 'package:course_planner/widgets/cards/events_card.dart';
import 'package:course_planner/widgets/cards/quick_notes_card.dart';
import 'package:course_planner/widgets/cards/term_grade_card.dart';
import 'package:course_planner/widgets/cards/todo_card.dart';
import 'package:course_planner/widgets/cards/unassigned_card.dart';
import 'package:course_planner/widgets/elements/drawer.dart';
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

  Term _term = Term()
    ..id = 1
    ..academicYear = "A.Y. 2024 - 2025"
    ..semester = "First Semester"
    ..startDate = DateTime.now()
    ..endDate = DateTime.now()
    ..isCurrentTerm = true;

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

  DeadlineEvent dle = DeadlineEvent()
    ..id = 1
    ..courseId = 1
    ..description = "Lexical Analyzer Deadline"
    ..date = DateTime.now().add(Duration(days: 10));

  Todo todo = Todo()
    ..id = 1
    ..courseId = 1
    ..termId = 1
    ..task = "Study for exam"
    ..isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: SideDrawer(parent: '/test-screen'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TermGradeCard(term: _term),
              ElevatedButton(
                  onPressed: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectBuildingRoom()));

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
              TodoCard(todo: todo)
            ],
          ),
        ));
  }
}
