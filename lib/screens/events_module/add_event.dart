import 'package:iscompanion/models/DeadlineEvent.dart';
import 'package:iscompanion/models/Subject.dart';
import 'package:iscompanion/models/Term.dart';
import 'package:iscompanion/providers/deadlineevent_provider.dart';
import 'package:iscompanion/providers/subject_provider.dart';
import 'package:iscompanion/screens/misc/course_picker.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class AddEvent extends StatefulWidget {
  final Term currTerm;
  final bool editMode;
  final DeadlineEvent? deadlineEvent;
  final Subject? course;
  const AddEvent(
      {super.key,
      required this.currTerm,
      this.editMode = false,
      this.deadlineEvent,
      this.course});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descCtrl = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  Subject? _selectedCourse;

  // validation flags
  bool _isDateInvalid = false;

  @override
  void initState() {
    super.initState();

    if (widget.editMode) {
      _descCtrl.text = widget.deadlineEvent!.description;
      _date = widget.deadlineEvent!.date;

      if (_date!.hour != 0 || _date!.minute != 0) {
        _time = TimeOfDay(hour: _date!.hour, minute: _date!.minute);
      }

      if (widget.deadlineEvent!.courseId != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _selectedCourse = Provider.of<SubjectProvider>(context, listen: false)
              .getSubjectByID(widget.deadlineEvent!.courseId);
        });
      }
    }

    if (widget.course != null) {
      _selectedCourse = widget.course;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: widget.editMode ? "Edit Event" : "Create Event"),
            InfoCard(content: "Fill out the required fields."),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 4),
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),
            _buildBody(context)
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // check if form is empty
          if (_canPop) {
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
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Enter Event Description',
                    labelText: 'Event Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the event description.";
                  }

                  return null;
                },
              ),
            ),

            Opacity(
              opacity: 0.5,
              child: Divider(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _coursePicker(context),
            ),

            Opacity(
              opacity: 0.5,
              child: Divider(),
            ),

            // Date Picker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _datePicker(context),
            ),

            // Time Picker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _timePicker(context),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_date == null) {
                    setState(() {
                      _isDateInvalid = true;
                    });

                    return;
                  }

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();

                    DateTime eventDate = _date!;
                    if (_time != null) {
                      eventDate = DateTime(eventDate.year, eventDate.month,
                          eventDate.day, _time!.hour, _time!.minute);
                    }

                    DeadlineEvent newEvent = DeadlineEvent()
                      ..courseId =
                          _selectedCourse == null ? -1 : _selectedCourse!.id!
                      ..termId = widget.currTerm.id!
                      ..description = _descCtrl.text.trim()
                      ..date = eventDate;

                    if (widget.editMode) {
                      newEvent.id = widget.deadlineEvent!.id;
                      context
                          .read<DeadlineEventProvider>()
                          .editDeadlineEvent(newEvent);
                    } else {
                      context
                          .read<DeadlineEventProvider>()
                          .createDeadlineEvent(newEvent);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Event ${widget.editMode ? "edited" : "created"}.")));

                    Navigator.pop(context, newEvent);
                  }
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primaryContainer)),
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _coursePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Course"),
            Row(
              children: [
                if (_selectedCourse != null)
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedCourse = null;
                        });
                      },
                      icon: Icon(Icons.cancel)),
                TextButton(
                    onPressed: () async {
                      var course = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CoursePicker(term: widget.currTerm)));

                      if (course != null) {
                        setState(() {
                          _selectedCourse = course;
                        });
                      }
                    },
                    child: Text(
                      _selectedCourse == null
                          ? "Unassigned"
                          : "${_selectedCourse!.courseCode} ${_selectedCourse!.isLaboratory ? "Lab" : "Lec"}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _timePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Time (Optional)"),
            Row(
              children: [
                if (_time != null)
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _time = null;
                        });
                      },
                      icon: Icon(Icons.cancel)),
                TextButton(
                    onPressed:
                        _date != null ? () => _showTimePicker(context) : null,
                    child: Text(
                      _time == null ? "Select Time" : _time!.format(context),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _datePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date"),
            Row(
              children: [
                if (_date != null)
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _date = null;
                        });
                      },
                      icon: Icon(Icons.cancel)),
                TextButton(
                    onPressed: () => _pickDateModal(context),
                    child: Text(
                      _date == null
                          ? "Select Date"
                          : DateFormat("MMM d, yyyy").format(_date!),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        ),
        if (_isDateInvalid)
          Text(
            "Please select a date.",
            style: TextStyle(
                color: Theme.of(context).colorScheme.error, fontSize: 12),
          ),
      ],
    );
  }

  void _showTimePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    final TimeOfDay? time = await showTimePicker(
        context: (context),
        initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
        helpText: "Select a time for your event.");

    if (time != null) {
      setState(() {
        _time = time;
      });
    }
  }

  void _pickDateModal(BuildContext context) async {
    DateTime? returnDate = await showDatePicker(
      helpText: "Select a valid date for your event.",
      context: context,
      firstDate: widget.currTerm.startDate,
      lastDate: widget.currTerm.endDate,
    );

    if (returnDate != null) {
      setState(() {
        _isDateInvalid = false;
        _date = returnDate;
      });
    }
  }

  // Responsible for "Discard creation?"
  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Discard event creation?"),
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

  bool get _canPop {
    if (widget.editMode) {
      DateTime eventDate = _date!;

      if (_time != null) {
        eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day,
            _time!.hour, _time!.minute);
      }

      return widget.deadlineEvent!.description.toLowerCase() ==
              _descCtrl.text.trim().toLowerCase() &&
          widget.deadlineEvent!.courseId ==
              (_selectedCourse == null ? -1 : _selectedCourse!.id!) &&
          eventDate.isAtSameMomentAs(widget.deadlineEvent!.date);
    }

    return _descCtrl.text.isEmpty &&
        _selectedCourse == null &&
        _date == null &&
        _time == null;
  }
}
