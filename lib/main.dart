import 'package:course_planner/widgets/timetable/Timetable.dart';
import 'package:flutter/material.dart';
import './styles/color_schemes.g.dart';
import 'models/Subject.dart';
import 'utils/enums.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    List<Subject> subjects = [
    Subject(
        subjectID: "1",
        courseCode: "CMSC 124",
        isLaboratory: false,
        section: "CD",
        room: "ICS Megahall",
        termID: "1",
        frequency: [Day.tue, Day.thu],
        startDate: DateTime(2021, 8, 15, 8),
        endDate: DateTime(2021, 8, 15, 9),
        color: Colors.amber[800]!),
    Subject(
        subjectID: "2",
        courseCode: "CMSC 141",
        isLaboratory: true,
        section: "D - 2L",
        room: "ICS PC Lab 7",
        termID: "1",
        frequency: [Day.tue],
        startDate: DateTime(2021, 8, 15, 10),
        endDate: DateTime(2021, 8, 15, 13),
        color: Colors.green[800]!),
    Subject(
        subjectID: "3",
        courseCode: "CMSC 170",
        isLaboratory: false,
        section: "X",
        room: "ICS Megahall",
        termID: "1",
        frequency: [Day.tue, Day.thu],
        startDate: DateTime(2021, 8, 15, 15),
        endDate: DateTime(2021, 8, 15, 16),
        color: Colors.blue[800]!),
    Subject(
        subjectID: "4",
        courseCode: "CMSC 124",
        isLaboratory: true,
        section: "ST - 3L",
        room: "ICS PC Lab 8",
        termID: "1",
        frequency: [Day.tue],
        startDate: DateTime(2021, 8, 15, 16),
        endDate: DateTime(2021, 8, 15, 19),
        color: Colors.deepOrange[800]!),
  ];

  var count = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Material Theme Builder"),
        ),
        body: ListView(
          children: [
            Timetable(subjects: subjects)
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline_rounded),
                          AlertDialog(
                            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                            title: const Text("Hello world!!!"),
                            actions: [
                              TextButton(onPressed: () {}, child: const Text("Hello!"))
                            ],
                          ),
                        ],
                      ),
                    );
                  });

              setState(() {
                count++;
              });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add)));
  }
}
