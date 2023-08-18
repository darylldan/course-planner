import 'package:flutter/material.dart';

class CurrentStar extends StatelessWidget {
  const CurrentStar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.star_rounded,
              size: 14,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          Text(
            "CURRENT",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 10,
              color: Theme.of(context).colorScheme.primaryContainer
            ),
          )
        ],
      ),
    );
  }
}
