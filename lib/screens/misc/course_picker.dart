import 'package:iskotrack/models/Subject.dart';
import 'package:iskotrack/models/Term.dart';
import 'package:iskotrack/providers/subject_provider.dart';
import 'package:iskotrack/widgets/cards/error_card_no_action.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/cards/subject_card.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class CoursePicker extends StatefulWidget {
  final Term term;

  const CoursePicker({super.key, required this.term});

  @override
  State<CoursePicker> createState() => _CoursePickerState();
}

class _CoursePickerState extends State<CoursePicker> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Subject> courses =
        context.read<SubjectProvider>().getSubjectsByTerm(widget.term.id!);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Select a Course"),
            if (courses.isEmpty)
              InfoCard(
                  content:
                      "There are no courses yet. Create one via the Courses screen.")
            else ...[
              InfoCard(
                  content:
                      "Showing all courses for ${widget.term.semester} (${widget.term.academicYear})."),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
              _buildBody(context, courses),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Subject> courses) {
    if (_searchCtrl.text.isNotEmpty) {
      courses = courses
          .where((c) =>
              "${c.courseCode} - ${c.isLaboratory ? "Laboratory" : "Lecture"}"
                  .toLowerCase()
                  .contains(_searchCtrl.text.trim().toLowerCase()))
          .toList();
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                ),
                onChanged: (String val) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (_searchCtrl.text.isNotEmpty)
              IconButton(
                  onPressed: () => setState(() {
                        _searchCtrl.clear();
                      }),
                  icon: Icon(Icons.clear))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        if (courses.isEmpty)
          ErrorCardNoAction(
              title: "Search Result", content: "No courses found.")
        else
          ...courses.map((c) => ClassCard(
                subject: c,
                pickMode: true,
              )),
        SizedBox(
          height: 150,
        )
      ],
    );
  }
}
