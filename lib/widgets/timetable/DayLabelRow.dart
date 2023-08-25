import 'package:flutter/material.dart';
import '../../utils/enums.dart';

import 'DayLabel.dart';

class DayLabelRow extends StatelessWidget {
  const DayLabelRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 43),
        DayLabel(day: Day.mon, isOpaque: true),
        DayLabel(day: Day.tue, isOpaque: false),
        DayLabel(day: Day.wed, isOpaque: true),
        DayLabel(day: Day.thu, isOpaque: false),
        DayLabel(day: Day.fri, isOpaque: true),
        DayLabel(day: Day.sat, isOpaque: false),
      ],
    );
  }
}
