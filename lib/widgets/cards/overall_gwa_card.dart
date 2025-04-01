import 'package:flutter/material.dart';
import '../../utils/constants.dart' as C;

class OverallGwaCard extends StatelessWidget {
  final double gwa;
  final int totalUnitsTaken;

  const OverallGwaCard(
      {super.key, required this.gwa, required this.totalUnitsTaken});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      padding: EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.star_rate_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                "Overall General Weighted Average",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          Text(
            gwa.toStringAsFixed(5),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: C.titleCardContentFontSize),
          ),
          Text(
            "Total Units Taken: $totalUnitsTaken",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w300
            ),
          )
        ],
      ),
    );
  }
}
