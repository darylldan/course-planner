import 'package:iscompanion/models/Subject.dart';
import 'package:iscompanion/providers/shared_course_provider.dart';
import 'package:iscompanion/widgets/cards/error_card_no_action.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;
import 'package:qr_flutter/qr_flutter.dart';

class ShareCourse extends StatefulWidget {
  final Subject course;

  const ShareCourse({super.key, required this.course});

  @override
  State<ShareCourse> createState() => _ShareCourseState();
}

class _ShareCourseState extends State<ShareCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(title: "Share Course"),
            _qrBody(context),
            SizedBox(
              height: 10,
            ),
            InfoCard(
                content:
                    "To share this course, scan the QR code below using another device running the IskoTrack app."),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget _qrBody(BuildContext context) {
    return FutureBuilder(
      future: _uploadCourse(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(C.cardBorderRadius)),
            child: Column(
              children: [
                Center(
                  child: QrImageView(
                    data: "${snapshot.data}",
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    eyeStyle: QrEyeStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        eyeShape: QrEyeShape.square),
                    dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${snapshot.data}",
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontFamily: "JetBrainsMono",
                            fontFamilyFallback: <String>["Courier"]),
                      ),
                      IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                    ClipboardData(text: "${snapshot.data}"))
                                .then((_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Copied to clipboard.')));
                              }
                            });
                          },
                          icon: Icon(
                            Icons.copy,
                            size: 18,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _dividerWithTitle("SHARING"),
                ),
                Text(
                  "${widget.course.courseCode} - ${widget.course.isLaboratory ? "Lab" : "Lec"}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: C.titleCardHeaderFontSize),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorCardNoAction(
              title: "COURSE NOT UPLOADED",
              content: "Unable to share course. Please try again later.");
        } else {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(C.cardBorderRadius)),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _dividerWithTitle(String title) {
    return Row(
      children: [
        Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _uploadCourse() async {
    String? res = await Provider.of<ShareCourseProvider>(context, listen: false)
        .uploadCourse(widget.course);

    return res;
  }
}
