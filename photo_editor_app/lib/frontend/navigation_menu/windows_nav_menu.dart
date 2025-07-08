import 'package:flutter/material.dart';
import 'package:photo_editor_app/frontend/pages/edit_photo/editing.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../pages/edited_photos/edited_photos.dart';
import '../pages/generate_ai/ai.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/accent_color_provider.dart';

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
  State<WindowsMenu> createState() => _WindowsMenuState();
}

class _WindowsMenuState extends State<WindowsMenu> {
  int _currentIndex = 0;
  double sidebarWidth = 220;

  final double _minSidebarWidth = 70;
  final double _maxSidebarWidth = 280;

  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> _navItems(BuildContext context) => [
    {
      "icon": Icons.home_outlined,
      "label": AppLocalizations.of(context)!.home_page_title,
      "widget": HomePage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
    },
    {
      "icon": Icons.photo_outlined,
      "label": AppLocalizations.of(context)!.edit_page_title,
      "widget": EditingPage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
    },
    {
      "icon": Icons.generating_tokens_outlined,
      "label": AppLocalizations.of(context)!.ai_page_title,
      "widget": AiPage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
    },
    {
      "icon": Icons.folder_open_rounded,
      "label": AppLocalizations.of(context)!.edited_page_title,
      "widget": EditedPhotosPage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final accentColor = Provider.of<AccentColorProvider>(context).accentColor;
    final navItems = _navItems(context);

    return Scaffold(
      body: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) {
                setState(() {
                  sidebarWidth += details.delta.dx;
                  sidebarWidth = sidebarWidth.clamp(_minSidebarWidth, _maxSidebarWidth);
                });
              },
              child: Container(
                width: sidebarWidth,
                color: Theme.of(context).drawerTheme.backgroundColor ??
                    (Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF141414)
                        : Colors.grey[100]),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    ...navItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      IconData icon = entry.value["icon"];
                      String label = entry.value["label"];
                      bool selected = index == _currentIndex;

                      final iconColor = selected
                          ? accentColor
                          : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54;

                      return ListTile(
                        leading: Icon(
                          icon,
                          color: iconColor,
                        ),
                        title: sidebarWidth > _minSidebarWidth + 10
                            ? Text(
                          label,
                          style: TextStyle(
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            color: selected ? accentColor : iconColor,
                          ),
                        )
                            : null,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: navItems[_currentIndex]["widget"]),
        ],
      ),
    );
  }
}
