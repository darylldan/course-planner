import 'package:iscompanion/models/CourseGrade.dart';
import 'package:iscompanion/models/Term.dart';
import 'package:iscompanion/providers/course_grade_provider.dart';
import 'package:iscompanion/widgets/cards/course_grade_card.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/cards/term_grade_summary.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class ViewCourseGrade extends StatefulWidget {
  final Term term;

  const ViewCourseGrade({super.key, required this.term});

  @override
  State<ViewCourseGrade> createState() => _ViewCourseGradeState();
}

class _ViewCourseGradeState extends State<ViewCourseGrade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TitleText(title: "Course Grades"), _buildBody(context)],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<CourseGrade> courseGrades = context
        .watch<CourseGradeProvider>()
        .getCourseGradeByTerm(widget.term.id!);

    if (courseGrades.isEmpty) {
      return InfoCard(
          content:
              "No courses yet. Begin by adding a course on the Courses screen.");
    }

    return Column(
      children: [
        TermGradeSummary(term: widget.term),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Divider(),
        ),
        ...courseGrades.map((cg) => CourseGradeCard(courseGrade: cg)),
      ],
    );
  }
}
