import 'package:flutter/material.dart';
import '../../utils/constants.dart' as Constants;

class InfoCard extends StatelessWidget {
  double fontSize;
  late String content;

  InfoCard({super.key, required this.content, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Constants.cardPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          color: Theme.of(context).colorScheme.tertiaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              Text(
                "Info",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    fontSize: 14),
              )
            ],
          ),
          Text(
            content,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontSize: fontSize),
          )
        ],
      ),
    );
  }
}
