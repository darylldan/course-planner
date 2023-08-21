import 'package:course_planner/providers/term_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Term.dart';
import '../../utils/constants.dart' as Constants;
import '../../screens/terms_module/edit_term.dart';

class TermCard extends StatelessWidget {
  late Term term;

  TermCard({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Material(
          child: Ink(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius:
                    BorderRadius.circular(Constants.cardBorderRadius)),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
              child: _termCardContainer(context),
            ),
          ),
        ));
  }

  Widget _termCardContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.titleCardPaddingH, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 14),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  width: 4,
                  height: 50,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      term.semester,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      term.academicYear,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  )
                ],
              ),
              IconButton(
                onPressed: () {
                  _showActions(context);
                },
                icon: const Icon(Icons.more_vert_rounded),
              )
            ],
          )
        ],
      ),
    );
  }

  void onTap() {
    print("tapped!");
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (!term.isCurrentTerm)
                  ListTile(
                    title: const Text("Set as Current Term"),
                    leading: const Icon(Icons.star_rounded),
                    onTap: () {
                      context.read<TermProvider>().setCurrentTerm(term);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Current term was set."),
                      ));
                      Navigator.pop(context);
                    },
                  ),
                ListTile(
                  title: const Text("Edit Term"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTerm(
                                  term: term,
                                )));
                  },
                ),
                ListTile(
                  title: const Text("Delete Term"),
                  leading: const Icon(Icons.delete_forever_rounded),
                  onTap: () {
                    context.read<TermProvider>().deleteTerm(term);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Term Deleted."),
                    ));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
