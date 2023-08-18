import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/widgets/timeline/Timeline.dart';
import 'package:course_planner/widgets/timeline/TimelineCard.dart';
import 'package:course_planner/widgets/timetable/Timetable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './styles/color_schemes.g.dart';
import 'models/Subject.dart';
import 'utils/enums.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => SubjectProvider())),
      ChangeNotifierProvider(create: ((context) => TermProvider()))
    ],
    child: MyApp(),
  ));
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

  var count = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Material Theme Builder"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17),
        child: ListView(
          children: [
          ],
        ),
      )
    );
  }
}
