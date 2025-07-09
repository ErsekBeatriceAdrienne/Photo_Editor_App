import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../profile/accent_color_provider.dart';

class EditedFilesPage extends StatelessWidget {
  const EditedFilesPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;

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
              // Appbar
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
                  AppLocalizations.of(context)!.edited_page_title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  /*child: Text(
                    userId == null
                        ? AppLocalizations.of(context)!.not_logged_in
                        : '${AppLocalizations.of(context)!.logged_in_as} $userId',
                    style: const TextStyle(fontSize: 18),
                  ),*/
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


