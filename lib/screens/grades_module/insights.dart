import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/term_grade_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/widgets/cards/overall_gwa_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants.dart' as C;
import 'package:flutter/material.dart';

class GradeInsights extends StatefulWidget {
  const GradeInsights({super.key});

  @override
  State<GradeInsights> createState() => _GradeInsightsState();
}

class _GradeInsightsState extends State<GradeInsights> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TitleText(title: "Grade Insights"), _body(context)],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    Term? currTerm = context.read<TermProvider>().currentTerm;
    double overallGWA = context.read<TermGradeProvider>().getOverallGWA();
    int totalUnitsTaken =
        context.read<TermGradeProvider>().getOverallUnitsTaken();
    Honors currHonor = context.read<TermGradeProvider>().getLatinHonorStatus();
    Map<dynamic, dynamic>? gwaGoal =
        context.read<TermGradeProvider>().getRequiredGWAForLatin();

    Map<String, dynamic>? highestGWA =
        context.read<TermGradeProvider>().getGWAExtremes(false);
    Map<String, dynamic>? lowestGWA =
        context.read<TermGradeProvider>().getGWAExtremes(true);
    Map<dynamic, int> gradeTally =
        context.read<TermGradeProvider>().getGradeTally();

    return Column(
      children: [
        OverallGwaCard(gwa: overallGWA, totalUnitsTaken: totalUnitsTaken),
        SizedBox(
          height: 10,
        ),
        if (currTerm != null) ...[
          _currentTermGWA(context, currTerm),
          SizedBox(
            height: 10,
          ),
        ],
        _currentLatinStanding(context, currHonor),
        SizedBox(
          height: 10,
        ),
        if (gwaGoal != null || gwaGoal!["remainingUnits"] == 0) ...[
          _requiredGradeForLatin(context, gwaGoal),
          SizedBox(
            height: 10,
          ),
        ],
        _highestTermGWA(context, highestGWA!),
        SizedBox(
          height: 10,
        ),
        _lowestTermGWA(context, lowestGWA!),
        SizedBox(
          height: 10,
        ),
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

  Widget _highestTermGWA(BuildContext context, Map<String, dynamic> gwa) {
    return _cardTemplate(
      context,
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(
            context,
            title: "Highest Term GWA",
            icon: Icons.arrow_upward,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
          Text(
            (gwa["gwa"] as double).toStringAsFixed(4),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: C.titleCardContentFontSize,
                color: Theme.of(context).colorScheme.inverseSurface),
          ),
          Text(
            "${gwa["obj"].semester}, ${gwa["obj"].academicYear}",
            style:
                TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          )
        ],
      ),
    );
  }

  Widget _lowestTermGWA(BuildContext context, Map<String, dynamic> gwa) {
    return _cardTemplate(
      context,
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(
            context,
            title: "Lowest Term GWA",
            icon: Icons.arrow_downward,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
          Text(
            (gwa["gwa"] as double).toStringAsFixed(4),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: C.titleCardContentFontSize,
                color: Theme.of(context).colorScheme.inverseSurface),
          ),
          Text(
            "${gwa["obj"].semester}, ${gwa["obj"].academicYear}",
            style:
                TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          )
        ],
      ),
    );
  }

  Widget _requiredGradeForLatin(
      BuildContext context, Map<dynamic, dynamic> gwaGoal) {
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
            "Out of the ${gwaGoal["remainingUnits"]} remaining units you need to complete, you must achieve the following average grade to qualify for a Latin honor.",
            style:
                TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          ),
          Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                gwaGoal[Honors.summa] < 1
                    ? "N/A"
                    : (gwaGoal[Honors.summa] as double).toStringAsFixed(4),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: C.titleCardContentFontSize,
                    color: Theme.of(context).colorScheme.inverseSurface),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Summa Cum Laude",
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
                gwaGoal[Honors.magna] < 1
                    ? "N/A"
                    : (gwaGoal[Honors.magna] as double).toStringAsFixed(4),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: C.titleCardContentFontSize,
                    color: Theme.of(context).colorScheme.inverseSurface),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Magna Cum Laude",
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
                gwaGoal[Honors.cum] < 1
                    ? "N/A"
                    : (gwaGoal[Honors.cum] as double).toStringAsFixed(4),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: C.titleCardContentFontSize,
                    color: Theme.of(context).colorScheme.inverseSurface),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Cum Laude",
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
            style:
                TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          ),
        ],
      ),
    );
  }

  Widget _currentLatinStanding(BuildContext context, Honors currHonor) {
    String label = "";
    String subtitle = "";
    switch (currHonor) {
      case Honors.cum:
        label = "Cum Laude 🎓";
        subtitle =
            "Great job! To qualify for Cum Laude, you need a minimum GWA of 1.7500. Aim for Magna Cum Laude next, which requires a GWA of at least 1.4500. Keep pushing forward! 💪✨";
        break;

      case Honors.magna:
        label = "Magna Cum Laude 🎓";
        subtitle =
            "Fantastic work! You've achieved Magna Cum Laude status with a GWA of at least 1.4500. To reach Summa Cum Laude, aim for a GWA of 1.200 or better. Keep striving for excellence! 🌟";
        break;

      case Honors.summa:
        label = "Summa Cum Laude 🎓";
        subtitle =
            "Legendary achievement! You've reached the pinnacle of academic honors with a GWA of 1.200 or better. You've set an extraordinary standard—inspire others with your dedication! 🏆🚀";
        break;

      case Honors.none:
        label = "No Latin Honor";
        subtitle =
            "Your academic journey is unique and valuable! Latin honors don't define your potential. Every step forward counts—keep learning, growing, and challenging yourself. Your hard work will open doors no honor can! 🌱🔥";
        break;
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  size: 18,
                ),
                SizedBox(
                  width: 6,
                ),
                Text("${currTerm.semester}, ${currTerm.academicYear} "),
              ],
            )
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
