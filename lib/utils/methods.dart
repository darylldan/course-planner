import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:path_provider/path_provider.dart';

Future<ShareResult> mdToPDF({required String title, required String md}) async {
  final List<Widget> markdownWidgets = await HTMLToPdf().convertMarkdown(md);
  final markdownPdf = Document();
  markdownPdf.addPage(MultiPage(
    build: (context) => markdownWidgets,
  ));
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/$title.pdf");

  await file.writeAsBytes(await markdownPdf.save());

  final result = await Share.shareXFiles([XFile("${output.path}/$title.pdf")]);

  return result;
}
