import 'package:flutter/material.dart';
import '../../utils/constants.dart' as Constants;

class ErrorCard extends StatelessWidget {
  const ErrorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.titleCardPaddingH,
          vertical: Constants.titleCardPaddingV),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          color: Theme.of(context).colorScheme.errorContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.cancel_rounded,
                  size: Constants.cardIconSize,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              Text(
                "Info",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: Constants.titleCardHeaderFontSize),
              )
            ],
          ),
          Text(
            "An error occured.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Constants.titleCardInstructionFontSize,
                color: Theme.of(context).colorScheme.onErrorContainer),
          )
        ],
      ),
    );
  }
}
