import 'package:flutter/material.dart';
import '../../utils/constants.dart' as C;

class UnassignedCard extends StatefulWidget {
  final Function? onTap;
  final int? count;
  final String title;

  const UnassignedCard(
      {super.key, this.count, this.onTap, this.title = "Unassigned"});

  @override
  State<UnassignedCard> createState() => _UnassignedCardState();
}

class _UnassignedCardState extends State<UnassignedCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(C.cardBorderRadius),
      clipBehavior: Clip.hardEdge,
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.tertiaryContainer),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () => widget.onTap?.call(),
          child: _cardContainer(context),
        ),
      ),
    );
  }

  Widget _cardContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                  width: 4,
                  height: 28,
                ),
                const SizedBox(width: 12), // Add some spacing
                // Column with text
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer),
                    overflow:
                        TextOverflow.ellipsis, // Add this to prevent overflow
                    maxLines: 1, // Ensure it fits within one line
                  ),
                ),
              ],
            ),
          ),
          _count(context)
        ],
      ),
    );
  }

  Widget _count(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.onTertiaryContainer),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Text(
        widget.count! > 99 ? "99+" : widget.count.toString(),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.tertiaryContainer),
      ),
    );
  }
}
