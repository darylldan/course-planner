import 'dart:io';
import 'dart:math';

import 'package:course_planner/widgets/cards/error_card.dart';
import 'package:course_planner/widgets/elements/drawer.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/constants.dart' as C;

/*
 *  Credits: https://stackoverflow.com/questions/60906358/how-create-animation-emoji-rain-with-flutter
 */

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: View(
        numberOfItems: 40,
      ),
    );
  }
}

// The item that will rain
class Item {
  static final random = Random();
  final double _size = 40;
  late Text _sunflower;

  late Alignment _alignment;

  Item() {
    _alignment =
        Alignment(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1);
    _sunflower = Text(
      "🌻",
      style: TextStyle(fontSize: _size - 10),
    );
  }
}

// Main view
class View extends StatefulWidget {
  late final int numberOfItems;

  View({Key? key, required this.numberOfItems}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> with SingleTickerProviderStateMixin {
  final _screenTitle = "About";
  final _route = "/about";
  var items = <Item>[];
  var started = false;

  late AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SideDrawer(parent: _route),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: C.screenHorizontalPadding),
              child: _aboutScreen(context),
            ),
          ),
          ...buildItems()
        ],
      ),
    );
  }

  Widget _aboutScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(title: _screenTitle),
        _appInfo(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Opacity(
            opacity: 0.5,
            child: Divider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _devInfo(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _feedback(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _nerdHeader(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _nerdContent(),
        ),
        const SizedBox(
          height: 150,
        )
      ],
    );
  }

  Widget _nerdHeader() {
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
            "NERD SECTION",
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

  Widget _nerdContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: double.infinity,
          child: FlutterLogo(size: 80),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Made with Flutter, this app utilizes Provider for state management and the Isar database for data persistence. All widgets are native Material widgets, and interfaces such as the weekly timetable and daily schedule employ containers and sized boxes.\n\nImage assets, such as the Github logo and the Discord logo, were obtained from their respective branding guideline websites. The Android version uses the \"Inter\" font, while the iOS app utilizes the default font.\n\nThe sunflower rain (click the app logo!) originates from a piece of code posted by @Josteve on StackOverflow.\n\nThis app is a side project of mine and is not entirely bug-free. It operates entirely offline, ensuring that no user data is collected (mainly because idk how jk). All data used by the app is stored locally.\n\nTo explore the source code of this project, click the button below.\n",
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            String url = "https://github.com/darylldan/course-planner";
            var urlLaunchable = await canLaunchUrlString(url);
            if (urlLaunchable) {
              await launchUrlString(url,
                  mode: Platform.isAndroid
                      ? LaunchMode.externalApplication
                      : LaunchMode.platformDefault);
            } else {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Dialog(
                      child: ErrorCard(
                        title: "ERROR",
                        content: "Failed to launch link.",
                      ),
                    );
                  },
                );
              }
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Check the code on GitHub",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.navigate_next_rounded)
            ],
          ),
        )
      ],
    );
  }

  Widget _feedback() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String url = "https://forms.gle/DwKwhx2G12tZ2DB69";
          var urlLaunchable = await canLaunchUrlString(url);
          if (urlLaunchable) {
            await launchUrlString(
              url,
              mode: Platform.isAndroid
                  ? LaunchMode.externalApplication
                  : LaunchMode.platformDefault,
            );
          } else {
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) {
                  return const Dialog(
                    child: ErrorCard(
                      title: "ERROR",
                      content: "Failed to launch link.",
                    ),
                  );
                },
              );
            }
          }
        },
        child: const Text(
          "Report Bug or Suggest Feature",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _appInfo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          GestureDetector(
            onTap: makeItems,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      strokeAlign: BorderSide.strokeAlignOutside)),
              child: const Image(
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                image: AssetImage('assets/images/icon.png'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            C.appName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const Text(
            C.appVersion,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
          ),
          const Text(
            C.appDescription,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget _devInfo() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: C.titleCardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: C.cardIconSize,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
              ),
              Text(
                "Dev",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    fontSize: C.titleCardHeaderFontSize),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _devContacts(context,
              platform: "darylldan",
              content: "https://github.com/darylldan",
              assetLink: 'assets/images/github-logo.png',
              isWeb: true),
          Opacity(
            opacity: 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                  color: Theme.of(context).colorScheme.onTertiaryContainer),
            ),
          ),
          _devContacts(context,
              platform: "daryllc",
              content: "daryllc",
              assetLink: 'assets/images/discord-mark-white.png',
              isWeb: false),
          Opacity(
            opacity: 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                  color: Theme.of(context).colorScheme.onTertiaryContainer),
            ),
          ),
          _devContacts(context,
              platform: "Email",
              content: "dccaponpon@up.edu.ph",
              isWeb: false,
              useIconsInstead: true,
              iconData: Icons.alternate_email_rounded)
        ],
      ),
    );
  }

  Widget _devContacts(BuildContext context,
      {required String platform,
      required String content,
      String? assetLink,
      required bool isWeb,
      bool useIconsInstead = false,
      IconData? iconData}) {
    return Material(
      borderRadius: BorderRadius.circular(C.cardBorderRadius),
      child: Ink(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer),
        child: InkWell(
          borderRadius: BorderRadius.circular(C.cardBorderRadius),
          onTap: isWeb
              ? () async {
                  String url = content;
                  var urlLaunchable = await canLaunchUrlString(url);
                  if (urlLaunchable) {
                    await launchUrlString(url,
                        mode: Platform.isAndroid
                            ? LaunchMode.externalApplication
                            : LaunchMode.platformDefault);
                  } else {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(
                            child: ErrorCard(
                              title: "ERROR",
                              content: "Failed to launch link.",
                            ),
                          );
                        },
                      );
                    }
                  }
                }
              : () async {
                  await Clipboard.setData(ClipboardData(text: content));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Copied to clipboard!")));
                  }
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  (!useIconsInstead)
                      ? Image(
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                          image: AssetImage(assetLink!),
                        )
                      : Icon(
                          iconData!,
                          size: 30,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                  const SizedBox(width: 20),
                  Text(
                    platform,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              ),
              isWeb
                  ? Icon(
                      Icons.navigate_next_rounded,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      size: 30,
                    )
                  : Icon(
                      Icons.copy_rounded,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      size: 30,
                    )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildItems() {
    return items.map((item) {
      var tween = Tween<Offset>(
              begin: Offset(0, Random().nextDouble() * -1 - 1),
              end: Offset(Random().nextDouble() * 0.5, 2))
          .chain(CurveTween(curve: Curves.slowMiddle));
      return SlideTransition(
        position: animationController.drive(tween),
        child: AnimatedAlign(
          alignment: item._alignment,
          duration: const Duration(seconds: 3),
          child: AnimatedContainer(
            duration: const Duration(seconds: 3),
            width: item._size,
            height: item._size,
            child: item._sunflower,
          ),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  // starts the sunflower rain
  void makeItems() {
    setState(() {
      items.clear();
      for (int i = 0; i < widget.numberOfItems; i++) {
        items.add(Item());
      }
    });
    animationController.reset();
    animationController.forward();
  }
}
