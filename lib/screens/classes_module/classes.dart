import 'dart:io';

import 'package:iskotrack/models/Subject.dart';
import 'package:iskotrack/providers/subject_provider.dart';
import 'package:iskotrack/providers/term_provider.dart';
import 'package:iskotrack/screens/classes_module/add_class.dart';
import 'package:iskotrack/screens/classes_module/scan_course_subm/scan_course.dart';
import 'package:iskotrack/screens/classes_module/search_class.dart';
import 'package:iskotrack/widgets/cards/current_term_selected.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/cards/subject_card.dart';
import 'package:iskotrack/widgets/elements/Drawer.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Term.dart';
import '../../utils/constants.dart' as C;

class Classes extends StatefulWidget {
  const Classes({super.key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final _screenTitle = "Courses";
  final _route = "/courses";
  late Term? currentTerm;
  late Term? _termSelectorValue;
  bool onCurrentTerm = true;
  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    if (onCurrentTerm) {
      currentTerm = context.watch<TermProvider>().currentTerm;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchClass()),
              );
            },
            icon: Icon(Icons.search_rounded),
          )
        ],
      ),
      drawer: SideDrawer(parent: _route),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: _buildClassesScreen(context),
      ),
      floatingActionButton: _showFab
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "scanqr",
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  onPressed: () async {
                    bool isCancelled = false;

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Checking for internet connection"),
                            content: IntrinsicHeight(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    isCancelled = true;

                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"))
                            ],
                          );
                        });

                    bool internet = await hasNetwork();

                    if (context.mounted) Navigator.pop(context);

                    if (isCancelled) return;

                    if (!internet) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Internet connection required for course sharing."),
                          ),
                        );
                      }
                      return;
                    }

                    if (context.mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScanCourse(
                                    term: currentTerm!,
                                  )));
                    }
                  },
                  child: Icon(Icons.qr_code_scanner,
                      color: Theme.of(context).colorScheme.onTertiaryContainer),
                ),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddClass(
                                  term: currentTerm!,
                                )));
                  },
                  label: const Text("Create Class"),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildClassesScreen(BuildContext context) {
    if (currentTerm == null) {
      _showFab = false;
      return _noTermsYet();
    } else {
      _showFab = true;
    }

    List<Subject> subjects = context
        .watch<SubjectProvider>()
        .subjects
        .where((e) => e.termID == currentTerm!.id)
        .toList();

    if (subjects.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: _screenTitle),
          _buildCurrentTerm(context),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Opacity(
              opacity: 0.5,
              child: Divider(),
            ),
          ),
          InfoCard(
            content: "No courses yet. Create one via the Add button below.",
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        _buildCurrentTerm(context),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Column(
          children: subjects.map<ClassCard>((c) {
            return ClassCard(subject: c);
          }).toList(),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Center(
          child: Text(
            "${subjects.length} ${subjects.length == 1 ? "Course" : "Courses"}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onInverseSurface),
          ),
        ),
        const SizedBox(
          height: 120,
        )
      ],
    );
  }

  Widget _noTermsYet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        InfoCard(
          content:
              "Begin by adding a term on the terms page. Once a term is added, you can proceed to create a course under that term on this page. Courses that you've added on IskoTrack will appear here.",
        )
      ],
    );
  }

  Widget _buildCurrentTerm(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: () {
            _showTermChanger(context);
          },
          child: CurrentTermSelectedCard(
            term: currentTerm!,
            editMode: false,
            onCurrentTerm: currentTerm!.isCurrentTerm,
          ),
        ),
      ),
    );
  }

  void _showTermChanger(BuildContext context) {
    _termSelectorValue = currentTerm;
    List<Term> terms = context.read<TermProvider>().terms;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Select Term",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _termSelector(context, terms),
                const SizedBox(
                  height: 15,
                ),
                InfoCard(
                  content:
                      "To change the current term, go to the Terms screen.",
                  fontSize: 14,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _termSelector(BuildContext context, List<Term> terms) {
    List<DropdownMenuEntry<int>> entries = [];

    for (var t in terms) {
      // Needed because the new dropdown menu does not catch text overflows
      String label = "${t.semester}, ${t.academicYear}";

      if (label.length > 36) {
        label = "${label.substring(0, 37)}...";
      }
      entries.add(
        DropdownMenuEntry(
          value: t.id!,
          label: label,
          trailingIcon: t.isCurrentTerm ? Icon(Icons.star_rounded) : null,
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: 343,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownMenu<int>(
              width: 343,
              initialSelection: currentTerm!.id,
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              label: const Text("Terms"),
              dropdownMenuEntries: entries,
              onSelected: (int? termID) {
                _termSelectorValue =
                    context.read<TermProvider>().getTermByID(termID!);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer),
                foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentTerm = _termSelectorValue;
                onCurrentTerm = _termSelectorValue!.isCurrentTerm;
              });
            },
            child: const Text(
              "View Term's Classes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
