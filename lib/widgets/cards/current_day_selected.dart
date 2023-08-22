import 'package:flutter/material.dart';
import '../../models/Term.dart';
import '../../utils/constants.dart' as C;
import '../../utils/enums.dart';
import '../elements/current_star.dart';

class CurrentDaySelectedCard extends StatelessWidget {
  final Day day;
  final Term term;
  final bool isCurrent;
  const CurrentDaySelectedCard(
      {super.key, required this.day, required this.term, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      size: C.cardIconSize,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    "Day",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: C.titleCardHeaderFontSize),
                  ),
                ],
              ),
              if (isCurrent)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: CurrentStar(),
                )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              DayMethods.dayToString(day),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: C.titleCardContentFontSize,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "${term.semester} | ${term.academicYear}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: C.titleCardHeaderFontSize),
            ),
          )
        ],
      ),
    );
  }
}
