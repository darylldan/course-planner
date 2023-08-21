import 'package:course_planner/api/IsarService.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/classes_module/add_class.dart';
import 'package:course_planner/screens/classes_module/classes.dart';
import 'package:course_planner/screens/terms_module/add_term.dart';
import 'package:course_planner/screens/terms_module/terms.dart';
import 'package:course_planner/screens/test_screen.dart';
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
      ChangeNotifierProvider(create: ((context) => TermProvider())),
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
      title: 'Course Planner',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const Classes(),
    );
  }
}
