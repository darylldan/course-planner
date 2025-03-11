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
              _roomCard(context)
            ],
          ),
        ));
  }

  Widget _roomCard(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(C.cardBorderRadius),
      clipBehavior: Clip.hardEdge,
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.onInverseSurface),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () {},
          onLongPress: () => _showActions(context),
          child: _roomCardContainer(context),
        ),
      ),
    );
  }

  Widget _roomCardContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                  width: 4,
                  height: 50,
                ),
                const SizedBox(width: 8), // Add some spacing
                // Column with text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "hakjsdhfkjasdhfjkashdkfjahskkakjdsh",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow
                            .ellipsis, // Add this to prevent overflow
                        maxLines: 1, // Ensure it fits within one line
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Physical Sciences Building",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          _subjectCount(context)
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showActions(context),
                  icon: Icon(Icons.more_vert),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectCount(BuildContext context) {
    List<Subject> subjects =
        context.read<SubjectProvider>().getSubjectsByRoom(_room.id!);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
      child: Text(
        "5 SUBJECTS",
        style: TextStyle(
            color: Theme.of(context).colorScheme.onInverseSurface,
            fontSize: 11,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text("Edit Room"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => EditClass(
                    //               subject: subject,
                    //             )));
                  },
                ),
                ListTile(
                  title: const Text("Delete Room"),
                  leading: const Icon(Icons.delete_forever_rounded),
                  onTap: () {
                    // context.read<SubjectProvider>().deleteSubject(subject.id!);

                    // if (context.mounted) {
                    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //     content: Text("Subject deleted."),
                    //   ));
                    //   Navigator.pop(context);
                    // }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
