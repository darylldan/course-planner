import 'package:flutter/material.dart';

import '../../models/Term.dart';
import '../elements/current_star.dart';
import '../../utils/constants.dart' as Constants;

class CurrentTermCard extends StatelessWidget {
  late Term term;
  late bool onCurrentTerm;

  CurrentTermCard({super.key, required this.term, required this.onCurrentTerm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.titleCardPaddingH,
          vertical: Constants.titleCardPaddingV),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          color: Theme.of(context).colorScheme.primaryContainer),
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
                      size: Constants.cardIconSize,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    onCurrentTerm ? "Current Term" : "Term",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: Constants.titleCardHeaderFontSize),
                  ),
                ],
              ),
              if (onCurrentTerm)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: CurrentStar(),
                )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              term.semester,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Constants.titleCardContentFontSize,
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              term.academicYear,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: Constants.titleCardHeaderFontSize),
            ),
          )
        ],
      ),
    );
  }
}
