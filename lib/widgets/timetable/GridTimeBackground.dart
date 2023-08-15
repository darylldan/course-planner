import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GridTimeBackground extends StatelessWidget {
  var hours;
  GridTimeBackground({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getLineWithTime(context, hours),
      ),
    );
  }

  List<Widget> _getLineWithTime(BuildContext context, int hourCount) {
    List<Widget> list = [];
    DateTime date = DateTime(2023, 8, 14, 7, 0);

    for (int i = 0; i < hourCount; i++) {
      list.addAll([
        _semiTransparentDivider(context),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            DateFormat.jm().format(date),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
          ),
        )
      ]);

      date = date.add(const Duration(hours: 1));
    }

    list.add(_semiTransparentDivider(context));
    return list;
  }

  Widget _semiTransparentDivider(BuildContext context) {
    return Opacity(
        opacity: 0.5,
        child: Divider(color: Theme.of(context).colorScheme.onSurface));
  }
}
