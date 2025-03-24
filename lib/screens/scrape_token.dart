import 'package:course_planner/models/Note.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/screens/notes_module.dart/view_note.dart';
import 'package:course_planner/utils/enums.dart';
import 'package:course_planner/widgets/cards/course_notes_card.dart';
import 'package:course_planner/widgets/cards/note_card.dart';
import 'package:course_planner/widgets/elements/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/constants.dart' as C;

class ScrapeToken extends StatefulWidget {
  const ScrapeToken({super.key});

  State<ScrapeToken> createState() => _ScrapeTokenState();
}

class _ScrapeTokenState extends State<ScrapeToken> {

  late final WebViewController _webViewController;
  final storage = const FlutterSecureStorage();
  bool _isLoading = true;
  bool _isLoggedIn = false; // Track login state

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Safari/537.36')
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _isLoading = true),
          onPageFinished: (url) async {
            setState(() => _isLoading = false);
            debugPrint('Current URL: $url');

            // Check if user reached the dashboard (post-login)
            if (url.contains('amis.uplb.edu.ph/auth/callback/?token') &&
                !_isLoggedIn) {
              setState(() => _isLoggedIn = true);
              String rawToken = url.split("token=").last;
                print("Token extracted: token is ${Uri.decodeFull(rawToken)}");
              // if (token != null && mounted) {
              //   await storage.write(key: 'school_token', value: token);
              //   // Navigator.pop(context, token);
              // }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://amis.uplb.edu.ph/auth/login/')); // Initial login URL
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: SideDrawer(parent: "/test-screen"),
        body: WebViewWidget(controller: _webViewController));
  }

  
}
