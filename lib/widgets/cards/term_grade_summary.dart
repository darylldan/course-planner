import 'package:iskotrack/models/Term.dart';
import 'package:iskotrack/providers/subject_provider.dart';
import 'package:iskotrack/providers/term_grade_provider.dart';
import 'package:iskotrack/screens/grades_module/term_grade_insights.dart';
import 'package:iskotrack/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class TermGradeSummary extends StatefulWidget {
  final Term term;

  const TermGradeSummary({super.key, required this.term});

  @override
  State<TermGradeSummary> createState() => _TermGradeSummaryState();
}

class _TermGradeSummaryState extends State<TermGradeSummary> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(C.cardBorderRadius)),
        child: _buildBody(context),
      ),
      Container(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(right: 12, top: 4),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TermGradeInsights(term: widget.term)));
            },
            icon: Icon(
              Icons.insights,
            ),
            iconSize: 18,
            visualDensity: VisualDensity.compact,
          ),
        ),
      )
    ]);
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        _buildTermInfo(context),
        _dividerTitle(context),
        _termGradeInformation(context)
      ],
    );
  }

  Widget _buildTermInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.term.semester,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: C.titleCardContentFontSize),
        ),
        Text(
          widget.term.academicYear,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w300),
        )
      ],
    );
  }

  Widget _termGradeInformation(BuildContext context) {
    context.read<TermGradeProvider>().updateState();
    double termGWA = context
        .watch<TermGradeProvider>()
        .getTermGWAFromCourses(widget.term.id!);

    int creditedUnits =
        context.read<SubjectProvider>().getTermUnits(widget.term.id!);
    int nonCreditedUnits = context
        .read<SubjectProvider>()
        .getTermUnits(widget.term.id!, credited: false);

    Map<String, int> courseCountInfo =
        context.watch<TermGradeProvider>().encodedGradesCount(widget.term.id!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _termGwa(context, termGWA),
        Opacity(
          opacity: 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Container(
              height: 50,
              width: 1,
              color: Colors.white,
            ),
          ),
        ),
        _units(context, creditedUnits, nonCreditedUnits),
        Opacity(
          opacity: 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Container(
              height: 50,
              width: 1,
              color: Colors.white,
            ),
          ),
        ),
        _coursesEncoded(
            context, courseCountInfo['c_encoded']!, courseCountInfo['c_total']!)
      ],
    );
  }

  Widget _coursesEncoded(BuildContext context, int encoded, int total) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _gradeInfoTitle(context, Icons.check, "Encoded"),
        if (encoded > 99 || total > 99)
          SizedBox(
            height: 5,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              encoded > 99 ? "99+" : encoded.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: (encoded > 99 || total > 99) ? 14 : 20),
            ),
            Text(
              total > 99 ? "/99+" : "/${total.toString()}",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: (encoded > 99 || total > 99) ? 14 : 20),
            ),
          ],
        ),
        if (encoded > 99 || total > 99)
          SizedBox(
            height: 5,
          ),
        Text(
          "Courses",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 9),
        )
      ],
    );
  }

  Widget _units(BuildContext context, int creditedUnits, int nonCreditedUnits) {
    return Column(
      children: [
        _gradeInfoTitle(context, Icons.book, "Units"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  creditedUnits > 99 ? "99+" : creditedUnits.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "Credited",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 9),
                )
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              children: [
                Text(
                  nonCreditedUnits > 99 ? "99+" : nonCreditedUnits.toString(),
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                ),
                Text(
                  "Non-Credited",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 9),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _termGwa(BuildContext context, double termGWA) {
    HonorificScholarship? hs = context
        .watch<TermGradeProvider>()
        .getHonorificScholarshipStatus(widget.term.id!);
    return Column(
      children: [
        _gradeInfoTitle(context, Icons.star, "Term GWA"),
        Text(
          termGWA.toStringAsFixed(4),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          hs == null ? "N/A" : HonorificScholarshipMethods.getValue(hs)!,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 9),
        )
      ],
    );
  }

  Widget _gradeInfoTitle(BuildContext context, IconData icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          size: 12,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
        )
      ],
    );
  }

  Widget _dividerTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Opacity(
              opacity: 0.5,
              child: Divider(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "Grade Information",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 14),
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: 0.5,
              child: Divider(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.calendar_today,
            size: C.cardIconSize,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          "Term",
          style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onErrorContainer,
              fontSize: C.titleCardHeaderFontSize),
        ),
      ],
    );
  }
}
