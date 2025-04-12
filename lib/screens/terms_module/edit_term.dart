import 'package:iscompanion/providers/term_provider.dart';
import 'package:iscompanion/widgets/cards/current_term_card.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Term.dart';
import '../../utils/constants.dart' as Constants;
import 'package:intl/intl.dart';

enum DatePickerType { start, end }

class EditTerm extends StatefulWidget {
  final Term term;
  const EditTerm({super.key, required this.term});

  @override
  _EditTermState createState() => _EditTermState();
}

class _EditTermState extends State<EditTerm> {
  final _screenTitle = "Edit Term";
  final TextEditingController _semesterCtrl = TextEditingController();
  final TextEditingController _acadYearCtrl = TextEditingController();

  late DateTime? _startDate;
  late DateTime? _endDate;

  final _formKey = GlobalKey<FormState>();

  bool _isStarDateInvalid = false;
  bool _isEndDateInvalid = false;

  @override
  void initState() {
    super.initState();
    _semesterCtrl.text = widget.term.semester;
    _acadYearCtrl.text = widget.term.academicYear;
    _startDate = widget.term.startDate;
    _endDate = widget.term.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: _screenTitle),
              InfoCard(content: "Edit the field you want to change."),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 4),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
              CurrentTermCard(
                  term: widget.term,
                  onCurrentTerm: widget.term.isCurrentTerm,
                  editMode: true),
              const SizedBox(
                height: 14,
              ),
              _buildForm(context)
            ],
          )),
    );
  }

  Widget _buildForm(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Check if form is empty
          bool isFormEmpty = _acadYearCtrl.text.isEmpty &&
              _semesterCtrl.text.isEmpty &&
              _startDate == null &&
              _endDate == null;

          if (isFormEmpty) {
            if (context.mounted) Navigator.of(context).pop();
          } else {
            var shouldExit = await _onWillPop(context);
            if (shouldExit) {
              if (context.mounted) Navigator.of(context).pop();
            }
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _semesterCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Enter Name (Ex. "First Semester")',
                    labelText: 'Semester'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the semester.";
                  }

                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _acadYearCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Enter A.Y. (Ex. "A.Y. 2023 - 2024")',
                    labelText: 'Academic Year'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the Academic Year.";
                  }

                  return null;
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    _datePicker(context, DatePickerType.start),
                    _datePicker(context, DatePickerType.end)
                  ],
                )),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        textStyle: const WidgetStatePropertyAll(
                          TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primaryContainer),
                        foregroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                    onPressed: () {
                      bool isDatesValid = _validateDates();
                      if (_formKey.currentState!.validate() && isDatesValid) {
                        _formKey.currentState?.save();

                        widget.term.academicYear = _acadYearCtrl.text;
                        widget.term.semester = _semesterCtrl.text;
                        widget.term.startDate = _startDate!;
                        widget.term.endDate = _endDate!;

                        context.read<TermProvider>().editTerm(widget.term);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Changes saved.")));
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePicker(BuildContext context, DatePickerType dateType) {
    bool shouldShowError = (dateType == DatePickerType.start
        ? (_isStarDateInvalid)
        : (_isEndDateInvalid));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateType == DatePickerType.start ? "Start Date" : "End Date",
            ),
            TextButton(
              onPressed: dateType == DatePickerType.end && _startDate == null
                  ? null
                  : () => _pickDateModal(context, dateType),
              child: Text((dateType == DatePickerType.start
                  ? (_startDate == null
                      ? "Select Date"
                      : DateFormat("MMM d, yyyy").format(_startDate!))
                  : (_endDate == null
                      ? "Select Date"
                      : DateFormat("MMM d, yyyy").format(_endDate!)))),
            )
          ],
        ),
        if (shouldShowError)
          Text(
            "Please select a start date.",
            style: TextStyle(
                color: Theme.of(context).colorScheme.error, fontSize: 12),
          ),
      ],
    );
  }

  void _pickDateModal(BuildContext context, DatePickerType dateType) async {
    DateTime? returnDate = await showDatePicker(
      currentDate: dateType == DatePickerType.start
          ? _startDate ?? DateTime.now()
          : _endDate ?? _startDate!.add(Duration(days: 2)),
      context: context,
      firstDate: dateType == DatePickerType.end
          ? _startDate!.add(Duration(days: 1))
          : DateTime(1900),
      lastDate: DateTime(9999),
    );

    if (returnDate != null) {
      setState(() {
        if (dateType == DatePickerType.start) {
          _startDate = returnDate;
        } else {
          _endDate = returnDate;
        }
      });
    }
  }

  bool _validateDates() {
    _isStarDateInvalid = _startDate == null;
    _isEndDateInvalid = _endDate == null;

    setState(() {});
    return !(_isStarDateInvalid && _isEndDateInvalid);
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Discard changes?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Discard'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  )
                ],
              );
            })) ??
        false;
  }
}
