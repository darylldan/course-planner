import 'package:iscompanion/widgets/elements/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:webview_flutter/webview_flutter.dart';
import '../utils/constants.dart' as C;

class ScrapeToken extends StatefulWidget {
  const ScrapeToken({super.key});

  State<ScrapeToken> createState() => _ScrapeTokenState();
}

class _ScrapeTokenState extends State<ScrapeToken> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  Future<void> clearWebViewData() async {
    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();

    // Clear cache
    await _webViewController.clearCache();

    // Optional: clear localStorage and sessionStorage
    await _webViewController.runJavaScript(
        'window.localStorage.clear(); window.sessionStorage.clear();');
  }
  // Track login state

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
              Navigator.pop(context);
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
    clearWebViewData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: SideDrawer(parent: "/test-screen"),
        body: WebViewWidget(controller: _webViewController));
  }
}
