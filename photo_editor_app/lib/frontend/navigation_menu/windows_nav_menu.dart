import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../pages/collages/collage_main_page.dart';
import '../pages/erase_background/eraser.dart';
import '../pages/gallery/edited_photos.dart';
import '../pages/generate_ai/ai.dart';
import '../pages/home/home_page.dart';

class WindowsMenu extends StatefulWidget {
  final VoidCallback toggleTheme;
  final String? userId;
  final bool isDarkMode;

  const WindowsMenu({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  _WindowsMenuState createState() => _WindowsMenuState();
}

class _WindowsMenuState extends State<WindowsMenu> {
  int _currentIndex = 0;

  // Function to update the pages list with the latest toggleTheme and userId
  List<Widget> _getPages() {
    return [
      HomePage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      CollagePage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      EraseBackgroundPage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      AiPage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      EditedPhotosPage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(AppLocalizations.of(context)!
                  .title),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!
                  .title),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!
                  .title),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!
                  .title),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!
                  .title),
              onTap: () {
                setState(() {
                  _currentIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _getPages()[_currentIndex],
    );
  }
}