import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../language_support/language_picker.dart';
import 'accent_color_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final accentColor = Provider
        .of<AccentColorProvider>(context)
        .accentColor;
    final backgroundColor = Theme
        .of(context)
        .drawerTheme
        .backgroundColor ??
        (Theme
            .of(context)
            .brightness == Brightness.dark
            ? const Color(0xFF141414)
            : Colors.grey[100]);

    final bool isMobile = Platform.isAndroid || Platform.isIOS;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: isMobile
          ? _buildMobileBody(context, accentColor, backgroundColor)
          : _buildDesktopBody(context, accentColor),
    );
  }

  Widget _buildMobileBody(BuildContext context, Color accentColor,
      Color? backgroundColor) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          pinned: false,
          expandedHeight: 50,
          leadingWidth: 90,
          automaticallyImplyLeading: false,
          centerTitle: true,
          floating: true,
          snap: true,
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: Container(
                color: backgroundColor?.withOpacity(0.5),
              ),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.profile_page_title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: LanguagePicker(isDarkMode: widget.isDarkMode),
            ),
            IconButton(
              icon:
              Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.onToggleTheme,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: const Icon(Icons.palette, size: 32),
              color: accentColor,
              tooltip: 'Accent szín kiválasztása',
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      AccentColorPickerBottomSheet(
                        currentColor: accentColor,
                        onColorSelected: (newColor) async {
                          await Provider.of<AccentColorProvider>(context,
                              listen: false)
                              .setAccentColor(newColor);
                        },
                      ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopBody(BuildContext context, Color accentColor) {
    final accentProvider = Provider.of<AccentColorProvider>(context, listen: false);

    final availableAccentColors = [
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.teal,
      Color(0xFFFFC1E3),
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sötét téma engedélyezése',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                CupertinoSwitch(
                  value: widget.isDarkMode,
                  onChanged: (val) {
                    widget.onToggleTheme();
                  },
                  activeColor: Colors.green,
                  trackColor: Colors.grey.shade400,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Alkalmazás nyelvének kiválasztása',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LanguagePicker(isDarkMode: widget.isDarkMode),
            const SizedBox(height: 30),

            const Text(
              'Accent szín',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: availableAccentColors.map((color) {
                final isSelected = accentColor == color;
                return GestureDetector(
                  onTap: () async {
                    await accentProvider.setAccentColor(color);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

}

/* Back button
leading: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: accentColor,
                    padding: const EdgeInsets.only(left: 8.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.back_button_text,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                    ),
                  ),
                ),
 */