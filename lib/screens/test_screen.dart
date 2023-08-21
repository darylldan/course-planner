import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/widgets/cards/current_term_card.dart';
import 'package:course_planner/widgets/cards/error_card.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/overlap_warning_card.dart';
import 'package:course_planner/widgets/cards/subject_card.dart';
import 'package:course_planner/widgets/cards/term_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/Term.dart';
import '../utils/constants.dart' as C;
import '../widgets/elements/title_text.dart';

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

  @override
  Widget build(BuildContext context) {
    selectedColor ??= colors.first;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _showColorPicker,
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(color: selectedColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Select Color")
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _clickableContainer(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Pressed on tap!")));
          },
          child: Container(
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 450,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 16),
                child: Text(
                  "Select Color",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
              Flexible(flex: 1, child: _buildColors())
            ],
          ),
        );
      },
    );
  }

  Widget _buildColors() {
    return GridView.count(
      padding: EdgeInsets.all(20),
      mainAxisSpacing: 20,
      crossAxisSpacing: 30,
      crossAxisCount: 5,
      children: colors.map<Widget>((e) => _colorCube(e!)).toList(),
    );
  }

  Widget _colorCube(Color color) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.pop(context);
            setState(() {
              selectedColor = color;
            });
          },
          child: Container(
            height: 10,
            width: 10,
            child: (color == selectedColor)
                ? Center(
                    child: Icon(Icons.check),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
