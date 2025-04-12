import 'dart:io';

import 'package:iskotrack/models/SharedCourse.dart';
import 'package:iskotrack/models/Term.dart';
import 'package:iskotrack/providers/shared_course_provider.dart';
import 'package:iskotrack/screens/classes_module/add_class.dart';
import 'package:iskotrack/screens/classes_module/scan_course_subm/qr_scanner_screen.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart' as C;

class ScanCourse extends StatefulWidget {
  final Term term;

  const ScanCourse({super.key, required this.term});

  @override
  State<ScanCourse> createState() => _ScanCourseState();
}

class _ScanCourseState extends State<ScanCourse> {
  final TextEditingController _codeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Scan Course"),
            InfoCard(
              content:
                  "To download course, you can either scan the QR code by pressing the 'Scan' button or manually enter the code in the field below.",
            ),
            SizedBox(
              height: 16,
            ),
            _body(context)
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onSecondaryContainer),
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.secondaryContainer)),
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

              bool internetCheck = await hasNetwork();

              if (context.mounted) Navigator.pop(context);

              if (isCancelled) return;

              if (!internetCheck) {
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
                      builder: (context) => QrScannerScreen(term: widget.term)),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Scan QR",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(),
        ),
        TextField(
          controller: _codeCtrl,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              hintText: 'Enter code provided by IskoTrack',
              labelText: 'Code'),
          style: TextStyle(fontFamily: "JetBrainsMono"),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer),
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer)),
            onPressed: () async {
              if (_codeCtrl.text.trim().isEmpty || _codeCtrl.text.length < 20) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Invalid code.")));
                return;
              }

              if (context
                  .read<ShareCourseProvider>()
                  .isCourseMine(_codeCtrl.text.trim())) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("This course is yours.")));
                return;
              }
              bool isCancelled = false;

              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Getting course..."),
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

              if (context.mounted) {
                if (isCancelled) {
                  Navigator.pop(context);
                  return;
                }

                if (!internet) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No internet connection.")));
                  return;
                }

                SharedCourse? sc = await context
                    .read<ShareCourseProvider>()
                    .downloadCourse(_codeCtrl.text);

                if (context.mounted) {
                  Navigator.pop(context);
                  if (sc == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Course not found.")));

                    return;
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddClass(
                                term: widget.term,
                                sc: sc,
                                fromSharing: true,
                              )));
                }
              }
            },
            child: Text(
              "Get Course",
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
