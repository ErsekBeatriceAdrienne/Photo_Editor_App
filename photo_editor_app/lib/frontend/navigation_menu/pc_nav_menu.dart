import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../pages/edited_files/edited_files_page.dart';
import '../pages/editing_image/edit_images_page.dart';
import '../pages/editing_video/edit_videos_page.dart';
import '../pages/generate_ai/ai.dart';
import '../pages/profile/profile_page.dart';
import '../pages/profile/accent_color_provider.dart';

class PCMenu extends StatefulWidget {
  final VoidCallback toggleTheme;
  final String? userId;
  final bool isDarkMode;

  const PCMenu({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  State<PCMenu> createState() => _PCMenuState();
}

class _PCMenuState extends State<PCMenu> {
  int _currentIndex = 0;
  double sidebarWidth = 220;

  final double _minSidebarWidth = 70;
  final double _maxSidebarWidth = 280;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      EditImagesPage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
      EditVideosPage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
      AiPage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
      EditedFilesPage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
      ProfilePage(
        onToggleTheme: widget.toggleTheme,
        userId: widget.userId,
        isDarkMode: widget.isDarkMode,
      ),
    ];
  }

  List<Map<String, dynamic>> _navItems(BuildContext context) => [
    {
      "icon": Icons.insert_photo_outlined,
      "label": AppLocalizations.of(context)!.home_page_title,
    },
    {
      "icon": Icons.camera_roll_outlined,
      "label": AppLocalizations.of(context)!.edit_page_title,
    },
    {
      "icon": Icons.generating_tokens_outlined,
      "label": AppLocalizations.of(context)!.ai_page_title,
    },
    {
      "icon": Icons.folder_open_rounded,
      "label": AppLocalizations.of(context)!.edited_page_title,
    },
    {
      "icon": Icons.person,
      "label": AppLocalizations.of(context)!.profile_page_title,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final accentColor = Provider.of<AccentColorProvider>(context).accentColor;
    final navItems = _navItems(context);

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.01)
                : Colors.white.withOpacity(0.01),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: (details) {
                    setState(() {
                      sidebarWidth += details.delta.dx;
                      sidebarWidth = sidebarWidth.clamp(_minSidebarWidth, _maxSidebarWidth);
                    });
                  },
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        width: sidebarWidth,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.4)
                              : Colors.white.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(2, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            ...navItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final icon = entry.value["icon"] as IconData;
                              final label = entry.value["label"] as String;
                              final selected = index == _currentIndex;

                              final iconColor = selected
                                  ? accentColor
                                  : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black54;

                              return ListTile(
                                leading: Icon(icon, color: iconColor),
                                title: sidebarWidth > _minSidebarWidth + 10
                                    ? Text(
                                  label,
                                  overflow: TextOverflow.ellipsis, 
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight:
                                    selected ? FontWeight.bold : FontWeight.normal,
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
                ),
              ),
              Expanded(child: _pages[_currentIndex]),
            ],
          ),
        ),
      ],
    );
  }

}
