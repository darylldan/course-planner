import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/widgets/cards/error_card_no_action.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Term.dart';
import '../../utils/constants.dart' as C;
import '../../utils/enums.dart';

class SearchClass extends StatefulWidget {
  const SearchClass({super.key});

  @override
  State<SearchClass> createState() => _SearchClassState();
}

class _SearchClassState extends State<SearchClass> {
  final _searchValue = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<Subject> _subjects = [];
  List<Term> _terms = [];
  Term? _globalCurrentTerm;

  final Day _today = DayMethods.fromInt(DateTime.now().weekday);
  Term? _currentTerm;

  int? _termFilter;
  Set<Day> _freqFilter = <Day>{};

  /*
   * null = show all;
   * true = lab
   * false = lec
   */
  bool? _classTypeFilter;

  bool _termFilterFlag = false;
  bool _freqFilterFlag = false;
  bool _classTypeFilterFlag = false;

  @override
  Widget build(BuildContext context) {
    _subjects = context.watch<SubjectProvider>().subjects;
    _terms = context.watch<TermProvider>().terms;
    _globalCurrentTerm = context.watch<TermProvider>().currentTerm;

    _currentTerm ??= _globalCurrentTerm;

    if (_terms.isEmpty && !_isFilterActive()) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                  content:
                      "Begin by adding a term on the terms page. Once a term is added, you can proceed to create a subject under that term on the Classes page.")
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _searchBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: _buildResults(context),
        ),
      ),
    );
  }

  AppBar _searchBar() {
    return AppBar(
      title: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
            onPressed: () {
              _searchValue.clear();
            },
            icon: const Icon(Icons.clear_rounded),
          ),
          ),
          controller: _searchValue,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      actions: [
        _isFilterActive()
            ? Badge(
                child: IconButton(
                  onPressed: () {
                    _showFilterPanel();
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                ),
              )
            : IconButton(
                onPressed: () {
                  _showFilterPanel();
                },
                icon: const Icon(Icons.filter_alt_rounded)),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    if (_searchValue.text.trim().isEmpty && !_isFilterActive()) {
      return Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InfoCard(
              content:
                  "Start by typing the course code above. Click the filter button to enhance your search.")
        ],
      );
    }

    List<Subject> results = _subjects.where(
      (s) {
        return s.termID == _currentTerm!.id! &&
            s.courseCode
                .toLowerCase()
                .contains(_searchValue.text.toLowerCase().trim());
      },
    ).toList();

    if (_termFilterFlag) {
      if (_termFilter == null) {
        results = _subjects;
      } else {
        results = _subjects.where(
          (s) {
            return s.termID == _termFilter &&
                s.courseCode
                    .toLowerCase()
                    .contains(_searchValue.text.toLowerCase());
          },
        ).toList();
      }
    }

    if (_freqFilterFlag) {
      results = results.where((s) {
        if (_freqFilter.length == 1) {
          return s.frequency.any((d) => _freqFilter.contains(d));
        }
        return _freqFilter.every((d) => s.frequency.contains(d));
      }).toList();
    }

    if (_classTypeFilterFlag) {
      results = results.where((s) {
        return s.isLaboratory == _classTypeFilter!;
      }).toList();
    }

    List<ClassCard> resultsCard =
        results.map((s) => ClassCard(subject: s)).toList();

    if (resultsCard.isEmpty) {
      return const Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ErrorCardNoAction(title: "RESULTS", content: "No results found.")
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _resultHeader(),
        ),
        ...resultsCard,
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Center(
          child: Text(
            "${resultsCard.length} ${resultsCard.length == 1 ? "Subject" : "Subjects"}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.surfaceVariant),
          ),
        ),
        const SizedBox(
          height: 120,
        )
      ],
    );
  }

  Widget _resultHeader() {
    return Row(
      children: [
        const Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "SEARCH RESULT",
            style: TextStyle(
              color: Theme.of(context).colorScheme.surfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
      ],
    );
  }

  void _showFilterPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: ((context, setModalState) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: SizedBox(
              height: 500,
              width: double.infinity,
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Filters",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _termSelector(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: _classTypeSelector(),
                        ),
                        const Text("Frequency"),
                        const SizedBox(
                          height: 10,
                        ),
                        SegmentedButton<Day>(
                          segments: const [
                            ButtonSegment<Day>(
                                value: Day.mon,
                                label: Text(
                                  "Mo",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            ButtonSegment<Day>(
                                value: Day.tue,
                                label: Text(
                                  "Tu",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            ButtonSegment<Day>(
                                value: Day.wed,
                                label: Text(
                                  "We",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            ButtonSegment<Day>(
                                value: Day.thu,
                                label: Text(
                                  "Th",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            ButtonSegment<Day>(
                                value: Day.fri,
                                label: Text(
                                  "Fr",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            ButtonSegment<Day>(
                                value: Day.sat,
                                label: Text(
                                  "Sa",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                          selected: _freqFilter,
                          onSelectionChanged: (Set<Day> newSelection) {
                            setModalState(() {
                              _freqFilter = newSelection;
                            });
                          },
                          multiSelectionEnabled: true,
                          emptySelectionAllowed: true,
                          selectedIcon: const Icon(Icons.check_rounded),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.onPrimaryContainer),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.primaryContainer)),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          if (_freqFilter.isNotEmpty) {
                            _freqFilterFlag = true;
                          } else {
                            _freqFilterFlag = false;
                          }
                        });
                      },
                      child: const Text(
                        "Apply",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setModalState(() {
                          _termFilter = null;
                          _freqFilter = <Day>{};
                          _classTypeFilter = null;

                          _termFilterFlag = false;
                          _freqFilterFlag = false;
                          _classTypeFilterFlag = false;
                        });
                      },
                      child: const Text(
                        "Clear",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
      },
    );
  }

  Widget _termSelector() {
    List<DropdownMenuEntry<int?>> termEntries = [];

    for (var t in _terms) {
      String label = "${t.semester}, ${t.academicYear}";

      if (label.length > 36) {
        label = "${label.substring(0, 37)}...";
      }

      termEntries.add(DropdownMenuEntry<int?>(
          value: t.id,
          label: label,
          trailingIcon:
              t.isCurrentTerm ? const Icon(Icons.star_rounded) : null));
    }

    termEntries.add(const DropdownMenuEntry<int?>(
      value: null,
      label: "Show classes from all terms",
    ));

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownMenu<int?>(
        width: 343,
        inputDecorationTheme: InputDecorationTheme(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        label: const Text("Term"),
        dropdownMenuEntries: termEntries,
        initialSelection: _termFilterFlag ? _termFilter : _currentTerm!.id,
        onSelected: (int? i) {
          if (i == _currentTerm!.id) {
            _termFilterFlag = false;
            return;
          }
          _termFilter = i;
          _termFilterFlag = true;
        },
      ),
    );
  }

  Widget _classTypeSelector() {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownMenu<bool?>(
        width: 343,
        inputDecorationTheme: InputDecorationTheme(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        label: const Text("Class Type"),
        dropdownMenuEntries: const <DropdownMenuEntry<bool?>>[
          DropdownMenuEntry<bool?>(
            value: null,
            label: "Show all",
          ),
          DropdownMenuEntry<bool?>(
            value: true,
            label: "Laboratory",
          ),
          DropdownMenuEntry<bool?>(
            value: false,
            label: "Lecture",
          ),
        ],
        initialSelection: _classTypeFilter,
        onSelected: (bool? b) {
          if (b != null) {
            _classTypeFilter = b;
            _classTypeFilterFlag = true;
          } else {
            _classTypeFilter = b;
            _classTypeFilterFlag = false;
          }
        },
      ),
    );
  }

  bool _isFilterActive() {
    return _classTypeFilterFlag || _freqFilterFlag || _termFilterFlag;
  }
}
