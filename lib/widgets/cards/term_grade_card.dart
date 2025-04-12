import 'package:iscompanion/models/Term.dart';
import 'package:iscompanion/models/TermGrade.dart';
import 'package:iscompanion/providers/subject_provider.dart';
import 'package:iscompanion/providers/term_grade_provider.dart';
import 'package:iscompanion/screens/grades_module/add_term_grade.dart';
import 'package:iscompanion/screens/grades_module/view_course_grade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class TermGradeCard extends StatefulWidget {
  final dynamic term;

  const TermGradeCard({super.key, required this.term});

  @override
  State<TermGradeCard> createState() => _TermGradeCardState();
}

class _TermGradeCardState extends State<TermGradeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Material(
          child: Ink(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(C.cardBorderRadius)),
            child: InkWell(
              onTap: () {
                if (widget.term is TermGrade) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTermGrade(
                                termGrade: widget.term,
                                editMode: true,
                              )));
                }

                if (widget.term is Term) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewCourseGrade(term: widget.term)));
                }
              },
              onLongPress: widget.term is TermGrade
                  ? () {
                      _showActions(context);
                    }
                  : null,
              borderRadius: BorderRadius.circular(C.cardBorderRadius),
              child: _termGradeCardContainer(context),
            ),
          ),
        ));
  }

  Widget _termGradeCardContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 14),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: widget.term is Term
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onTertiaryContainer),
              width: 4,
              height: 50,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.term.semester,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                    if (widget.term is TermGrade) ...[
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.emergency,
                        size: 18,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      )
                    ]
                  ],
                ),
                Row(
                  children: [
                    _termGrade(context),
                    SizedBox(
                      width: 10,
                    ),
                    _units(context),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        widget.term.academicYear,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _termGrade(BuildContext context) {
    double grade = 0.0;
    if (widget.term is Term) {
      grade = context
          .read<TermGradeProvider>()
          .getTermGWAFromCourses(widget.term.id);
    } else {
      grade = widget.term.grade;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      child: SizedBox(
        child: Center(
          child: Text(
            "GWA: ${grade.toStringAsFixed(3)}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontWeight: FontWeight.bold,
                fontSize: 11),
          ),
        ),
      ),
    );
  }

  Widget _units(BuildContext context) {
    int units = widget.term is Term
        ? context.watch<SubjectProvider>().getTermUnits(widget.term.id)
        : widget.term.units;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      child: SizedBox(
        child: Center(
          child: Text(
            "${units}u",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontWeight: FontWeight.bold,
                fontSize: 11),
          ),
        ),
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
                  title: const Text("Edit Term Grade"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTermGrade(
                                  termGrade: widget.term,
                                  editMode: true,
                                )));
                  },
                ),
                ListTile(
                  title: const Text("Delete Term Grade"),
                  leading: const Icon(Icons.delete_forever_rounded),
                  onTap: () {
                    context
                        .read<TermGradeProvider>()
                        .deleteTermGrade(widget.term.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Term Grade Deleted."),
                    ));
                    Navigator.pop(context);
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
