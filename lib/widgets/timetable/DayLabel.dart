import 'package:flutter/material.dart';
import '../../utils/enums.dart';

class DayLabel extends StatelessWidget {
  var isOpaque;
  Day day;

  DayLabel({super.key, required this.day ,required this.isOpaque});

  @override
  Widget build(BuildContext context) {
    if (isOpaque) {
      return _opaqueLabel(context);
    }

    return _transparentLabel(context);
  }

  Widget _opaqueLabel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      width: 53,
      height: 17,
      child: Center(
        child: Text(
          day.name.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 9),
        ),
      ),
    );
  }

  Widget _transparentLabel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            strokeAlign: BorderSide.strokeAlignInside
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      width: 53,
      height: 17,
      child: Center(
        child: Text(
          day.name.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 9),
        ),
      ),
    );
  }
}
