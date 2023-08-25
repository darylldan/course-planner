import 'package:flutter/material.dart';
import '../../utils/constants.dart' as Constants;

class ErrorCard extends StatelessWidget {
  final String title;
  final String content;
  const ErrorCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
                    title.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: Constants.titleCardHeaderFontSize),
                  )
                ],
              ),
              SizedBox(height: 15,),
              Text(
                content,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Constants.titleCardInstructionFontSize,
                    color: Theme.of(context).colorScheme.onErrorContainer),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
