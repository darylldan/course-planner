import 'package:iskotrack/models/Term.dart';
import 'package:iskotrack/providers/subject_provider.dart';
import 'package:iskotrack/providers/term_grade_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iskotrack/utils/enums.dart';
import 'package:iskotrack/widgets/cards/overall_gwa_card.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class TermGradeInsights extends StatefulWidget {
  final Term term;

  const TermGradeInsights({super.key, required this.term});

  @override
  State<TermGradeInsights> createState() => _TermGradeInsightsState();
}

class _TermGradeInsightsState extends State<TermGradeInsights> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Term Grade Insights"),
            _buildBody(context)
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    double overallGWA = context.read<TermGradeProvider>().getOverallGWA();

    int totalUnitsTaken =
        context.read<TermGradeProvider>().getOverallUnitsTaken();
    HonorificScholarship? honSchol = context
        .read<TermGradeProvider>()
        .getHonorificScholarshipStatus(widget.term.id!);
    int termUnits =
        context.read<SubjectProvider>().getTermUnits(widget.term.id!);
    Map<dynamic, dynamic> gwaGoal = context
        .read<TermGradeProvider>()
        .getRequiredGWAForHonSch(widget.term.id!, termUnits);
    Map<dynamic, int> gradeTally =
        context.read<TermGradeProvider>().getTermGradeTally(widget.term.id!);

    return Column(
      children: [
        OverallGwaCard(gwa: overallGWA, totalUnitsTaken: totalUnitsTaken),
        SizedBox(
          height: 10,
        ),
        _currentTermGWA(context, widget.term),
        SizedBox(
          height: 10,
        ),
        if (honSchol != null) ...[
          _currentHonScholStanding(context, honSchol),
          SizedBox(
            height: 10,
          ),
        ],
        if (gwaGoal["remainingUnits"] > 0) ...[
          _requiredGradeForHonSchol(
              context,
              gwaGoal,
              honSchol != HonorificScholarship.ineligibleUnderload &&
                  honSchol != HonorificScholarship.ineligibleLowGrade),
          SizedBox(
            height: 10,
          ),
        ],
        _gradeTally(context, gradeTally),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "SOURCE",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () async {
                final Uri url = Uri.parse('https://uplbosa.org/page-handbook');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primaryContainer)),
              child: Row(children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "UPLB Student Handbook",
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Icon(Icons.link)
              ]),
            ))
          ],
        ),
        SizedBox(
          height: 150,
        )
      ],
    );
  }

  Widget _gradeTally(BuildContext context, Map<dynamic, int> gradeTally) {
    List<Row> tallyWidget = gradeTally.keys
        .map(
          (gt) => Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                gradeTally[gt].toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: C.titleCardContentFontSize,
                    color: Theme.of(context).colorScheme.inverseSurface),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                gt is NumericalGrade
                    ? GradeMethods.getStringValue(gt)
                    : gt is NonNumericalGrade
                        ? NonNumGradeMethods.getStringValue(gt)
                        : "Unknown",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface),
              )
            ],
          ),
        )
        .toList();

    return _cardTemplate(context,
        color: Theme.of(context).colorScheme.onInverseSurface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(context,
                title: "Grade Tally",
                icon: Icons.list_alt_rounded,
                color: Theme.of(context).colorScheme.inverseSurface),
            Text(
              "The tally includes both credited and non-credited courses.",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface),
            ),
            Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [...(tallyWidget.sublist(0, 5))],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [...(tallyWidget.sublist(5, 10))],
                  ),
                )
              ],
            ),
            Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [...(tallyWidget.sublist(10, 13))],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [...(tallyWidget.sublist(13, 15))],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _requiredGradeForHonSchol(
      BuildContext context, Map<dynamic, dynamic> gwaGoal, bool isEligible) {
    return _cardTemplate(
      context,
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(context,
              title: "Grade Goal",
              icon: Icons.sports_score,
              color: Theme.of(context).colorScheme.inverseSurface),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                gwaGoal["remainingUnits"].toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: C.titleCardContentFontSize,
                    color: Theme.of(context).colorScheme.inverseSurface),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Remaining Units to Take",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface),
              )
            ],
          ),
          Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
          Text(
            isEligible
                ? "Out of the ${gwaGoal["remainingUnits"]} remaining units you need to complete this term, you must achieve the following average grade to qualify for an honorific scholarship."
                : "You are no longer eligible for an honorific scholarship for this term regardless of your GWA.",
            style:
                TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          ),
          if (isEligible) ...[
            Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  gwaGoal[HonorificScholarship.university] < 1
                      ? "N/A"
                      : (gwaGoal[HonorificScholarship.university] as double)
                          .toStringAsFixed(4),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: C.titleCardContentFontSize,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "University Scholar",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  gwaGoal[HonorificScholarship.college] < 1
                      ? "N/A"
                      : (gwaGoal[HonorificScholarship.college] as double)
                          .toStringAsFixed(4),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: C.titleCardContentFontSize,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "College Scholar",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface),
                )
              ],
            ),
            Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
            Text(
              "An N/A goal means that it is impossible to achieve that latin honor with the remaining units. If the goal is greater than 3, it means that you need a passing grade (3.0) in order to achieve that latin honor.",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface),
            ),
          ]
        ],
      ),
    );
  }

  Widget _currentHonScholStanding(
      BuildContext context, HonorificScholarship honSchol) {
    String label = "";
    String subtitle = "";
    switch (honSchol) {
      case HonorificScholarship.ineligibleUnderload:
        label = "Ineligible (Underload)";
        subtitle =
            "A regular load must be taken (15 units) in order to become eligible for honorific scholarships";
      case HonorificScholarship.ineligibleLowGrade:
        label = "Ineligible (Low Grade)";
        subtitle =
            "You have incurred a failing grade (a GWA of greater than 3.0) or your current GWA is greater than 3.0";
      case HonorificScholarship.goodStanding:
      case HonorificScholarship.honorRoll:
        label = HonorificScholarshipMethods.getValue(honSchol)!;
        subtitle =
            "You have a passing GWA. In order to achieve a college scholar award, your GWA must be at least 1.75 and above.";
      case HonorificScholarship.college:
        label = HonorificScholarshipMethods.getValue(honSchol)!;
        subtitle =
            "The minimum GWA for a college scholar is 1.75. To get university scholar, your GWA must be at least 1.45.";
      case HonorificScholarship.university:
        label = HonorificScholarshipMethods.getValue(honSchol)!;
        subtitle =
            "You have achieved the highest honorific scholarship. Hooray! 🎉";
    }

    return _cardTemplate(context,
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(context,
                title: "Current Latin Honor",
                icon: Icons.emoji_events,
                color: Theme.of(context).colorScheme.onTertiaryContainer),
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: C.titleCardContentFontSize,
                  color: Theme.of(context).colorScheme.onTertiaryContainer),
            ),
            Text(
              subtitle,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiaryContainer),
            )
          ],
        ));
  }

  Widget _currentTermGWA(BuildContext context, Term currTerm) {
    double currentTermGWA =
        context.read<TermGradeProvider>().getTermGWAFromCourses(currTerm.id!);

    return _cardTemplate(context,
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(context,
                title: "Current Term GWA",
                icon: Icons.calendar_today,
                color: Theme.of(context).colorScheme.onSecondaryContainer),
            Text(
              currentTermGWA.toStringAsFixed(4),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: C.titleCardContentFontSize),
            ),
            Text("${currTerm.semester}, ${currTerm.academicYear} "),
          ],
        ));
  }

  Widget _title(BuildContext context,
      {required String title, required IconData icon, required Color color}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            icon,
            size: C.cardIconSize,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w300,
              color: color,
              fontSize: C.titleCardHeaderFontSize),
        ),
      ],
    );
  }

  Widget _cardTemplate(BuildContext context,
      {required Color color, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      child: child,
    );
  }
}
