import 'package:flutter/material.dart';
import '../../utils/constants.dart' as Constants;

class TitleText extends StatelessWidget {
  final String title;

  const TitleText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: Constants.titleFontSize),
      ),
    );
  }
}
