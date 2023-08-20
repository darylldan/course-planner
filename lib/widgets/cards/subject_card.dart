import 'package:course_planner/providers/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/Subject.dart';
import '../../utils/constants.dart' as C;
import '../../utils/enums.dart';

class ClassCard extends StatelessWidget {
  final Subject subject;
  const ClassCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            onTap: () {},
            child: _subjectContainer(context),
          ),
        ),
      ),
    );
  }

  Widget _subjectContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 12),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromARGB(
                    subject.color[0],
                    subject.color[1],
                    subject.color[2],
                    subject.color[3],
                  )),
              width: 4,
              height: 50,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 275,
                child: Text(
                  "${subject.courseCode} - ${subject.isLaboratory ? 'Laboratory' : 'Lecture'}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              Row(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  constraints: BoxConstraints(maxWidth: 60),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(4)),
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        subject.section,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                _buildSubjectSubtitle(context),
              ])
            ],
          ),
          IconButton(
            onPressed: () {
              context.read<SubjectProvider>().deleteSubjects([subject.id!]);
            },
            icon: Icon(Icons.more_vert_rounded),
          )
        ],
      ),
    );
  }

  Widget _buildSubjectSubtitle(BuildContext context) {
    String subTitle = "";

    for (var d in subject.frequency) {
      switch (d) {
        case Day.mon:
          subTitle = "${subTitle}Mo";
        case Day.tue:
          subTitle = "${subTitle}Tu";
        case Day.wed:
          subTitle = "${subTitle}We";
        case Day.thu:
          subTitle = "${subTitle}Th";
        case Day.fri:
          subTitle = "${subTitle}Fr";
        case Day.sat:
          subTitle = "${subTitle}Sa";
      }
    }

    String startDate = DateFormat.jm().format(subject.startDate);
    String endDate = DateFormat.jm().format(subject.endDate);

    subTitle = "$subTitle $startDate - $endDate";

    return SizedBox(
      width: 200,
      child: Text(
        subTitle,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
