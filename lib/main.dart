import 'package:course_planner/providers/building_provider.dart';
import 'package:course_planner/providers/course_grade_provider.dart';
import 'package:course_planner/providers/course_template_provider.dart';
import 'package:course_planner/providers/deadlineevent_provider.dart';
import 'package:course_planner/providers/note_provider.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_grade_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/providers/todo_provider.dart';
import 'package:course_planner/screens/overview_module/overview.dart';
import 'package:course_planner/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => SubjectProvider())),
      ChangeNotifierProvider(create: ((context) => TermProvider())),
      ChangeNotifierProvider(create: ((context) => BuildingProvider())),
      ChangeNotifierProvider(create: ((context) => DeadlineEventProvider())),
      ChangeNotifierProvider(create: ((context) => NoteProvider())),
      ChangeNotifierProvider(create: ((context) => TodoProvider())),
      ChangeNotifierProvider(create: ((context) => RoomProvider())),
      ChangeNotifierProvider(create: ((context) => TermGradeProvider())),
      ChangeNotifierProvider(create: ((context) => CourseGradeProvider())),
      ChangeNotifierProvider(create: ((context) => CourseTemplateProvider()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    loadAll(context);

    final materialTheme = MaterialTheme(TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      // Add more text styles as needed
    ));
    return MaterialApp(
      title: 'Course Planner',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: const Overview(),
    );
  }

  void loadAll(BuildContext context) {
    context.read<CourseTemplateProvider>().loadTemplates();
    context.read<BuildingProvider>().load();
    context.read<DeadlineEventProvider>().load();
    context.read<NoteProvider>().load();
    context.read<BuildingProvider>().load();
    context.read<RoomProvider>().load();
    context.read<TermProvider>().load();
    context.read<TodoProvider>().load();
    context.read<CourseGradeProvider>().load();
  }
}
