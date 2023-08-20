import 'package:course_planner/providers/term_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Term.dart';
import '../elements/current_star.dart';
import '../../utils/constants.dart' as Constants;

class CurrentTermSelectedCard extends StatelessWidget {
  late Term term;
  late bool onCurrentTerm;
  late bool editMode;

  CurrentTermSelectedCard(
      {super.key,
      required this.term,
      required this.onCurrentTerm,
      required this.editMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.titleCardPaddingH,
          vertical: Constants.titleCardPaddingV),
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
                    _title(),
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

  String _title() {
    if (editMode) {
      return "Editing Term";
    }

    if (onCurrentTerm) {
      return "Current Term";
    }

    return "Term";
  }
}
