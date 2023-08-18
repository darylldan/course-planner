import 'package:flutter/material.dart';

import '../../models/Term.dart';
import '../../utils/constants.dart' as Constants;

class TermCard extends StatelessWidget {
  late Term term;

  TermCard({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.titleCardPaddingH,
          vertical: Constants.titleCardPaddingV),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 14),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  width: 4,
                  height: 60,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 275,
                    child: Text(
                      term.semester,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Constants.titleCardContentFontSize,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  SizedBox(
                    width: 275,
                    child: Text(
                      term.academicYear,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  )
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz_rounded),
              )
            ],
          )
        ],
      ),
    );
  }
}
