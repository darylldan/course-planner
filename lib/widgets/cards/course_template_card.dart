import 'package:iskotrack/models/CourseTemplate.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart' as C;

class CourseTemplateCard extends StatelessWidget {
  final CourseTemplate ct;

  const CourseTemplateCard({super.key, required this.ct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            onTap: () {
              Navigator.pop(context, ct);
            },
            child: _cardContainer(context),
          ),
        ),
      ),
    );
  }

  Widget _cardContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).colorScheme.inverseSurface),
                    width: 4,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ct.courseCode,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      Row(children: [
                        if (ct.units != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            constraints: BoxConstraints(maxWidth: 60),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                "${ct.units} Units",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                        Expanded(
                          child: Text(
                            ct.description,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
