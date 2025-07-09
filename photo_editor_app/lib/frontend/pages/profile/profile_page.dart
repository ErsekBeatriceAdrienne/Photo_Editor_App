import 'dart:ui';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Provider.of<AccentColorProvider>(context).accentColor;
    final backgroundColor = Theme.of(context).drawerTheme.backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF141414)
            : Colors.grey[100]);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
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
                // If this enabled than it's blurry
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
                    icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
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
                          builder: (context) => AccentColorPickerBottomSheet(
                            currentColor: accentColor,
                            onColorSelected: (newColor) async {
                              // Ez a sor új:
                              await Provider.of<AccentColorProvider>(context, listen: false).setAccentColor(newColor);
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      }
                  ),
                ),

              ),
            ],
          ),
        ],
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